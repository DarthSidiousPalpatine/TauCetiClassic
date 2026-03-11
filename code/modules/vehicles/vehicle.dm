/obj/vehicle
	name = "vehicle"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "pussywagon"
	layer = MOB_LAYER //so it sits above objects including mobs
	density = TRUE
	anchored = TRUE

	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE

	w_class = SIZE_MASSIVE

	var/tankturn = TRUE
	var/previous_move = 0
	var/vehicle_moving_delay = 5
	var/can_move_backwards = TRUE

	var/buckled_dirs = list(
		list(0, 4),
		list(0, 8),
		list(0, 0),
		list(-12, 6),
		list(0, 0),
		list(0, 0),
		list(0, 0),
		list(12, 6)
	)

/obj/vehicle/relaymove(mob/user, direction)
	return VehicleMove(direction)

/obj/vehicle/proc/VehicleMove(direction)
	switch(direction)
		if(WEST)
			if(!tankturn)
				return FALSE
			dir = turn(dir, 90)
			update_layers()
			return TRUE

		if(EAST)
			if(!tankturn)
				return FALSE
			dir = turn(dir, -90)
			update_layers()
			return TRUE

		if(NORTHEAST)
			if(Move(get_step(src, dir)))
				dir = turn(dir, -90)
				if(Move(get_step(src, dir)))
					update_layers()
					return TRUE

		if(NORTHWEST)
			if(Move(get_step(src, dir)))
				dir = turn(dir, 90)
				if(Move(get_step(src, dir)))
					update_layers()
					return TRUE

		if(SOUTHEAST)
			if(!can_move_backwards)
				return FALSE
			var/prev_dir = dir
			if(Move(get_step(src, reverse_dir[dir])))
				dir = turn(prev_dir, 90)
				prev_dir = dir
				if(Move(get_step(src, reverse_dir[dir])))
					dir = prev_dir
					update_layers()
					return TRUE

				dir = prev_dir
				update_layers()

		if(SOUTHWEST)
			if(!can_move_backwards)
				return FALSE
			var/prev_dir = dir
			if(Move(get_step(src, reverse_dir[dir])))
				dir = turn(prev_dir, -90)
				prev_dir = dir
				if(Move(get_step(src, reverse_dir[dir])))
					dir = prev_dir
					update_layers()
					return TRUE

				dir = prev_dir
				update_layers()

		if(NORTH)
			if(Move(get_step(src, dir)))
				update_layers()
				return TRUE

		if(SOUTH)
			if(!can_move_backwards)
				return FALSE
			var/prev_dir = dir
			if(Move(get_step(src, reverse_dir[dir])))
				dir = prev_dir
				update_layers()
				return TRUE

			dir = prev_dir
			update_layers()

	return FALSE

/obj/vehicle/can_buckle(mob/living/M)
	if(M.buckled || buckled_mob)
		return FALSE
	return TRUE

/obj/vehicle/post_buckle_mob(mob/living/M)
	if(M == buckled_mob)
		update_buckle_mob(M)
	else
		M.pixel_x = M.default_pixel_x
		M.pixel_y = M.default_pixel_y

/obj/vehicle/update_buckle_mob(mob/M)
	if(!M)
		return

	var/list/dir_list = buckled_dirs[dir]
	M.pixel_x = dir_list[1]
	M.pixel_y = dir_list[2]
	M.dir = dir

	if(dir == SOUTH)
		layer = MOB_LAYER + 0.01
	else
		layer = MOB_LAYER - 0.01

/obj/vehicle/proc/update_layers()
	update_buckle_mob(buckled_mob)
