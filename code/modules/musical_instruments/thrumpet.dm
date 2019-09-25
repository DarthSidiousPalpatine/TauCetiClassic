/obj/item/device/trumpet
	name = "trumpet"
	desc = "Spooky Scary Skeletone."
	icon = 'icons/obj/musician.dmi'
	icon_state = "trumpet"
	item_state = "trumpet"
	hitsound = list('sound/musical_instruments/trumpet/1hit.ogg', 'sound/musical_instruments/trumpet/2hit.ogg')
	force = 9
	attack_verb = list("Trumped", "Dooo-Dooosed", "Orchestred")

	var/datum/music_player/MP = null
	var/sound_path = "sound/musical_instruments/trumpet"

/obj/item/device/trumpet/atom_init()
	. = ..()
	MP = new(src, sound_path)

/obj/item/device/trumpet/Destroy()
	QDEL_NULL(MP)
	return ..()

/obj/item/device/trumpet/unable_to_play(mob/living/user)
	return ..() || loc != user

/obj/item/device/trumpet/attack_self(mob/living/user)
	MP.interact(user)
