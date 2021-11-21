/**
 * Through the looking glass
 * Show an other side of a portal or anything else.
 */

/datum/component/looking_glass

/**
 * Looking Glass
 *
 * vars:
 */
/datum/component/looking_glass/Initialize()

// Inherit the new values passed to the component
/datum/component/twohanded/InheritComponent()

// Register signals with the parent item
/datum/component/twohanded/RegisterWithParent()

// Remove all siginals registered to the parent item
/datum/component/twohanded/UnregisterFromParent()

/obj/effect/looking_glass
	name = "looking glass"
	appearance_flags = KEEP_TOGETHER|TILE_BOUND|PIXEL_SCALE
	mouse_opacity = 0
	vis_flags = VIS_HIDE
	layer = ABOVE_OBJ_LAYER
	var/mask_icon = 'icons/obj/watercloset.dmi'
	var/mask_icon_state = "mirror_mask"
	var/obj/mirror
	desc = "Curiouser and curiouser."
	anchored = TRUE
	unacidable = TRUE