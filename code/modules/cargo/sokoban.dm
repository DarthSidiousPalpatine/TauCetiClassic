#define HOLO_SIZE_X 10
#define HOLO_SIZE_Y 10

/obj/structure/sokoban_wall
	name = "Shuttle cargo"
	desc = "DO NOT TOUCH!"
	icon = 'icons/obj/structures/sokoban.dmi'
	icon_state = "wall_3"
	density = TRUE
	opacity = FALSE
	anchored = TRUE
	can_block_air = FALSE

	resistance_flags = INDESTRUCTIBLE

/obj/structure/sokoban_wall/atom_init()
	. = ..()
	icon_state = "wall_[rand(1,10)]"
	dir = pick(global.cardinal)

/obj/structure/sokoban_target
	name = "Target location"
	desc = "Put an object over that."
	icon = 'icons/obj/structures/sokoban.dmi'
	icon_state = "target"

	resistance_flags = INDESTRUCTIBLE

/obj/effect/landmark/sokoban_crate
	name = "Order crate"
	desc = "A crate will spawn here"
	icon = 'icons/obj/structures/sokoban.dmi'
	icon_state = "crate"



/datum/map_template/sokoban
	name = "Empty"
	holoscene_id = "turnoff"
	mappath = "maps/templates/holodeck/turnoff.dmm"
	var/holoscene_id
	var/list/restricted_crates = list()
	var/list/ordered_crates = list()
	var/list/sokoban_crates = list()
	var/list/sokoban_targets = list()
