/obj/item/device/cardpay
	name = "Card pay device"
	desc = "Совершайте покупки простым движением карты."
	icon = 'icons/obj/device.dmi'
	icon_state = "card-pay-idle"

	slot_flags = SLOT_FLAGS_BELT
	m_amt = 7000
	g_amt = 2000

	var/linked_account = 0
	var/pay_amount = 0
	var/display_price = 0
	var/reset = TRUE
	var/enter_account = FALSE

	var/image/holoprice

/obj/item/device/cardpay/atom_init(mapload)
	. = ..()

	if(mapload && locate(/obj/structure/table, get_turf(src)))
		anchored = TRUE

	holoprice = image('icons/effects/32x32.dmi', "blank")
	holoprice.layer = INDICATOR_LAYER

	holoprice.maptext_y = 5
	holoprice.maptext_width = 40
	holoprice.maptext_x = -4

	add_overlay(holoprice)

/obj/item/device/cardpay/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/card/id) && anchored)
		visible_message("<span class='info'>[usr] прикладывает карту к терминалу.</span>")
		if(enter_account)
			var/obj/item/weapon/card/id/Card = I
			var/datum/money_account/D = get_account(Card.associated_account_number)
			if(D)
				linked_account = D.account_number
				playsound(src, 'sound/machines/chime.ogg', VOL_EFFECTS_MASTER)
				to_chat(user, "<span class='notice'>Аккаунт подключён.</span>")
			else
				to_chat(user, "<span class='notice'>Нет аккаунта, привязанного к карте.</span>")
		else
			scan_card(I)
	else if(istype(I, /obj/item/device/pda) && I.GetID())
		visible_message("<span class='info'>[usr] прикладывает КПК к терминалу.</span>")
		var/obj/item/weapon/card/id/Card = I.GetID()
		scan_card(Card)
	else if(istype(I, /obj/item/weapon/wrench) && isturf(src.loc))
		var/obj/item/weapon/wrench/Tool = I
		if(Tool.use_tool(src, user, SKILL_TASK_VERY_EASY, volume = 50))
			playsound(src, 'sound/items/Ratchet.ogg', VOL_EFFECTS_MASTER)
			user.SetNextMove(CLICK_CD_INTERACT)
			if(user.is_busy())
				return
			if(anchored)
				to_chat(user, "<span class='notice'>Сканер откручен.</span>")
				anchored = FALSE
				update_holoprice(clear = TRUE)
				SStgui.close_uis(src)
			else
				if(locate(/obj/structure/table, get_turf(src)))
					to_chat(user, "<span class='warning'>Сканер прикручен.</span>")
					anchored = TRUE
				else
					to_chat(user, "<span class='warning'>Сканер можно прикрутить только к столу.</span>")
	else
		return ..()

/obj/item/device/cardpay/attack_self(mob/living/user)
	. = ..()

	set_dir(turn(dir,-90))

/obj/item/device/cardpay/proc/scan_card(obj/item/weapon/card/id/Card)
	if(!linked_account)
		visible_message("[bicon(src)]<span class='warning'>Нет подключённого аккаунта.</span>")
		return
	var/datum/money_account/Acc = get_account(linked_account)
	if(!Acc || Acc.suspended)
		visible_message("[bicon(src)]<span class='warning'>Подключённый аккаунт заблокирован.</span>")
		return
	if(pay_amount <= 0)
		return

	var/pay_holder = pay_amount

	var/datum/money_account/D = get_account(Card.associated_account_number)
	var/attempt_pin = 0
	if(D)
		if(D.security_level > 0)
			var/time_for_pin = world.time
			attempt_pin = input("Введите ПИН-код", "Терминал оплаты") as num
			if(world.time - time_for_pin > 300)
				to_chat(usr, "[bicon(src)]<span class='warning'>Время операции истекло!</span>")
				return
			if(isnull(attempt_pin))
				to_chat(usr, "[bicon(src)]<span class='warning'>Неверный ПИН-код!</span>")
				return
			D = attempt_account_access(Card.associated_account_number, attempt_pin, 2)
			if(!D)
				to_chat(usr, "[bicon(src)]<span class='warning'>Неверный ПИН-код!</span>")
				return

		icon_state = "card-pay-processing"
		addtimer(CALLBACK(src, .proc/make_transaction, D, pay_holder), 3 SECONDS)

