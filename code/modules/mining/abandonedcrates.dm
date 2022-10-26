#define STATE_EMPTY "empty"
#define STATE_BLANK "blank"
#define STATE_MINE "mine"

/obj/structure/closet/crate/secure/loot
	name = "заброшенный ящик"
	desc = "Что же может оказаться внутри?"
	icon_state = "securecrate"
	icon_opened = "securecrateopen"
	icon_closed = "securecrate"
	locked = TRUE
	var/list/grid
	var/grid_x = 0
	var/grid_y = 0
	var/grid_mines = 0
	var/grid_blanks = 0
	var/grid_pressed = 0
	var/list/nearest_mask = list(
							  list(-1,-1),	list(0,-1),		list(1,-1),
							  list(-1, 0),					list(1, 0),
							  list(-1, 1),	list(0, 1),		list(1, 1)
							)

/obj/structure/closet/crate/secure/loot/atom_init()
	. = ..()

	grid_x = rand(10,15)
	grid_y = rand(7,10)

	grid_mines = rand(7,17)

	grid = new/list(grid_y, grid_x)

	for(var/i = 1 to grid_y)
		var/list/Line = grid[i]
		for(var/j = 1 to grid_x)
			Line[j] = list("state" = STATE_BLANK, "x" = j, "y" = i, "nearest" = "", flag = FALSE)
			grid_blanks++

	for(var/i = 1 to grid_mines)
		while(TRUE)
			var/y = rand(1,grid_y)
			var/x = rand(1,grid_x)
			var/list/L = grid[y][x]
			if(L["state"] == STATE_MINE)
				continue
			else
				L["state"] = STATE_MINE
				grid_blanks--
				break

/obj/structure/closet/crate/secure/loot/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Minesweeper")
		ui.open()

/obj/structure/closet/crate/secure/loot/tgui_data(mob/user)
	var/list/data = list()

	data["grid"] = grid
	data["width"] = grid_x*30
	data["height"] = grid_y*30
	data["mines"] = "Crate Lock. [num2text(grid_mines)] mines."

	return data

/obj/structure/closet/crate/secure/loot/tgui_act(action, params)
	. = ..()
	if(.)
		return
	update_icon()
	if(action == "button_press")
		press_button(params["choice_x"], params["choice_y"], FALSE)
		return TRUE
	if(action == "mark_flag")
		press_button(params["choice_x"], params["choice_y"], TRUE)
		return TRUE

/obj/structure/closet/crate/secure/loot/attack_hand(mob/user)
	if(!locked)
		return ..()
	tgui_interact(user)

/obj/structure/closet/crate/secure/loot/proc/check_in_grid(x, y)
	return x >= 1 && x <= grid_x && y >= 1 && y <= grid_y

/obj/structure/closet/crate/secure/loot/proc/press_button(x, y, flag)
	x = text2num(x)
	y = text2num(y)
	var/list/cell = grid[y][x]

	if(cell["state"] == STATE_EMPTY)
		return

	if(flag)
		mark_flag(x, y, cell["flag"])
		return

	if(cell["state"] == STATE_MINE)
		SpawnDeathLoot()
		return

	reveal_button(x, y)

/obj/structure/closet/crate/secure/loot/proc/mark_flag(x, y, remove)
	grid[y][x]["flag"] = !remove

/obj/structure/closet/crate/secure/loot/proc/reveal_button(x, y)
	if(!check_in_grid(x, y) || grid[y][x]["state"] == STATE_EMPTY || grid[y][x]["flag"])
		return
	grid[y][x]["state"] = STATE_EMPTY
	grid_pressed++
	check_complete()
	var/mines = check_mines(x,y)
	if(mines)
		if(mines == 0)
			mines = " " //! careful, invisible non-whitespace
		grid[y][x]["nearest"] = num2text(mines)
		return
	for(var/list/mask in nearest_mask)
		reveal_button(x + mask[1], y + mask[2])

