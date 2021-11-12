//Alium nests. Essentially beds with an unbuckle delay that only aliums can buckle mobs to.

/obj/structure/stool/bed/nest
	name = "alien nest"
	desc = "It's a gruesome pile of thick, sticky resin shaped like a nest."
	icon = 'icons/mob/alien.dmi'
	icon_state = "nest"
	var/health = 100
	layer = 2.55
	can_buckle = TRUE
	rider_size_min_max = list(SIZE_NORMAL, SIZE_BIG_HUMAN)

/obj/structure/stool/bed/nest/unbuckle(mob/user)
	if(rider)
		if(user.is_busy())
			return

		if(rider.mount == src)
			if(rider != user)
				rider.visible_message(\
					"<span class='notice'>[user.name] pulls [rider.name] free from the sticky nest!</span>",\
					"<span class='notice'>[user.name] pulls you free from the gelatinous resin.</span>",\
					"<span class='notice'>You hear squelching...</span>")
				rider.pixel_y = 0
				unbuckle()
			else
				if(user.is_busy()) return
				rider.visible_message(\
					"<span class='warning'>[rider.name] struggles to break free of the gelatinous resin...</span>",\
					"<span class='warning'>You struggle to break free from the gelatinous resin...</span>",\
					"<span class='notice'>You hear squelching...</span>")
				if(do_after(rider, 3000, target = user))
					if(user && rider && user.mount == src)
						rider.pixel_y = 0
						unbuckle()
			add_fingerprint(user)
	return

/obj/structure/stool/bed/nest/buckle(mob/M, mob/user)
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.incapacitated() || M.mount || istype(user, /mob/living/silicon/pai) )
		return

	if(user.is_busy())
		return

	if(istype(M, /mob/living/carbon/xenomorph))
		return
	if(!istype(user,/mob/living/carbon/xenomorph/humanoid))
		return

	if(M == usr)
		return
	else
		M.visible_message(\
			"<span class='notice'>[user.name] secretes a thick vile goo, securing [M.name] into [src]!</span>",\
			"<span class='warning'>[user.name] drenches you in a foul-smelling resin, trapping you in the [src]!</span>",\
			"<span class='notice'>You hear squelching...</span>")
		buckle(M, user)
		M.pixel_y = 2
	return

/obj/structure/stool/bed/nest/attackby(obj/item/weapon/W, mob/user)
	var/aforce = W.force
	health = max(0, health - aforce)
	user.SetNextMove(CLICK_CD_MELEE)
	playsound(src, 'sound/effects/attackblob.ogg', VOL_EFFECTS_MASTER)
	visible_message("<span class='warning'>[user] hits [src] with [W]!</span>")
	healthcheck()

/obj/structure/stool/bed/nest/proc/healthcheck()
	if(health <=0)
		density = FALSE
		qdel(src)
	return
