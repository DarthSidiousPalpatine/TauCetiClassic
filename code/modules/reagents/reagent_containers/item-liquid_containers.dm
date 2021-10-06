/obj/item/weapon/reagent_containers/item_liquid_container
	name = "Container"
	desc = "..."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	w_class = SIZE_TINY

	//Liquid_vars
	var/gulp_size = 10

	//Item_vars
	var/list/can_hold = list() //List of objects which this item can store (if set, it can't store anything else)
	var/list/cant_hold = list() //List of objects which this item can't store (in effect only if can_hold isn't set)

	var/max_w_class = SIZE_TINY //Max size of objects that this object can store (in effect only if can_hold isn't set)
	var/max_storage_space = null //Total storage cost of items this can hold. Will be autoset based on storage_slots if left null.
	var/storage_slots = null //The number of storage slots in this container.

	var/use_to_pickup	//Set this to make it possible to use this item in an inverse way, so you can have the item in your hand and click items on the floor to pick them up.
	var/display_contents_with_number	//Set this to make the storage item group contents of the same type and display them as a number.
	var/allow_quick_empty	//Set this variable to allow the object to have the 'empty' verb, which dumps all the contents on the floor.
	var/allow_quick_gather	//Set this variable to allow the object to have the 'toggle mode' verb, which quickly collects all items from a tile.
	var/collection_mode = 1  //0 = pick one at a time, 1 = pick all on tile
	var/list/use_sound // sound played when used. null for no sound.

	var/storage_ui_path = /datum/storage_ui/default
	var/datum/storage_ui/storage_ui = null
	//initializes the contents of the storage with some items based on an assoc list. The assoc key must be an item path,
	//the assoc value can either be the quantity, or a list whose first value is the quantity and the rest are args.
	var/list/startswith

///////INITIALIZATION///////

/obj/item/weapon/reagent_containers/item_liquid_container/atom_init()
	. = ..()
	if (!possible_transfer_amounts)
		src.verbs -= /obj/item/weapon/reagent_containers/verb/set_APTFT
	var/datum/reagents/R = new/datum/reagents(volume)
	reagents = R
	R.my_atom = src
	add_initial_reagents()

	use_sound = SOUNDIN_RUSTLE

	if(allow_quick_empty)
		verbs += /obj/item/weapon/storage/proc/quick_empty

	if(allow_quick_gather)
		verbs += /obj/item/weapon/storage/proc/toggle_gathering_mode

	if(isnull(max_storage_space) && !isnull(storage_slots))
		max_storage_space = storage_slots * base_storage_cost(max_w_class)

	if(startswith)
		for(var/item_path in startswith)
			var/list/data = startswith[item_path]
			if(islist(data))
				var/qty = data[1]
				var/list/argsl = data.Copy()
				argsl[1] = src
				for(var/i in 1 to qty)
					new item_path(arglist(argsl))
			else
				for(var/i in 1 to (isnull(data)? 1 : data))
					new item_path(src)
		update_icon()

/obj/item/weapon/reagent_containers/item_liquid_container/Destroy()
	QDEL_NULL(storage_ui)
	return ..()

/obj/item/weapon/reagent_containers/item_liquid_container/examine(mob/user)
	..()
	if(!is_open_container())
		to_chat(user, "<span class='info'>Airtight lid seals it completely.</span>")

///////INTERACTION///////

/obj/item/weapon/reagent_containers/item_liquid_container/attack_self(mob/user)

	//Clicking on itself will empty it, if it has the verb to do that.
	if(user.get_active_hand() == src)
		if(verbs.Find(/obj/item/weapon/storage/proc/quick_empty))
			quick_empty()
			return

	if (is_open_container())
		to_chat(usr, "<span class = 'notice'>You put the lid on \the [src].</span>")
		flags ^= OPENCONTAINER
	else
		to_chat(usr, "<span class = 'notice'>You take the lid off \the [src].</span>")
		flags |= OPENCONTAINER

	// Close any open UI windows first
	for(var/mob/M in range(1))
		if (M.s_active == src)
			close(M)

