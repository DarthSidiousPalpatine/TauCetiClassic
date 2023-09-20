/obj/structure/stool/cheapwood
	name = "stool"
	desc = "Cheap wooden stool."
	icon = 'icons/obj/furniture/cheapwood.dmi'
	icon_state = "stool"
	anchored = FALSE

	max_integrity = 5
	resistance_flags = CAN_BE_HIT

	material = /obj/item/stack/rods

/obj/structure/stool/bed/chair/cheapwood
	name = "chair"
	desc = "Cheap wooden chair."
	icon = 'icons/obj/furniture/cheapwood.dmi'
	icon_state = "chair"
	behind = "chair_behind"
	buckle_lying = FALSE

	max_integrity = 10

	anchored = FALSE

	can_flipped = FALSE

/obj/structure/stool/bed/cheapwood
	name = "bed"
	desc = "Cheap wooden bed."
	icon = 'icons/obj/furniture/cheapwood.dmi'
	icon_state = "bed"
	buckle_lying = TRUE

	max_integrity = 20

	anchored = FALSE

/obj/structure/table/cheapwood
	name = "table"
	desc = "Cheap wooden table."
	icon = 'icons/obj/furniture/cheapwood.dmi'
	icon_state = "table"
	smooth = SMOOTH_FALSE

	max_integrity = 25

	parts = null

	flipable = FALSE
	canconnect = FALSE

	anchored = FALSE

/obj/structure/table/cheapwood/small
	name = "table"
	desc = "Cheap wooden table."
	icon = 'icons/obj/furniture/cheapwood.dmi'
	icon_state = "smalltable"
	smooth = SMOOTH_FALSE

	max_integrity = 15

	parts = null

	flipable = FALSE
	canconnect = FALSE

	anchored = FALSE

/obj/structure/table/cheapwood/shoestand
	name = "shoe stand"
	desc = "Cheap wooden shoe stand."
	icon = 'icons/obj/furniture/cheapwood.dmi'
	icon_state = "shoe_stand"
	smooth = SMOOTH_FALSE

	max_integrity = 5

	parts = null

	flipable = FALSE
	canconnect = FALSE

	anchored = FALSE

/obj/structure/mirror/cheapwood
	name = "miror"
	desc = "Cheap wooden mirror."
	icon = 'icons/obj/furniture/cheapwood.dmi'
	icon_state = "mirror"

	max_integrity = 10

	anchored = FALSE

/obj/structure/closet/crate/bin/cheapwood
	desc = "A bin."
	name = "Cheap wooden bin"
	icon = 'icons/obj/furniture/cheapwood.dmi'
	icon_state = "bin"
	icon_opened = "bin"
	icon_closed = "bin"

/obj/structure/coatrack/cheapwood
	name = "coat rack"
	desc = "Cheap wooden coat rack."
	icon = 'icons/obj/furniture/cheapwood.dmi'
	icon_state = "coatrack"

	anchored = FALSE