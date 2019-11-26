/obj/structure/device/organ
	name = "space organ"
	desc = "This is a space organ, like a regular organ, but in space, everyoneone can hear organ scream."
	icon = 'icons/obj/musician.dmi'
	icon_state = "piano"
	anchored = TRUE
	density = TRUE

	var/datum/music_player/MP = null
	var/sound_path = "sound/musical_instruments/organ"

/obj/structure/device/organ/unable_to_play(mob/living/user)
	return ..() || !in_range(src, user) || !anchored

/obj/structure/device/organ/atom_init()
	. = ..()
	MP = new(src, sound_path)

/obj/structure/device/organ/Destroy()
	QDEL_NULL(MP)
	return ..()

/obj/structure/device/organ/attack_hand(mob/living/user)
	if(!anchored)
		return
	MP.interact(user)

/obj/structure/device/organ/attackby(obj/item/O, mob/user)
	if(iswrench(O))
		if(user.is_busy(src))
			return
		if (anchored)
			to_chat(user, "<span class='notice'>You begin to loosen \the [src]'s casters...</span>")
			if (O.use_tool(src, user, 40, volume = 50))
				user.visible_message(
					"<span class='notice'>[user] loosens \the [src]'s casters.</span>",
					"<span class='notice'>You have loosened \the [src]. Now it can be pulled somewhere else.</span>",
					"<span class='notice'>You hear ratchet.</span>"
				)
		else
			to_chat(user, "<span class='notice'>You begin to tighten \the [src] to the floor...</span>")
			if(O.use_tool(src, user, 20, volume = 50))
				user.visible_message(
					"<span class='notice'>[user] tightens \the [src]'s casters.</span>",
					"<span class='notice'>You have tightened \the [src]'s casters. Now it can be played again.</span>",
					"<span class='notice'>You hear ratchet.</span>"
				)

		anchored = !anchored
	else
		..()