/obj/item/weapon/reagent_containers/item_liquid_container/attack(mob/living/M, mob/user, def_zone)
	if (!is_open_container())
		return 0

	if(reagents.total_volume <= 0)
		to_chat(user, "<span class='warning'>None of [src] left, oh no!</span>")
		return 0

	if(!CanEat(user, M, src, "drink"))
		return

	var/fillevel = gulp_size

	if(M == user)
		if(user.a_intent != INTENT_HELP && user.a_intent != INTENT_HARM)
			gulp_whole()
			return

		if(isliving(M))
			var/mob/living/L = M
			L.taste_reagents(reagents)
		to_chat(M, "<span class='notice'>You swallow a gulp of [src].</span>")
		if(reagents.total_volume)
			reagents.trans_to_ingest(M, gulp_size)

		playsound(M, 'sound/items/drink.ogg', VOL_EFFECTS_MASTER, rand(10, 50))
		update_icon()
		return 1
	else
		M.visible_message("<span class='rose'>[user] attempts to feed [M] [src].</span>", \
						"<span class='warning'><B>[user]</B> attempts to feed you <B>[src]</B>.</span>")
		if(!do_mob(user, M))
			return
		M.visible_message("<span class='rose'>[user] feeds [M] [src].</span>", \
						"<span class='warning'><B>[user]</B> feeds you <B>[src]</B>.</span>")

		M.log_combat(user, "fed [name], reagents: [reagentlist(src)] (INTENT: [uppertext(user.a_intent)])")

		if(reagents.total_volume)
			reagents.trans_to_ingest(M, gulp_size)

		if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
			var/mob/living/silicon/robot/bro = user
			bro.cell.use(30)
			var/refill = reagents.get_master_reagent_id()
			addtimer(CALLBACK(reagents, /datum/reagents.proc/add_reagent, refill, fillevel), 600)

		playsound(M, 'sound/items/drink.ogg', VOL_EFFECTS_MASTER, rand(10, 50))
		update_icon()
		return 1

/obj/item/weapon/reagent_containers/item_liquid_container/attack_hand(mob/user)
	if (src.loc == user)
		open(user)
	else
		..()
		if(storage_ui)
			storage_ui.on_hand_attack(user)
	add_fingerprint(user)

//Should be merged into attack_hand() later, i mean whole attack_paw() proc, but thats probably a lot of work.
/obj/item/weapon/reagent_containers/item_liquid_container/attack_paw(mob/user) // so monkey, ian or something will open it, istead of unequip from back
	return attack_hand(user)                  // to unequip - there is drag n drop available for this task - same as humans do.

//This proc is called when you want to place an item into the storage item.
/obj/item/weapon/reagent_containers/item_liquid_container/attackby(obj/item/I, mob/user, params)
	if(isrobot(user))
		to_chat(user, "<span class='notice'>You're a robot. No.</span>")
		return //Robots can't interact with storage items. FALSE

	if(!can_be_inserted(I))
		return FALSE

	if(istype(I, /obj/item/weapon/implanter/compressed))
		return FALSE

	if(istype(I, /obj/item/weapon/packageWrap) && !(src in user)) //prevents package wrap being put inside the backpack when the backpack is not being worn/held (hence being wrappable)
		return FALSE

	I.add_fingerprint(user)
	handle_item_insertion(I)
	return TRUE

