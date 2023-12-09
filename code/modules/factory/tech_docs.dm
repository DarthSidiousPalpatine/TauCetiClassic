/obj/item/weapon/paper/tech_doc
	name = "technical documentation"
	desc = "Документация для производства"

	free_space = 0


	var/datum/production_recipe/prod_rec

/obj/item/weapon/paper/tech_doc/atom_init(mapload, datum/production_recipe/recipe)
	. = ..()

	if(!recipe)
		qdel(src)
		return

	prod_rec = recipe

	if(prod_rec.brand)
		name += " ([prod_rec.brand.name])"
		desc += " ([prod_rec.finish_name])"

	generate_document_info()

/obj/item/weapon/paper/tech_doc/proc/generate_document_info()
	return
	/*var/newinfo = ""

	newinfo += "[table][tr][th]Позиция[/th][th]Наименование[/th][th]Количество шт.[/th][/tr][/br]"
	for(var/i = 1 to 7)
		var/itemname = "ㅤ"
		var/itemamount = "ㅤ"

		if(prod_rec.materials[i])
			var/itemtype = prod_rec.materials[i]
			var/item = new itemtype()
			itemname = item.name
			qdel(item)
			itemamount = prod_rec.materials[itemtype]

		newinfo += "[tr][td][i][/td][td][itemname][/td][td][itemamount][/td][/tr][/br]"

	newinfo += "[/table][table][/br][tr][th]Шаг №[/th][th]Вид технического процесса[/th][/tr][/br]"

	for(var/i = 1 to 4)
		var/partstype = prod_rec.parts_type

		var/list/step_to_text = list("cut" = "Разрезать деталь", "screw" = "Закрутить шурупы", "weld" = "Проварить деталь", "wrench" = "Затянуть болты", "coil" = "Вставить проводку", "pulse" = "Прозвонить мультитулом", "sew" = "Прошить выкройку")

		var/obj/item/manufacturing_parts/parts = new partstype(null, prod_rec)
		var/list/steps = parts.steps.Copy()
		qdel(parts)

		var/step_name = "ㅤ"

		if(steps[i])
			step_name = step_to_text[steps[i]]

		newinfo += "[tr][td][i][/td][td][step_name][/td][/tr][/br]"

	var/finishtype = prod_rec.finish_item
	var/obj/O = new finishtype()
	newinfo += "[/table][table][/br][tr][td][global.current_date_string][/td][td][O.name][/td][/tr][tr][/br][th]Дата[/th][th]Техническая документация[/th][/tr][/br][/table]"
	qdel(O)*/

/obj/item/weapon/paper/tech_doc/afterattack(atom/target, mob/user, proximity)
	if(!proximity) return

	if(!isturf(target.loc)) return

	try_craft(target.loc, user)

/obj/item/weapon/paper/tech_doc/proc/try_craft(turf/T, mob/user)
	var/list/turf_contents = list()

	for(var/obj/O in T.contents)
		if(O.flags_2 & HOLOGRAM_2)
			continue
		if(istype(O, /obj/item/stack))
			var/obj/item/stack/S = O
			turf_contents[O.type] += S.amount
		else
			if(O.flags & OPENCONTAINER)
				for(var/datum/reagent/A in O.reagents.reagent_list)
					turf_contents[A.type] += A.volume
			turf_contents[O.type] += 1

	var/requirements = prod_rec.materials

	for(var/A in requirements)
		var/amount = requirements[A]
		for(var/B in turf_contents)
			if(!ispath(B, A))
				continue

			amount -= turf_contents[B]
			if(amount <= 0)
				break

		if(amount > 0)
			to_chat(user, "Недостаточно материалов для сборки.")
			return

	for(var/A in requirements)
		var/amount = requirements[A]

		for(var/obj/O in T.contents)
			if(O.flags_2 & HOLOGRAM_2)
				continue

			if(ispath(A, /datum/reagent) && (O.flags & OPENCONTAINER))
				var/datum/reagent/R = O.reagents.get_reagent(A)
				if(!R)
					continue
				var/reagent_amount = O.reagents.get_reagent_amount(R.id)

				if(reagent_amount < amount)
					amount -= reagent_amount
					O.reagents.remove_reagent(R.id, reagent_amount)
					continue

				O.reagents.remove_reagent(R.id, amount)
				break

			else if(ispath(A, /obj/item/stack) && istype(O, /obj/item/stack))
				var/obj/item/stack/S = O
				var/stack_amount = S.amount

				if(stack_amount < amount)
					amount -= stack_amount
					qdel(S)
					continue

				S.use(amount)
				break

			else
				qdel(O)
				break

	var/obj/item/manufacturing_parts/parts = prod_rec.generate_parts()
	parts.loc = T
