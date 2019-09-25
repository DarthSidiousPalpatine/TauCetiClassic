/obj/item/device/flute
	name = "flute"
	desc = "Woody wooden wood."
	icon = 'icons/obj/musician.dmi'
	icon_state = "flute"
	item_state = "flute"
	hitsound = list('sound/musical_instruments/flute/1hit.ogg', 'sound/musical_instruments/flute/2hit.ogg')
	force = 2
	attack_verb = list("Tooobed", "Fluted", "Stabbed with Flute")

	var/datum/music_player/MP = null
	var/sound_path = "sound/musical_instruments/flute"

/obj/item/device/flute/atom_init()
	. = ..()
	MP = new(src, sound_path)

/obj/item/device/flute/Destroy()
	QDEL_NULL(MP)
	return ..()

/obj/item/device/flute/unable_to_play(mob/living/user)
	return ..() || loc != user

/obj/item/device/flute/attack_self(mob/living/user)
	MP.interact(user)


/obj/item/device/flute/ocarina
	name = "ocarina"
	desc = "Space Chill"
	icon_state = "ocarina"
	item_state = "ocarina"

	sound_path = "sound/musical_instruments/ocarina"