/obj/item/weapon/reagent_containers/item_liquid_container/afterattack(atom/target, mob/user, proximity, params)
	if(!proximity)
		return

	if (!is_open_container())
		to_chat(user, "<span class='notice'>You need to open [src]!</span>")
		return

	if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.
		var/obj/structure/reagent_dispensers/RD = target

		if(!RD.reagents.total_volume)
			to_chat(user, "<span class='warning'>[RD] is empty.</span>")
			return
		if (!reagents.maximum_volume) // Locked or broken container
			to_chat(user, "<span class='warning'> [src] can't hold this.</span>")
			return
		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, "<span class='warning'>[src] is full.</span>")
			return

		var/trans = RD.reagents.trans_to(src, RD.amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>You fill [src] with [trans] units of the contents of [target].</span>")

	else if(target.is_open_container()) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, "<span class='warning'>[src] is empty.</span>")
			return
		if(!target.reagents.maximum_volume)
			to_chat(user, "<span class='warning'> [target] can't hold this.</span>")
			return
		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, "<span class='warning'>[target] is full.</span>")
			return

		var/datum/reagent/refill
		var/datum/reagent/refillName
		if(isrobot(user))
			refill = reagents.get_master_reagent_id()
			refillName = reagents.get_master_reagent_name()

		var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>You transfer [trans] units of the solution to [target].</span>")

		if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
			var/mob/living/silicon/robot/bro = user
			var/chargeAmount = max(30,4*trans)
			bro.cell.use(chargeAmount)
			to_chat(user, "Now synthesizing [trans] units of [refillName]...")
			addtimer(CALLBACK(src, .proc/refill_by_borg, user, refill, trans), 300)

	else if((user.a_intent == INTENT_HARM) && reagents.total_volume && istype(target, /turf/simulated))
		to_chat(user, "<span class = 'notice'>You splash the solution onto [target].</span>")

		reagents.standard_splash(target, user=user)

/obj/item/weapon/reagent_containers/item_liquid_container/proc/refill_by_borg(user, refill, trans)
	reagents.add_reagent(refill, trans)
	to_chat(user, "Cyborg [src] refilled.")

/obj/item/weapon/reagent_containers/item_liquid_container/MouseDrop(obj/over_object, src_location, turf/over_location)
	if(src != over_object)
		remove_outline()
	if(!(ishuman(usr) || ismonkey(usr) || isIAN(usr))) //so monkeys can take off their backpacks -- Urist
		return
	if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech
		return

	var/mob/M = usr
	if(isturf(over_location) && over_object != M)
		if(M.incapacitated())
			return
		if(slot_equipped && (slot_equipped != SLOT_L_HAND && slot_equipped != SLOT_R_HAND))
			return
		if(!isturf(M.loc))
			return
		if(istype(src, /obj/item/weapon/storage/lockbox))
			var/obj/item/weapon/storage/lockbox/L = src
			if(L.locked)
				return
		if(istype(loc, /obj/item/weapon/storage)) //Prevent dragging /storage contents from backpack on floor.
			return
		if(M.a_intent == INTENT_HELP)
			var/dir_target = get_dir(M.loc, over_location)
			M.SetNextMove(CLICK_CD_MELEE)
			for(var/obj/item/I in contents)
				if(M.is_busy())
					return
				if(!Adjacent(M) || !over_location.Adjacent(src) || !over_location.Adjacent(M))
					return
				if(!do_after(M, 2, target = M))
					return
				remove_from_storage(I, M.loc)
				I.add_fingerprint(M)
				step(I, dir_target)
			add_fingerprint(M)
		return

	if(!over_object)
		return
	if(over_object == usr && Adjacent(usr)) // this must come before the screen objects only block
		open(usr)
		return
	if (!( istype(over_object, /atom/movable/screen) ))
		return ..()

	//makes sure that the storage is equipped, so that we can't drag it into our hand from miles away.
	//there's got to be a better way of doing this.
	if (!(src.loc == usr) || (src.loc && src.loc.loc == usr))
		return

	if (!usr.incapacitated())
		switch(over_object.name)
			if("r_hand")
				if(!M.unEquip(src))
					return
				M.put_in_r_hand(src)
			if("l_hand")
				if(!M.unEquip(src))
					return
				M.put_in_l_hand(src)
			if("mouth")
				if(!M.unEquip(src))
					return
				M.put_in_active_hand(src)
		add_fingerprint(usr)


///////INSERTION/REMOVAL///////

