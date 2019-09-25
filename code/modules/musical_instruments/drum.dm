/obj/item/device/drum
	name = "drum"
	desc = "Tra-ta-ta, Tra-ta-ta, We are riding with Runtime."
	icon = 'icons/obj/musician.dmi'
	icon_state = "drum"
	item_state = "drum"
	hitsound = list('sound/musical_instruments/drum/1hit.ogg', 'sound/musical_instruments/drum/2hit.ogg', 'sound/musical_instruments/drum/3hit.ogg')
	force = 6
	attack_verb = list("Drooomed", "Badum-Tss")

	var/datum/music_player/MP = null
	var/sound_path = "sound/musical_instruments/drum"

/obj/item/device/drum/atom_init()
	. = ..()
	MP = new(src, sound_path)

/obj/item/device/drum/Destroy()
	QDEL_NULL(MP)
	return ..()

/obj/item/device/drum/unable_to_play(mob/living/user)
	return ..() || loc != user

/obj/item/device/drum/attack_self(mob/living/user)
	MP.interact(user)
