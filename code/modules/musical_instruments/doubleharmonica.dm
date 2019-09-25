/obj/item/device/doubleharmonica
	name = "double harmonica"
	desc = "O, du lieber Assistant, Assistant, Assistant, O, du lieber Assistant, Alles ist hin!."
	icon = 'icons/obj/musician.dmi'
	icon_state = "doubleharmonica"
	item_state = "doubleharmonica"
	hitsound = list('sound/musical_instruments/flute/1hit.ogg', 'sound/musical_instruments/flute/2hit.ogg')
	force = 3
	attack_verb = list("Harmonized", "Frleewed")

	var/datum/music_player/MP = null
	var/sound_path = "sound/musical_instruments/doubleharmonica"

/obj/item/device/doubleharmonica/atom_init()
	. = ..()
	MP = new(src, sound_path)

/obj/item/device/doubleharmonica/Destroy()
	QDEL_NULL(MP)
	return ..()

/obj/item/device/doubleharmonica/unable_to_play(mob/living/user)
	return ..() || loc != user

/obj/item/device/doubleharmonica/attack_self(mob/living/user)
	MP.interact(user)