/obj/item/weapon/reagent_containers/item_liquid_container/proc/gulp_whole()
	set category = "Object"
	set name = "Gulp Down"
	set src in view(1)

	if(!is_open_container())
		to_chat(usr, "<span class='notice'>You need to open [src]!</span>")
		return

	usr.visible_message("<span class='notice'>[usr] prepares to gulp down [src].</span>", "<span class='notice'>You prepare to gulp down [src].</span>")

	if(!CanEat(usr, usr, src, eatverb="gulp"))
		return

	if(!do_after(usr, reagents.total_volume, target=src, can_move=FALSE))
		usr.visible_message("<span class='warning'>[usr] splashed the [src] all over!</span>", "<span class='warning'>You splashed the [src] all over!</span>")
		reagents.standard_splash(loc, user=usr)
		return

	if(!CanEat(usr, usr, src, eatverb="gulp"))
		return

	if(isliving(usr))
		var/mob/living/L = usr
		L.taste_reagents(reagents)

	usr.visible_message("<span class='notice'>[usr] gulped down the whole [src]!</span>", "<span class='notice'>You gulped down the whole [src]!</span>")
	reagents.trans_to_ingest(usr, reagents.total_volume)
	playsound(usr, 'sound/items/drink.ogg', VOL_EFFECTS_MASTER, rand(15, 55))
	update_icon()

//This proc handles items being inserted. It does not perform any checks of whether an item can or can't be inserted. That's done by can_be_inserted()
//The stop_warning parameter will stop the insertion message from being displayed. It is intended for cases where you are inserting multiple items at once,
//such as when picking up all the items on a tile with one click.
/obj/item/weapon/reagent_containers/item_liquid_container/proc/handle_item_insertion(obj/item/W, prevent_warning = FALSE, NoUpdate = FALSE)
	if(!istype(W))
		return FALSE
	if(usr)
		usr.remove_from_mob(W)
		usr.update_icons()	//update our overlays
	W.loc = src
	W.on_enter_storage(src)
	if(usr)
		if (usr.client && usr.s_active != src)
			usr.client.screen -= W
		W.dropped(usr)
		add_fingerprint(usr)

		if(!prevent_warning && !istype(W, /obj/item/weapon/gun/energy/crossbow))
			for(var/mob/M in viewers(usr, null))
				if (M == usr)
					to_chat(usr, "<span class='notice'>You put \the [W] into [src].</span>")
				else if (M in range(1)) //If someone is standing close enough, they can tell what it is...
					M.show_message("<span class='notice'>[usr] puts [W] into [src].</span>", SHOWMSG_VISUAL)
				else if (W && W.w_class >= SIZE_SMALL) //Otherwise they can only see large or normal items from a distance...
					M.show_message("<span class='notice'>[usr] puts [W] into [src].</span>", SHOWMSG_VISUAL)
		if(crit_fail && prob(25))
			remove_from_storage(W, get_turf(src))
		if(!NoUpdate)
			update_ui_after_item_insertion()
	var/obj/item/weapon/reagent_containers/Wcont = W
	if(Wcont.volume)
		reagents.trans_to(Wcont, 5)
	update_icon()
	return TRUE

//Call this proc to handle the removal of an item from the storage item. The item will be moved to the atom sent as new_target
/obj/item/weapon/reagent_containers/item_liquid_container/proc/remove_from_storage(obj/item/W, atom/new_location)
	if(!istype(W))
		return FALSE

	if(storage_ui)
		storage_ui.on_pre_remove(usr, W)

	if(new_location)
		if(ismob(loc))
			var/mob/M = loc
			W.dropped(M)
		if(ismob(new_location))
			W.layer = ABOVE_HUD_LAYER
			W.plane = ABOVE_HUD_PLANE
		else
			W.layer = initial(W.layer)
			W.plane = initial(W.plane)
		W.Move(new_location)
	else
		W.Move(get_turf(src))

	if(usr)
		update_ui_after_item_removal()
	if(W.maptext)
		W.maptext = ""
	W.on_exit_storage(src)
	return TRUE

