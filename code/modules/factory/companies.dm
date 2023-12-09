var/global/list/product_names = list()

/datum/company
	var/name = "Company name"
	var/desc = "Company description"

	var/list/possible_recipes = list()

	var/list/production_recipes = list()

	var/list/nonrecipe_orders = list()

	var/list/orders = list()

/datum/company/New()
	for(var/recipe_type in possible_recipes)
		var/datum/production_recipe/recipe = new recipe_type()
		recipe.brand = src
		production_recipes += recipe


/datum/company/EE
	name = "Eistein Electric"
	desc = "Дочерняя компания Einstein Engines, специализирующаяся на производстве бытовой техники."

	possible_recipes = list(/datum/production_recipe/printer, /datum/production_recipe/scaner, /datum/production_recipe/fax, /datum/production_recipe/cash)

/datum/company/ER
	name = "Eistein Robotics"
	desc = "Дочерняя компания Einstein Engines, специализирующаяся на производстве роботов."

	possible_recipes = list(/datum/production_recipe/bigbot, /datum/production_recipe/smallbot)

/datum/company/BTS
	name = "BioTech Solutions"
	desc = "Ведущий производитель роботов."

	possible_recipes = list(/datum/production_recipe/bee1, /datum/production_recipe/bee2, /datum/production_recipe/bee3, /datum/production_recipe/bee4)

/datum/company/VM
	name = "Vey Med"
	desc = "Технологии, жизнь, инновации — Мы в Vey Med остаемся на переднем плане, расширяя границы завтрашнего дня."

	possible_recipes = list(/datum/production_recipe/medpouch)

/datum/company/WTGMB
	name = "Ward-Takahashi GMB"
	desc = "Посмотри внутрь любой бытовой электроники и логотип Вард-Такахаши ГМБ возможно будет отпечатан на каждом чипе внутри."

	possible_recipes = list(/datum/production_recipe/wallclock, /datum/production_recipe/tableclock, /datum/production_recipe/pda1,
						/datum/production_recipe/pda2, /datum/production_recipe/pda3, /datum/production_recipe/pda4, /datum/production_recipe/pda5,
						/datum/production_recipe/pda6, /datum/production_recipe/pda7, /datum/production_recipe/pda8)

/datum/company/GE
	name = "Gilthari Exports"
	desc = "Крупнейший производитель алкоголя и предметов роскоши в известном космосе."

	possible_recipes = list(/datum/production_recipe/cup1, /datum/production_recipe/cup2, /datum/production_recipe/cup3, /datum/production_recipe/cup4,
						/datum/production_recipe/newtons_pendulum, /datum/production_recipe/mars_globe, /datum/production_recipe/venus_globe,
						/datum/production_recipe/earth_globe, /datum/production_recipe/yargon_globe, /datum/production_recipe/woodenclock,
						/datum/production_recipe/statue1, /datum/production_recipe/statue2, /datum/production_recipe/statue3, /datum/production_recipe/statue4,
						/datum/production_recipe/bust1, /datum/production_recipe/bust2, /datum/production_recipe/bust3)

/datum/company/GMLTD
	name = "Grayson Manufactories Ltd"
	desc = "Крупнейший производитель мебели."

	possible_recipes = list(/datum/production_recipe/stool1, /datum/production_recipe/stool2, /datum/production_recipe/stool3, /datum/production_recipe/stool4, /datum/production_recipe/stool5,
						/datum/production_recipe/chair1, /datum/production_recipe/chair2, /datum/production_recipe/chair3, /datum/production_recipe/chair4, /datum/production_recipe/chair5,
						/datum/production_recipe/bed1, /datum/production_recipe/bed2, /datum/production_recipe/bed3, /datum/production_recipe/bed4, /datum/production_recipe/bed5,
						/datum/production_recipe/table1, /datum/production_recipe/table2, /datum/production_recipe/table3, /datum/production_recipe/table4, /datum/production_recipe/table5,
						/datum/production_recipe/table6, /datum/production_recipe/table7, /datum/production_recipe/table8, /datum/production_recipe/table9, /datum/production_recipe/table10,
						/datum/production_recipe/mirror1, /datum/production_recipe/mirror2, /datum/production_recipe/mirror3,
						/datum/production_recipe/coatrack1, /datum/production_recipe/coatrack2, /datum/production_recipe/coatrack3,
						/datum/production_recipe/bin1, /datum/production_recipe/bin2, /datum/production_recipe/bin3,
						/datum/production_recipe/bootrack1, /datum/production_recipe/bootrack2, /datum/production_recipe/bootrack3,
						/datum/production_recipe/grill, /datum/production_recipe/barstool)

/datum/company/NT
	name = "NanoTrasen"
	desc = "Корпорация Nanotrasen, упоминаемая как просто Nanotrasen, является одной из крупнейших мегакорпораций в человеческом секторе космоса."

	possible_recipes = list(/datum/production_recipe/portrait)
