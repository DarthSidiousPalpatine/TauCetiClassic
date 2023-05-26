/obj/machinery/brazier
	name = "brazier"
	desc = "Лучшие мангалы от Waffle-Donk."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "brazier_empty"
	var/lit = FALSE
	var/coal = 0

/obj/machinery/brazier/atom_init()
	. = ..()

	AddComponent(/datum/component/clickplace, _on_slam = CALLBACK(src, .proc/cook_being))

/obj/machinery/brazier/update_icon()
	if(coal)
		icon_state = "brazier_coal"
		if(lit)
			icon_state = "brazier_lit"
	else
		icon_state = "brazier_empty"

/obj/machinery/brazier/proc/cook_being(obj/item/weapon/grab/G)
	if(!lit)
		return

