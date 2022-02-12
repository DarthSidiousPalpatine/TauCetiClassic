/turf/simulated/wall/w_wall
	name = "wooden wall"
	desc = "A huge logs used to seperate rooms."
	icon = 'icons/turf/walls/has_false_walls/wooden_wall.dmi'
	icon_state = "box"
	plane = GAME_PLANE

	max_temperature = 451 //K, walls will take damage if they're next to a fire hotter than this

	seconds_to_melt = 5 //It takes 10 seconds for thermite to melt this wall through

	opacity = 1
	density = TRUE
	blocks_air = 1

	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 3125 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall

	sheet_type = /obj/item/stack/sheet/wood

/turf/simulated/wall/s_wall
	name = "snowdrift"
	desc = "A huge pile of snow."
	icon = 'icons/turf/walls/has_false_walls/snow_wall.dmi'
	icon_state = "box"
	plane = GAME_PLANE

	max_temperature = 200 //K, walls will take damage if they're next to a fire hotter than this

	seconds_to_melt = 5 //It takes 10 seconds for thermite to melt this wall through

	opacity = 1
	density = TRUE
	blocks_air = 1

	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 3125 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall

	sheet_type = /obj/item/snowball

	canSmoothWith = list(/turf/simulated/wall/s_wall)