/obj/item/device/cardpay/proc/make_transaction(datum/money_account/Acc, amount)
	if(!src || !Acc)
		return
	icon_state = "card-pay-idle"
	playsound(src, 'sound/machines/quite_beep.ogg', VOL_EFFECTS_MASTER)
	if(amount <= Acc.money)
		flick("card-pay-complete", src)
		charge_to_account(Acc.account_number, "Терминал оплаты", "Оплата", src.name, -amount)
		charge_to_account(linked_account, "Терминал оплаты", "Прибыль", src.name, amount)
		if(reset)
			pay_amount = 0
			update_holoprice(clear = TRUE)
	else
		visible_message("[bicon(src)]<span class='warning'>Недостаточно средств!</span>")
		flick("card-pay-error", src)

/obj/item/device/cardpay/attack_hand(mob/user)
	. = ..()
	if(!isturf(src.loc))
		return

	if(anchored && check_direction(user))
		tgui_interact(user)

/obj/item/device/cardpay/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CardPay", "Терминал")
		ui.open()

/obj/item/device/cardpay/tgui_data(mob/user)
	var/list/data = list()
	data["numbers"] = display_price
	data["reset_numbers"] = reset
	data["enter_account"] = enter_account
	return data

/obj/item/device/cardpay/tgui_act(action, params)
	. = ..()
	if(.)
		return

	if(!check_direction(usr))
		SStgui.close_user_uis(usr, src)
		return

	switch(action)
		if("pressnumber")
			var/num = params["number"]
			if(isnum(num))
				num = clamp(num, 0, 9)
				display_price *= 10
				display_price += num
				if(enter_account && display_price > 999999)
					display_price %= 1000000
				else if(!enter_account && display_price > 999)
					display_price %= 1000
				playsound(src, 'sound/items/buttonclick.ogg', VOL_EFFECTS_MASTER)
				return TRUE
		if("clearnumbers")
			if(display_price == 0)
				pay_amount = 0
			display_price = 0
			playsound(src, 'sound/machines/quite_beep.ogg', VOL_EFFECTS_MASTER)
			return TRUE
		if("approveprice")
			if(display_price > 0)
				if(enter_account)
					if(display_price >= 111111 && display_price <= 999999)
						var/datum/money_account/D = get_account(display_price)
						if(D)
							linked_account = display_price
				else
					pay_amount = display_price
					update_holoprice(clear = FALSE)
				display_price = 0
				playsound(src, 'sound/machines/quite_beep.ogg', VOL_EFFECTS_MASTER)
				return TRUE
		if("togglereset")
			reset = !reset
			playsound(src, 'sound/items/buttonswitch.ogg', VOL_EFFECTS_MASTER)
			return TRUE
		if("toggleenteraccount")
			display_price = 0
			enter_account = !enter_account
			playsound(src, 'sound/items/buttonswitch.ogg', VOL_EFFECTS_MASTER)
			return TRUE

/obj/item/device/cardpay/proc/update_holoprice(clear)
	cut_overlay(holoprice)
	if(clear)
		holoprice.maptext = ""
		holoprice.icon = 'icons/effects/32x32.dmi'
		holoprice.icon_state = "blank"
	else
		holoprice.maptext = {"<div style="font-size:9pt;color:#22DD22;font:'Arial Black';text-align:center;" valign="top">[pay_amount]$</div>"}
		holoprice.icon = 'icons/obj/device.dmi'
		holoprice.icon_state = "holo_overlay"
	add_overlay(holoprice)

/obj/item/device/cardpay/proc/check_direction(mob/user)
	return is_the_opposite_dir(src.dir, get_dir(src, user))
