/obj/structure/stool/tatlin
	name = "stool"
	desc = "TATLIN-branded stool."
	icon = 'icons/obj/furniture/tatlin.dmi'
	icon_state = "stool"
	anchored = FALSE

	max_integrity = 5
	resistance_flags = CAN_BE_HIT

	material = /obj/item/stack/rods

/obj/structure/stool/bed/chair/tatlin
	name = "chair"
	desc = "TATLIN-branded chair."
	icon = 'icons/obj/furniture/tatlin.dmi'
	icon_state = "chair"
	behind = "chair_behind"
	buckle_lying = FALSE

	max_integrity = 10

	anchored = FALSE

	can_flipped = FALSE

/obj/structure/stool/bed/tatlin
	name = "bed"
	desc = "TATLIN-branded bed."
	icon = 'icons/obj/furniture/tatlin.dmi'
	icon_state = "bed"
	buckle_lying = TRUE

	max_integrity = 20

	anchored = FALSE

/obj/structure/table/tatlin
	name = "table"
	desc = "TATLIN-branded table."
	icon = 'icons/obj/furniture/tatlin.dmi'
	icon_state = "table"
	smooth = SMOOTH_FALSE

	max_integrity = 25

	parts = null

	flipable = FALSE
	canconnect = FALSE

	anchored = FALSE

/obj/structure/table/tatlin/small
	name = "table"
	desc = "TATLIN-branded table."
	icon = 'icons/obj/furniture/tatlin.dmi'
	icon_state = "smalltable"
	smooth = SMOOTH_FALSE

	max_integrity = 15

	parts = null

	flipable = FALSE
	canconnect = FALSE

	anchored = FALSE

/obj/structure/table/tatlin/shoestand
	name = "shoe stand"
	desc = "TATLIN-branded shoe stand."
	icon = 'icons/obj/furniture/tatlin.dmi'
	icon_state = "shoe_stand"
	smooth = SMOOTH_FALSE

	max_integrity = 5

	parts = null

	flipable = FALSE
	canconnect = FALSE

	anchored = FALSE

/obj/structure/mirror/tatlin
	name = "miror"
	desc = "TATLIN-branded mirror."
	icon = 'icons/obj/furniture/tatlin.dmi'
	icon_state = "mirror"

	max_integrity = 10

	anchored = FALSE

/obj/structure/closet/crate/bin/tatlin
	desc = "A bin."
	name = "TATLIN-branded bin"
	icon = 'icons/obj/furniture/tatlin.dmi'
	icon_state = "bin"
	icon_opened = "bin_open"
	icon_closed = "bin_closed"

/obj/structure/coatrack/tatlin
	name = "coat rack"
	desc = "TATLIN-branded coat rack."
	icon = 'icons/obj/furniture/tatlin.dmi'
	icon_state = "coatrack"

	anchored = FALSE
