/obj/machinery/atmospherics/components/unary/suit_kiosk
	name = "suit kiosk"
	desc = "Стационарная мини-фабрика для быстрого создания и выдачи, а также обслуживания и диагностики защитных костюмов."
	icon = 'icons/obj/machines/rig_kiosk.dmi'
	icon_state = "kiosk_open"
	anchored = TRUE
	density = TRUE

	var/obj/item/clothing/suit/space/rig/Rig

/obj/machinery/atmospherics/components/unary/suit_kiosk/atom_init()
	. = ..()

/obj/machinery/atmospherics/components/unary/suit_kiosk/Destroy()
	return ..()

/obj/machinery/atmospherics/components/unary/suit_kiosk/attackby(obj/item/I, mob/user)
	add_fingerprint(user)
	if(Rig)
		if(istype(I, /obj/item/clothing/head/helmet/space/rig))
			return
		if(istype(I, /obj/item/clothing/shoes/magboots))
			return
	else
		if(istype(I, /obj/item/clothing/suit/space/rig))
			Rig = I

/obj/machinery/atmospherics/components/unary/suit_kiosk/attack_hand(mob/user)
	tgui_interact(user)

/obj/machinery/atmospherics/components/unary/suit_kiosk/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Suit_Kiosk", name)
		ui.open()

/obj/machinery/atmospherics/components/unary/suit_kiosk/tgui_data(mob/user, datum/tgui/ui)
	var/list/data = list()

	var/list/rig_to_front = list()
	rig_to_front = list("name" = name, "description" = desc)
	data["rig"] = rig_to_front

	var/list/helmet_to_front = list()
	if(Rig.helmet)
		helmet_to_front = list("name" = Rig.helmet.name, "description" = Rig.helmet.desc)
	data["helmet"] = helmet_to_front

	var/list/boots_to_front = list()
	if(Rig.boots)
		boots_to_front = list("name" = Rig.boots.name, "description" = Rig.boots.desc)
	data["boots"] = boots_to_front

	return data

/obj/machinery/atmospherics/components/unary/suit_kiosk/tgui_act(action, params)
	. = ..()
	if(.)
		return

	if(action == "")
		return TRUE
