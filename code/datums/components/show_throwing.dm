/datum/component/show_throwing
	var/atom/movable/screen/fullscreen/cursor_tracker/tracker
	var/obj/item/showed_item
	var/mob/living/parent_mob

/datum/component/show_throwing/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	parent_mob = parent

	RegisterSignal(parent_mob, COMSIG_MOB_TOGGLE_THROW, PROC_REF(throw_toggled))

	tracker = parent_mob.overlay_fullscreen("mouse_tracker", /atom/movable/screen/fullscreen/cursor_tracker)
	tracker.track_mob(parent_mob)

/datum/component/show_throwing/proc/throw_toggled()
	SIGNAL_HANDLER

	if(parent_mob.in_throw_mode)
		start_showing()
	else
		reject_throwing()

/datum/component/show_throwing/Destroy()
	stop_showing()
	return ..()


/datum/component/show_throwing/proc/start_showing()
	showed_item = parent_mob.get_active_hand()
	if(!showed_item)
		return

	parent_mob.drop_from_inventory(showed_item)
	parent_mob.AddComponent(/datum/component/bounded, showed_item, 0, 0)
	tracker.mouse_opacity = MOUSE_OPACITY_ICON

	RegisterSignal(parent_mob, COMSIG_MOB_SWAP_HANDS, PROC_REF(stop_showing))
	RegisterSignal(showed_item, list(COMSIG_MOVABLE_MOVED, COMSIG_MOVABLE_LOC_MOVED), PROC_REF(stop_showing))

	START_PROCESSING(SSfastprocess, src)

/datum/component/show_throwing/proc/resolve_stranded()
	if(showed_item && isturf(showed_item.loc))
		showed_item.loc = parent_mob.loc

/datum/component/show_throwing/proc/reject_throwing()
	parent_mob.put_in_active_hand(showed_item)
	stop_showing()

/datum/component/show_throwing/proc/stop_showing()
	SIGNAL_HANDLER

	STOP_PROCESSING(SSfastprocess, src)

	if(parent_mob)
		UnregisterSignal(parent_mob, COMSIG_MOB_SWAP_HANDS)
		tracker.mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	if(showed_item)
		qdel(showed_item.GetComponent(/datum/component/bounded))
		UnregisterSignal(showed_item, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(showed_item, COMSIG_MOVABLE_LOC_MOVED)
		showed_item = null

/datum/component/show_throwing/process()
	var/list/mouse_coordinates = tracker.get_mouse_pos()

	var/relative_x = mouse_coordinates["x"] - 240
	var/relative_y = mouse_coordinates["y"] - 240

	var/vec_length = sqrt(relative_x * relative_x + relative_y * relative_y)

	showed_item.pixel_x = round(relative_x / vec_length * 16)
	showed_item.pixel_y = round(relative_y / vec_length * 16)
	parent_mob.face_atom(mouse_coordinates["turf"])
