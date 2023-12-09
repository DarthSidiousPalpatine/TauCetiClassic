/obj/machinery/factory
	name = "factory machinery"
	icon = 'icons/obj/factory.dmi'

	max_integrity = 200
	integrity_failure = 0.3
	damage_deflection = 15
	resistance_flags = CAN_BE_HIT

	anchored = FALSE
	density = TRUE

	var/obj/item/weapon/tool

	var/usesound

/obj/machinery/factory/atom_init()
	. = ..()
	tool = new tool(src)

/obj/machinery/factory/Destroy()
	qdel(tool)
	..()

/obj/machinery/factory/attackby(obj/item/I, mob/user)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(iswrenching(I))
		default_unfasten_wrench(user, I)
		return

	if(!anchored)
		return

	if(usesound)
		playsound(src, usesound, VOL_EFFECTS_MASTER)
	flick("[icon_state]_on", src)
	I.attackby(tool, user)
	return

/obj/item/weapon/factory/saw
	name = "factory saw"
	desc = "Циркулярный станок для распила."
	icon = 'icons/obj/factory.dmi'
	icon_state = "saw_item"
	flags = CONDUCT
	force = 5.0
	hitsound = list('sound/weapons/circsawhit.ogg')
	attack_verb = list("cut")
	usesound = 'sound/items/surgery/SurgDrill.ogg'
	toolspeed = 0.25
	required_skills = list(/datum/skill/engineering = SKILL_LEVEL_NOVICE)

	qualities = list(
		QUALITY_CUTTING = 1
	)

/obj/machinery/factory/saw
	name = "cutting machine"
	icon_state = "saw"

	tool = /obj/item/weapon/factory/saw
	usesound = 'sound/items/surgery/SurgDrill.ogg'

/obj/item/weapon/factory/screw
	name = "factory screw"
	desc = "Крутящий станок для кручения."
	icon = 'icons/obj/factory.dmi'
	icon_state = "screw_item"
	flags = CONDUCT
	force = 5.0
	hitsound = list('sound/items/tools/tool-hit.ogg')
	attack_verb = list("drilled", "screwed", "jabbed")
	usesound = 'sound/items/change_drill.ogg'
	toolspeed = 0.25
	required_skills = list(/datum/skill/engineering = SKILL_LEVEL_NOVICE)

	qualities = list(
		QUALITY_SCREWING = 1,
		QUALITY_WRENCHING = 1
	)

/obj/machinery/factory/screw
	name = "screwing machine"
	icon_state = "screw"

	tool = /obj/item/weapon/factory/screw
	usesound = 'sound/items/change_drill.ogg'

/obj/item/weapon/factory/weld
	name = "factory welder"
	desc = "Сварочный станок для сварки."
	icon = 'icons/obj/factory.dmi'
	icon_state = "weld_item"
	flags = CONDUCT
	force = 5.0
	hitsound = 'sound/items/tools/tool-hit.ogg'
	attack_verb = list("burned")
	usesound = 'sound/items/Welder2.ogg'
	toolspeed = 0.25
	required_skills = list(/datum/skill/engineering = SKILL_LEVEL_NOVICE)

	qualities = list(
		QUALITY_WELDING = 1
	)

/obj/machinery/factory/weld
	name = "welding machine"
	icon_state = "weld"

	tool = /obj/item/weapon/factory/weld
	usesound = 'sound/items/Welder2.ogg'



/obj/item/manufacturing_parts
	name = "manufacturing parts"
	desc = "Набор для сборки"
	icon = 'icons/obj/factory.dmi'
	icon_state = "box"

	var/list/steps = list()
	var/step = 1

	var/parts_state

	var/datum/production_recipe/prod_rec

/obj/item/manufacturing_parts/atom_init(mapload, datum/production_recipe/recipe)
	. = ..()

	if(!recipe)
		qdel(src)
		return

	prod_rec = recipe

	if(prod_rec.brand)
		name += " ([prod_rec.brand.name])"
		desc += " ([prod_rec.finish_name])"

/obj/item/manufacturing_parts/attackby(obj/item/I, mob/user)
	if(user.a_intent == INTENT_HARM)
		return ..()

	var/obj/structure/table/table = locate(/obj/structure/table, get_turf(src))
	if(!istype(I, /obj/item/weapon/factory) && !(table && (loc != user)))
		to_chat(user, "Для сборки положите на стол или используйте станок.")
		return

	switch(steps[step])
		if("cut")
			if(!iscutter(I))
				return
			update_icon()
			if(!I.use_tool(src, user, 30, volume = 75))
				return
		if("screw")
			if(!isscrewing(I))
				return
			update_icon()
			if(!I.use_tool(src, user, 30, volume = 75))
				return
		if("wrench")
			if(!iswrenching(I))
				return
			update_icon()
			if(!I.use_tool(src, user, 30, volume = 75))
				return
		if("weld")
			if(!iswelding(I))
				return
			update_icon()
			if(!I.use_tool(src, user, 30, volume = 75))
				return
		if("coil")
			if(!iscoil(I))
				return
			update_icon()
			if(!I.use_tool(src, user, 30, amount = 1, volume = 75))
				return
		if("pulse")
			if(!ispulsing(I))
				return
			update_icon()
			if(!I.use_tool(src, user, 30, volume = 75))
				return
		if("sew")
			if(!issewing(I))
				return
			if(!I.use_tool(src, user, 30, amount = 1, volume = 75))
				return
		else
			return

	step++
	if(step > steps.len)
		finish_assemble()
		return
	update_icon()

/obj/item/manufacturing_parts/update_icon()
	icon_state = "[parts_state]_[step]"

/obj/item/manufacturing_parts/proc/finish_assemble()
	var/obj/item/finish = new prod_rec.finish_item(get_turf(src))

	if(prod_rec.brand)
		finish.desc += " '[prod_rec.brand.name]'"
		finish.name += " '[prod_rec.finish_name]'"

	qdel(src)

/obj/item/manufacturing_parts/wood
	steps = list("cut", "screw")

	parts_state = "wood"

/obj/item/manufacturing_parts/metal
	steps = list("cut", "weld", "wrench")

	parts_state = "metal"

/obj/item/manufacturing_parts/electric
	steps = list("coil", "weld", "pulse", "screw")

	parts_state = "electric"

/obj/item/manufacturing_parts/cloth
	steps = list("cut", "sew", "sew", "sew")

	parts_state = "cloth"
