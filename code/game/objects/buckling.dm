/atom/movable
	//Mounting
	var/can_be_buckled = FALSE
	var/can_buckle = FALSE
	var/can_be_controlled = FALSE
	var/can_control = FALSE
	var/list/rider_size_min_max = list(null, null) //First one is minimum size, Second one is Maximum size
	var/list/mount_size_min_max = list(null, null) //First one is minimum size, Second one is Maximum size
	var/atom/movable/rider = null
	var/atom/movable/mount = null
	//require people to be handcuffed before being able to buckle. eg: pipes
	var/buckle_require_restraints = 0
	//bed-like behavior, forces mob.lying = rider_lying if != -1
	var/buckle_lying = -1
	// Delay in ticks for the lying anim on rider_lying objs.
	var/buckle_delay = 2


/atom/movable/attack_hand(mob/living/user)
	. = ..()
	if(can_buckle && rider && istype(user) && do_mob(user, src, 5))
		unbuckle(user)

/atom/movable/attack_robot(mob/living/user)
	if(Adjacent(user) && unbuckle(user))
		return
	return ..()

/atom/movable/MouseDrop_T(atom/movable/M, mob/living/user)
	. = ..()
	if(istype(M) && istype(user) && do_mob(user, src, 5))
		buckle(M, user)
		return FALSE

/atom/movable/proc/buckle(atom/movable/M, mob/living/user)
	if(!can_buckle(M))
		return FALSE
	if(user)
		if(!SSticker)
			to_chat(user, "<span class='warning'>You can't buckle anyone in before the game starts.</span>")
			return

		if(!user.Adjacent(M) || user.incapacitated() || user.lying || ispAI(user) || ismouse(user))
			return

		if(user.is_busy())
			to_chat(user, "<span class='warning'>You can't buckle [M] while doing something.</span>")
			return

		if(istype(M, /mob/living/simple_animal/construct))
			to_chat(user, "<span class='warning'>The [M] is floating in the air and can't be buckled.</span>")
			return

		if(isslime(M))
			to_chat(user, "<span class='warning'>The [M] is too squishy to buckle in.</span>")
			return

		if(issilicon(M))
			to_chat(user, "<span class='warning'>The [M] is too heavy to buckle in.</span>")
			return

		if(M == user)
			M.visible_message(\
				"<span class='notice'>[M.name] buckles themselves to [src].</span>",\
				"<span class='notice'>You buckle yourself to [src].</span>",\
				"<span class='notice'>You hear metal clanking.</span>")
		else
			M.visible_message(\
				"<span class='danger'>[M.name] is buckled to [src] by [user.name]!</span>",\
				"<span class='danger'>You are buckled to [src] by [user.name]!</span>",\
				"<span class='notice'>You hear metal clanking.</span>")

		add_fingerprint(user)

	//reset pulling
	if(M.pulledby)
		M.pulledby.stop_pulling()
	if(M.grabbed_by.len)
		for (var/obj/item/weapon/grab/G in M.grabbed_by)
			qdel(G)

	M.mount = src
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		rider = H
	else if(ismob(M))
		var/mob/Mob = M
		rider = Mob
	else
		var/atom/movable/Mov = M
		rider = Mov

	M.set_dir(dir)
	post_buckle(M)

	SEND_SIGNAL(src, COMSIG_MOVABLE_BUCKLE, M)

	M.throw_alert("buckled", /atom/movable/screen/alert/buckled, new_master = src)
	correct_pixel_shift(M)
	M.update_canmove()
	if(can_be_controlled && M.can_control)

	return TRUE


/atom/movable/proc/unbuckle(mob/living/user, var/harm = FALSE)
	if(!can_unbuckle())
		return
	if(user)
		if(user.is_busy())
			to_chat(user, "<span class='warning'>You can't unbuckle [src] while doing something.</span>")
			return
		if(rider != user)
			rider.visible_message(\
				"<span class='notice'>[rider.name] was unbuckled by [user.name]!</span>",\
				"<span class='notice'>You were unbuckled from [src] by [user.name].</span>",\
				"<span class='notice'>You hear metal clanking.</span>")
		else
			rider.visible_message(\
				"<span class='notice'>[rider.name] unbuckled themselves!</span>",\
				"<span class='notice'>You unbuckle yourself from [src].</span>",\
				"<span class='notice'>You hear metal clanking.</span>")
		add_fingerprint(user)

	rider.mount = null
	rider.anchored = initial(rider.anchored)
	if(ismob(rider))
		var/mob/Mob = rider
		Mob.update_canmove()
		Mob.clear_alert("buckled")
	correct_pixel_shift(rider)
	SEND_SIGNAL(src, COMSIG_MOVABLE_UNBUCKLE, rider)
	if(harm)
		rider.throw_at(rider, 0, 5, user)
	rider = null


/atom/movable/proc/can_buckle(atom/movable/M)
	if(!can_buckle || !M.can_be_buckled) //if atom can be buclked and we can buckle him
		return FALSE
	if(!istype(M) || !Adjacent(usr) || !usr.Adjacent(src)) //if atom is near
		return FALSE
	if(M.mount || rider) //if we dont have a rider or atom dont have a mount
		return FALSE
	if(M.pinned.len)
		return FALSE
	if(buckle_require_restraints && !M.restrained())
		return FALSE
	if(M.w_class > rider_size_min_max[2] || M.w_class < rider_size_min_max[1]) //if atom's size is compatible
		return FALSE
	if(w_class > M.mount_size_min_max[2] || w_class < M.mount_size_min_max[1]) //if our size is compatible
		return FALSE
	return M != src

/atom/movable/proc/can_unbuckle()
	if(!rider || rider.mount != src)
		return FALSE

/atom/movable/proc/correct_pixel_shift(mob/living/carbon/C)
	if(!istype(C))
		return
	C.update_transform()

/atom/movable/proc/post_buckle(atom/movable/M)
	return

/atom/movable/proc/post_unbuckle(atom/movable/M)
	return
