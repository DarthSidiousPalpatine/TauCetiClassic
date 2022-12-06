/turf/simulated/wall/wooden
	name = "log wall"
	desc = "Тепло и воспламеняемость."
	icon = 'icons/turf/walls/log.dmi'
	sheet_type = /obj/item/stack/sheet/wood
	canSmoothWith = list(
		/turf/simulated/wall/plank,
		/turf/simulated/wall/wooden,
		/obj/structure/mineral_door/wood,
		/obj/structure/mineral_door/wood/secure,
	)
	smooth = SMOOTH_TRUE

/turf/simulated/wall/plank
	name = "plank wall"
	desc = "Деревянная стена, обшитая досками."
	icon = 'icons/turf/walls/planks.dmi'
	sheet_type = /obj/item/stack/sheet/wood
	canSmoothWith = list(
		/turf/simulated/wall/plank,
		/turf/simulated/wall/wooden,
		/obj/structure/mineral_door/wood,
		/obj/structure/mineral_door/wood/secure,
	)
	smooth = SMOOTH_TRUE
