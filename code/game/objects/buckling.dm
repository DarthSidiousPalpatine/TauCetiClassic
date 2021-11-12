/atom/movable
	//Mounting
	var/can_be_buckled = FALSE
	var/can_buckle = FALSE
	var/can_be_controlled = FALSE
	var/can_control = FALSE
	var/list/rider_size_min_max = list(null, null) //First one is minimum size, Second one is Maximum size
	var/list/mount_size_min_max = list(null, null) //First one is minimum size, Second one is Maximum size
	var/mob/living/buckled_mob = null
	var/atom/movable/mount = null
	//require people to be handcuffed before being able to buckle. eg: pipes
	var/buckle_require_restraints = 0
	//bed-like behavior, forces mob.lying = rider_lying if != -1
	var/buckle_lying = -1
	// Delay in ticks for the lying anim on rider_lying objs.
	var/buckle_delay = 2

	var/buckle_movable = FALSE

/atom/movable/attack_hand(mob/living/user)
	. = ..()
	if(can_buckle && buckled_mob && istype(user))
		if(do_after(user, 5, target = src, progress = TRUE))
			unbuckle(user)

/atom/movable/attack_robot(mob/living/user)
	if(Adjacent(user) && unbuckle(user))
		return
	return ..()

/atom/movable/MouseDrop_T(mob/living/M, mob/living/user)
	. = ..()
	if(can_buckle && istype(M) && istype(user))
		if(do_after(user, 5, target = src, progress = TRUE))
			if(buckled_mob && buckled_mob == user)
				unbuckle(user)
			else
				buckle(M, user)
		return FALSE

/atom/movable/proc/buckle(mob/living/M, mob/living/user)
	if(!can_buckle(M))
		return FALSE

	var/turf/T = get_turf(src)
	if(M.loc != T)
		var/old_density = density
		density = FALSE
		var/can_step = step_towards(M, T)
		density = old_density
		if(!can_step)
			return 0

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
	buckled_mob = M

	M.set_dir(dir)

	post_buckle(M)

	SEND_SIGNAL(src, COMSIG_MOVABLE_BUCKLE, M)

	M.throw_alert("buckled", /atom/movable/screen/alert/buckled, new_master = src)
	correct_pixel_shift(M)
	M.update_canmove()

	return TRUE


/atom/movable/proc/unbuckle(mob/living/user, var/harm = FALSE)
	if(!can_unbuckle())
		return
	if(user)
		if(user.is_busy())
			to_chat(user, "<span class='warning'>You can't unbuckle [src] while doing something.</span>")
			return
		if(buckled_mob != user)
			buckled_mob.visible_message(\
				"<span class='notice'>[buckled_mob.name] was unbuckled by [user.name]!</span>",\
				"<span class='notice'>You were unbuckled from [src] by [user.name].</span>",\
				"<span class='notice'>You hear metal clanking.</span>")
		else
			buckled_mob.visible_message(\
				"<span class='notice'>[buckled_mob.name] unbuckled themselves!</span>",\
				"<span class='notice'>You unbuckle yourself from [src].</span>",\
				"<span class='notice'>You hear metal clanking.</span>")
		add_fingerprint(user)

	. = buckled_mob

	buckled_mob.mount = null
	buckled_mob.anchored = initial(buckled_mob.anchored)
	buckled_mob.update_canmove()
	buckled_mob.clear_alert("buckled")
	correct_pixel_shift(buckled_mob)
	SEND_SIGNAL(src, COMSIG_MOVABLE_UNBUCKLE, buckled_mob)
	if(harm)
		buckled_mob.throw_at(buckled_mob, 0, 5, user)
	buckled_mob = null

	post_buckle(.)


/atom/movable/proc/can_buckle(mob/living/M)
	if(!can_buckle || !M.can_be_buckled) //if atom can be buclked and we can buckle him
		return FALSE
	if(!istype(M) || !Adjacent(M) || !M.Adjacent(src)) //if atom is near
		return FALSE
	if(M.mount || buckled_mob) //if we dont have a rider or atom dont have a mount
		return FALSE
	if(M.pinned.len)
		return FALSE
	if(buckle_require_restraints && !M.restrained())
		return FALSE
	if(M.w_class < rider_size_min_max[1] || M.w_class > rider_size_min_max[2]) //if atom's size is compatible
		return FALSE
	if(w_class < M.mount_size_min_max[1] || w_class > M.mount_size_min_max[2]) //if our size is compatible
		return FALSE
	return M != src

/atom/movable/proc/can_unbuckle()
	if(buckled_mob)
		if(buckled_mob.mount == src)
			return TRUE

/atom/movable/proc/correct_pixel_shift(mob/living/carbon/C)
	if(!istype(C))
		return
	C.update_transform()

/atom/movable/proc/post_buckle(mob/living/M)
	M.AddComponent(/datum/component/bounded, src, 0, 0, CALLBACK(src, .proc/handle_rider))
	return

/atom/movable/proc/post_unbuckle(mob/living/M)
	qdel(GetComponent(/datum/component/bounded))
	return

/atom/movable/relaymove(mob/user, direction)
	if(!user.mount == src || user.incapacitated() || !user.can_control || !can_be_controlled)
		return

	step(src, direction)
	set_dir(direction)
	buckled_mob.set_dir(direction)

/atom/movable/proc/handle_rider(datum/component/bounded/bounds)
	if(get_dist(bounds.bound_to, src) == 2 && !anchored)
		step_towards(src, bounds.bound_to)
		var/dist = get_dist(src, get_turf(bounds.bound_to))
		if(dist >= bounds.min_dist && dist <= bounds.max_dist)
			return TRUE
	return TRUE