/obj/structure/closet/crate/secure/loot/proc/check_mines(x,y)
	var/mins = 0

	for(var/list/mask in nearest_mask)
		if(check_in_grid(x + mask[1], y + mask[2]) && grid[y + mask[2]][x + mask[1]]["state"] == STATE_MINE)
			mins++

	return mins

/obj/structure/closet/crate/secure/loot/proc/check_complete()
	if(grid_pressed == grid_blanks)
		var/loot_quality = 2*grid_mines/grid_blanks
		if(prob(loot_quality*100))
			SpawnGoodLoot()
		else
			loot_quality = loot_quality/(1 - loot_quality)
			if(prob(loot_quality*100))
				SpawnMediumLoot()
			else
				SpawnBadLoot()
		visible_message("<span class='notice'>Издавая звук, ящик открывается!</span>")
		locked = FALSE
		add_overlay(greenlight)
		SStgui.close_uis(src)


/obj/structure/closet/crate/secure/loot/proc/SpawnGoodLoot()
	playsound(src, 'sound/misc/mining_reward_3.ogg', VOL_EFFECTS_MASTER, 100, FALSE)
	switch(rand(1, 3))
		if(1)
			new/obj/item/weapon/melee/classic_baton(src)
		if(2)
			new/obj/item/weapon/sledgehammer(src)
		if(3)
			new/obj/item/weapon/gun/energy/xray(src)

/obj/structure/closet/crate/secure/loot/proc/SpawnMediumLoot()
	playsound(src, 'sound/misc/mining_reward_2.ogg', VOL_EFFECTS_MASTER, 100, FALSE)
	switch(rand(1, 4))
		if(1)
			new/obj/item/weapon/pickaxe/drill/diamond_drill(src)
			new/obj/item/device/taperecorder(src)
			new/obj/item/clothing/suit/space(src)
			new/obj/item/clothing/head/helmet/space(src)
		if(2)
			for (var/i in 1 to 3)
				new/obj/item/weapon/reagent_containers/glass/beaker/noreact(src)
		if(3)
			for (var/i in 1 to 9)
				new/obj/item/bluespace_crystal(src)
		if(4)
			for (var/i in 1 to 3)
				new/obj/item/weapon/reagent_containers/glass/beaker/bluespace(src)

/obj/structure/closet/crate/secure/loot/proc/SpawnBadLoot()
	playsound(src, 'sound/misc/mining_reward_1.ogg', VOL_EFFECTS_MASTER, 100, FALSE)
	switch(rand(1, 3))
		if(1)
			new/obj/item/clothing/under/shorts/black(src)
			new/obj/item/clothing/under/shorts/red(src)
			new/obj/item/clothing/under/shorts/blue(src)
		if(2)
			new/obj/item/weapon/reagent_containers/food/drinks/bottle/rum(src)
			new/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiadeus(src)
			new/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey(src)
			new/obj/item/weapon/lighter/zippo(src)
		if(3)
			new/obj/item/clothing/under/chameleon(src)
			new/obj/item/clothing/head/chameleon(src)

/obj/structure/closet/crate/secure/loot/proc/SpawnDeathLoot()
	playsound(src, 'sound/misc/mining_reward_0.ogg', VOL_EFFECTS_MASTER, 100, FALSE)
	for(var/mob/living/carbon/C in viewers(src, 2))
		C.flash_eyes()
	new/mob/living/simple_animal/hostile/mimic/crate(loc)
	qdel(src)

/obj/structure/closet/crate/secure/loot/emag_act(mob/user)
	if(locked)
		visible_message("<span class='notice'>Таинственный ящик мерцает и со скрипом приоткрывается!</span>")
		locked = FALSE
		SpawnBadLoot()
		return TRUE
	return FALSE

/obj/structure/closet/crate/secure/loot/deconstruct(disassembled)
	if(locked)
		SpawnDeathLoot()
		return
	..()

/obj/structure/closet/crate/secure/loot/togglelock(mob/user)
	return

/obj/structure/closet/crate/secure/loot/dump_contents()
	if(locked)
		return
	..()

#undef STATE_EMPTY
#undef STATE_BLANK
#undef STATE_FLAG
#undef STATE_MINE
