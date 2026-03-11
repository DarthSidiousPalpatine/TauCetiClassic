/obj/vehicle/forklift
	name = "forklift"
	icon = 'icons/obj/vehicles_big.dmi'
	icon_state = "forklift"
	layer = MOB_LAYER //so it sits above objects including mobs
	density = TRUE
	anchored = TRUE

	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE

	w_class = SIZE_MASSIVE

	pixel_x = -8
	pixel_y = -8

	tankturn = FALSE
	can_move_backwards = TRUE

	buckled_dirs = list(
		list(0, -1),
		list(0, 20),
		list(0, 0),
		list(-19, 6),
		list(0, 0),
		list(0, 0),
		list(0, 0),
		list(19, 6)
	)