/obj/item/weapon/reagent_containers/item_liquid_container/proc/gather_all(turf/T, mob/user)
	var/success = 0
	var/failure = 0

	for(var/obj/item/I in T)
		if(!can_be_inserted(I, user, 0))	// Note can_be_inserted still makes noise when the answer is no
			failure = 1
			continue
		success = 1
		handle_item_insertion(I, TRUE, TRUE) // First 1 is no messages, second 1 is no ui updates
	if(success && !failure)
		to_chat(user, "<span class='notice'>You put everything into \the [src].</span>")
		update_ui_after_item_insertion()
	else if(success)
		to_chat(user, "<span class='notice'>You put some things into \the [src].</span>")
		update_ui_after_item_insertion()
	else
		to_chat(user, "<span class='notice'>You fail to pick anything up with \the [src].</span>")

/obj/item/weapon/reagent_containers/item_liquid_container/proc/quick_empty()
	set name = "Empty Contents"
	set category = "Object"

	if((!ishuman(usr) && (src.loc != usr)) || usr.incapacitated())
		return

	var/turf/T = get_turf(src)
	hide_from(usr)
	for(var/obj/item/I in contents)
		remove_from_storage(I, T)
	finish_bulk_removal()


///////TECHNICAL PROCS///////

/obj/item/weapon/reagent_containers/item_liquid_container/proc/return_inv()
	var/list/L = list(  )
	L += contents

	for(var/obj/item/weapon/storage/S in src)
		L += S.return_inv()
	return L

/obj/item/weapon/reagent_containers/item_liquid_container/proc/show_to(mob/user as mob)
	if(storage_ui)
		storage_ui.show_to(user)

/obj/item/weapon/reagent_containers/item_liquid_container/throw_at(atom/target, range, speed, mob/thrower, spin = TRUE, diagonals_first = FALSE, datum/callback/callback)
	if(storage_ui)
		storage_ui.close_all()
	return ..()

/obj/item/weapon/reagent_containers/item_liquid_container/proc/hide_from(mob/user as mob)
	if(storage_ui)
		storage_ui.hide_from(user)

/obj/item/weapon/reagent_containers/item_liquid_container/proc/open(mob/user)
	if (length(use_sound))
		playsound(src, pick(use_sound), VOL_EFFECTS_MASTER, null, FALSE, null, -5)

	prepare_ui()
	storage_ui.on_open(user)
	show_to(user)

/obj/item/weapon/reagent_containers/item_liquid_container/proc/prepare_ui()
	if(!storage_ui)
		storage_ui = new storage_ui_path(src)

	storage_ui.prepare_ui()

/obj/item/weapon/reagent_containers/item_liquid_container/proc/close(mob/user)
	hide_from(user)
	if(storage_ui)
		storage_ui.after_close(user)

/obj/item/weapon/reagent_containers/item_liquid_container/proc/close_all()
	if(storage_ui)
		return storage_ui.close_all()

/obj/item/weapon/reagent_containers/item_liquid_container/proc/storage_space_used()
	. = 0
	for(var/obj/item/I in contents)
		. += I.get_storage_cost()

//This proc return 1 if the item can be picked up and 0 if it can't.
//Set the stop_messages to stop it from printing messages
/obj/item/weapon/reagent_containers/item_liquid_container/proc/can_be_inserted(obj/item/W, stop_messages = FALSE)
	if(!istype(W) || (W.flags & ABSTRACT) || W.anchored)
		return FALSE//Not an item

	if(loc == W)
		return FALSE //Means the item is already in the storage item

	if(storage_slots != null && contents.len >= storage_slots)
		if(!stop_messages)
			to_chat(usr, "<span class='notice'>[src] is full, make some space.</span>")
		return FALSE //Storage item is full

	if(can_hold.len)
		var/ok = FALSE
		for(var/A in can_hold)
			if(istype(W, A))
				ok = TRUE
				break
		if(!ok)
			if(!stop_messages)
				if (istype(W, /obj/item/weapon/hand_labeler))
					return FALSE
				to_chat(usr, "<span class='notice'>[src] cannot hold [W].</span>")
			return FALSE

	for(var/A in cant_hold) //Check for specific items which this container can't hold.
		if(istype(W, A))
			if(!stop_messages)
				to_chat(usr, "<span class='notice'>[src] cannot hold [W].</span>")
			return FALSE

	if (max_w_class != null && W.w_class > max_w_class)
		if(!stop_messages)
			to_chat(usr, "<span class='notice'>[W] is too big for this [src].</span>")
		return FALSE

	if(W.w_class >= src.w_class && (istype(W, /obj/item/weapon/storage)))
		if(!istype(src, /obj/item/weapon/storage/backpack/holding))	//bohs should be able to hold backpacks again. The override for putting a boh in a boh is in backpack.dm.
			if(!stop_messages)
				to_chat(usr, "<span class='notice'>[src] cannot hold [W] as it's a storage item of the same size.</span>")
			return FALSE //To prevent the stacking of same sized storage items.

	// by design SIZE_LARGE can't be placed in storages
	// and now this check works correctly
	if(W.w_class >= SIZE_LARGE)
		if(!stop_messages)
			to_chat(usr, "<span class='notice'>\The [W] cannot be placed in [src].</span>")
		return FALSE

	var/total_storage_space = W.get_storage_cost()
	total_storage_space += storage_space_used() //Adds up the combined w_classes which will be in the storage item if the item is added to it.
	if(total_storage_space > max_storage_space)
		if(!stop_messages)
			to_chat(usr, "<span class='notice'>\The [src] is too full, make some space.</span>")
		return FALSE

	return TRUE

