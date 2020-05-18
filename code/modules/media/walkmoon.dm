/obj/item/media/walkmoon
	name = "walkmoon"
	desc = "This is an NT3 player for music."
	icon = 'icons/obj/jukebox.dmi'
	icon_state = "blue_white_walkmoon_item"
	w_class = ITEM_SIZE_SMALL

	var/obj/item/media/walkmoon/headphones
	var/playing = FALSE

/obj/item/media/walkmoon/atom_init() // starts without a cell for rnd
	. = ..()
	if(ispath(headphones))
		headphones = new headphones(src, src)
	else
		headphones = new(src, src)
	update_icon()

/obj/item/media/walkmoon/Destroy()
	. = ..()
	QDEL_NULL(headphones)

/obj/item/media/walkmoon/update_icon()
	if(headphones) //in case paddles got destroyed somehow.
		if(headphones.loc == src)
			icon_state = "blue_white_walkmoon_item"
		else
			if (playing)
				icon_state = "blue_white_walkmoon_inv_on"
			else
				icon_state = "blue_white_walkmoon_inv_idle"

/obj/item/media/walkmoon/ui_action_click()
	toggle_headphones()

/obj/item/media/walkmoon/attack_hand(mob/user)
	if(loc == user)
		toggle_headphones()
	else
		..()

/obj/item/media/walkmoon/attackby(obj/item/I, mob/user, params)
	if(I == headphones)
		reattach_headphones(user)
	else
		return ..()

/obj/item/media/walkmoon/verb/toggle_headphones()
	set src in oview(1)
	set name = "Toggle Headphones"
	set category = "Object"

	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/user = usr
	if(user.incapacitated())
		return

	if(!headphones)
		return

	if(headphones.loc != src)
		reattach_headphones(user) //Remove from their hands and back onto the defib unit
		return
	else
		if(!usr.put_in_hands(headphones)) //Detach the paddles into the user's hands
			to_chat(user, "<span class='warning'>You need a free hand to hold the paddles!</span>")
		update_icon() //success

/obj/item/media/walkmoon/dropped(mob/user)
	..()
	reattach_headphones(user) //paddles attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/media/walkmoon/proc/reattach_headphones(mob/user)
	if(!headphones)
		return

	if(ismob(headphones.loc))
		var/mob/M = headphones.loc
		if(M.drop_from_inventory(headphones, src))
			to_chat(user, "<span class='notice'>\The [headphones] snap back into the main unit.</span>")
	else
		headphones.forceMove(src)

	update_icon()


/obj/item/media/walkmoon/headphones
	name = "Walkmoon headphones"
	desc = "A walkmoon headphones."
	icon = 'icons/obj/jukebox.dmi'
	icon_state = "blue_white_walkmoon_inv_ears"

	slot_flags = SLOT_FLAGS_EARS
	w_class = ITEM_SIZE_NORMAL