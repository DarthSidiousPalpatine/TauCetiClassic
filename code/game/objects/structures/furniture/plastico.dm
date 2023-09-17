/obj/structure/stool/plastico
	name = "stool"
	desc = "PLASTICO-branded stool."
	icon = 'icons/obj/furniture/plastico.dmi'
	icon_state = "stool"
	anchored = FALSE

	max_integrity = 5
	resistance_flags = CAN_BE_HIT

	material = /obj/item/stack/rods

/obj/structure/stool/bed/chair/plastico
	name = "chair"
	desc = "PLASTICO-branded chair."
	icon = 'icons/obj/furniture/plastico.dmi'
	icon_state = "chair"
	behind = "chair_behind"
	buckle_lying = FALSE

	max_integrity = 10

	anchored = FALSE

	can_flipped = FALSE

/obj/structure/stool/bed/plastico
	name = "bed"
	desc = "PLASTICO-branded bed."
	icon = 'icons/obj/furniture/plastico.dmi'
	icon_state = "bed"
	buckle_lying = TRUE

	max_integrity = 20

	anchored = FALSE

/obj/structure/table/plastico
	name = "table"
	desc = "PLASTICO-branded table."
	icon = 'icons/obj/furniture/plastico.dmi'
	icon_state = "table"
	smooth = SMOOTH_FALSE

	max_integrity = 25

	parts = null

	flipable = FALSE
	canconnect = FALSE

	anchored = FALSE

/obj/structure/table/plastico/small
	name = "table"
	desc = "PLASTICO-branded table."
	icon = 'icons/obj/furniture/plastico.dmi'
	icon_state = "smalltable"
	smooth = SMOOTH_FALSE

	max_integrity = 15

	parts = null

	flipable = FALSE
	canconnect = FALSE

	anchored = FALSE

/obj/structure/table/plastico/shoestand
	name = "shoe stand"
	desc = "PLASTICO-branded shoe stand."
	icon = 'icons/obj/furniture/plastico.dmi'
	icon_state = "shoe_stand"
	smooth = SMOOTH_FALSE

	max_integrity = 5

	parts = null

	flipable = FALSE
	canconnect = FALSE

	anchored = FALSE

/obj/structure/mirror/plastico
	name = "miror"
	desc = "PLASTICO-branded mirror."
	icon = 'icons/obj/furniture/plastico.dmi'
	icon_state = "mirror"

	max_integrity = 10

	anchored = FALSE

/obj/structure/closet/crate/bin/plastico
	desc = "A bin."
	name = "PLASTICO-branded bin"
	icon = 'icons/obj/furniture/plastico.dmi'
	icon_state = "bin"
	icon_opened = "bin_open"
	icon_closed = "bin_closed"

/obj/structure/coatrack/plastico
	name = "coat rack"
	desc = "PLASTICO-branded coat rack."
	icon = 'icons/obj/furniture/plastico.dmi'
	icon_state = "coatrack"

	anchored = FALSE