/obj/item/weapon/reagent_containers/item_liquid_container/proc/update_ui_after_item_insertion()
	prepare_ui()
	if(storage_ui)
		storage_ui.on_insertion(usr)

/obj/item/weapon/reagent_containers/item_liquid_container/proc/update_ui_after_item_removal()
	prepare_ui()
	if(storage_ui)
		storage_ui.on_post_remove(usr)

//Run once after using remove_from_storage with NoUpdate = 1
/obj/item/weapon/reagent_containers/item_liquid_container/proc/finish_bulk_removal()
	update_ui_after_item_removal()
	update_icon()

/obj/item/weapon/reagent_containers/item_liquid_container/dropped(mob/user)
	..()
	return

/obj/item/weapon/reagent_containers/item_liquid_container/proc/toggle_gathering_mode()
	set name = "Switch Gathering Method"
	set category = "Object"

	collection_mode = !collection_mode
	switch (collection_mode)
		if(1)
			to_chat(usr, "[src] now picks up all items in a tile at once.")
		if(0)
			to_chat(usr, "[src] now picks up one item at a time.")

/obj/item/weapon/storage/emp_act(severity)
	if(!istype(src.loc, /mob/living))
		for(var/obj/O in contents)
			O.emplode(severity)
	..()

/obj/item/weapon/reagent_containers/item_liquid_container/hear_talk(mob/M, text, verb, datum/language/speaking)
	for (var/atom/A in src)
		if(istype(A,/obj))
			var/obj/O = A
			O.hear_talk(M, text, verb, speaking)

/obj/item/weapon/reagent_containers/item_liquid_container/proc/make_exact_fit(use_slots = FALSE)
	if(use_slots)
		storage_slots = contents.len
	else
		storage_slots = null

	can_hold.Cut()
	max_w_class = 0
	max_storage_space = 0
	for(var/obj/item/I in src)
		var/type_ = I.type
		if(!(type_ in can_hold))
			can_hold += type_
		max_w_class = max(I.w_class, max_w_class)
		max_storage_space += I.get_storage_cost()

/obj/item/weapon/reagent_containers/item_liquid_container/handle_atom_del(atom/A)
	if(A.loc == src)
		usr = null
		remove_from_storage(A, loc)

// Useful for spilling the contents of containers all over the floor.
/obj/item/weapon/reagent_containers/item_liquid_container/proc/spill(dist = 2, turf/T = null)
	if (!istype(T))
		T = get_turf(src)

	for(var/obj/O in contents)
		remove_from_storage(O, T)
		INVOKE_ASYNC(O, /obj.proc/tumble_async, 2)

/obj/item/weapon/reagent_containers/item_liquid_container/proc/make_empty(delete = TRUE)
	var/turf/T = get_turf(src)
	for(var/A in contents)
		if(delete)
			qdel(A)
		else
			remove_from_storage(A, T)
