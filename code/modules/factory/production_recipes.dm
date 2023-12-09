/datum/production_recipe
	var/name = "production recipe"

	var/parts_type

	var/finish_item
	var/finish_name

	var/datum/company/brand

	var/list/materials = list()

/datum/production_recipe/proc/generate_parts()
	var/obj/item/manufacturing_parts/parts = new parts_type(null, src)
	return parts

/datum/production_recipe/proc/genetare_techdoc()
	var/obj/item/weapon/paper/tech_doc/doc = new /obj/item/weapon/paper/tech_doc(null, src)
	return doc


//-----------SMALL ITEMS-----------//
/datum/production_recipe/cup1
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/item/goods/cup1
	materials = list(/obj/item/stack/sheet/wood = 1)

/datum/production_recipe/cup2
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/item/goods/cup2
	materials = list(/obj/item/stack/sheet/wood = 1)

/datum/production_recipe/cup3
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/item/goods/cup3
	materials = list(/obj/item/stack/sheet/wood = 1)

/datum/production_recipe/cup4
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/item/goods/cup4
	materials = list(/obj/item/stack/sheet/wood = 1)

/datum/production_recipe/statue1
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/item/goods/statue1
	materials = list(/obj/item/stack/sheet/wood = 3)

/datum/production_recipe/statue2
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/item/goods/statue2
	materials = list(/obj/item/stack/sheet/wood = 3)

/datum/production_recipe/statue3
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/item/goods/statue3
	materials = list(/obj/item/stack/sheet/wood = 3)

/datum/production_recipe/statue4
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/item/goods/statue4
	materials = list(/obj/item/stack/sheet/wood = 3)

/datum/production_recipe/bust1
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/item/goods/bust1
	materials = list(/obj/item/stack/sheet/wood = 2)

/datum/production_recipe/bust2
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/item/goods/bust2
	materials = list(/obj/item/stack/sheet/wood = 2)

/datum/production_recipe/bust3
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/item/goods/bust3
	materials = list(/obj/item/stack/sheet/wood = 2)

/datum/production_recipe/pda1
	parts_type = /obj/item/manufacturing_parts/electric
	finish_item = /obj/item/goods/pda1
	materials = list(/obj/item/stack/sheet/mineral/plastic = 3, /obj/item/stack/sheet/metal = 1, /obj/item/weapon/stock_parts/capacitor = 1, /obj/item/weapon/stock_parts/scanning_module = 1, /obj/item/stack/sheet/mineral/gold = 1)

/datum/production_recipe/pda2
	parts_type = /obj/item/manufacturing_parts/electric
	finish_item = /obj/item/goods/pda2
	materials = list(/obj/item/stack/sheet/mineral/plastic = 3, /obj/item/stack/sheet/metal = 1, /obj/item/weapon/stock_parts/capacitor = 1, /obj/item/weapon/stock_parts/scanning_module = 1, /obj/item/stack/sheet/mineral/gold = 1)

/datum/production_recipe/pda3
	parts_type = /obj/item/manufacturing_parts/electric
	finish_item = /obj/item/goods/pda3
	materials = list(/obj/item/stack/sheet/mineral/plastic = 3, /obj/item/stack/sheet/metal = 1, /obj/item/weapon/stock_parts/capacitor = 1, /obj/item/weapon/stock_parts/scanning_module = 1, /obj/item/stack/sheet/mineral/gold = 1)

/datum/production_recipe/pda4
	parts_type = /obj/item/manufacturing_parts/electric
	finish_item = /obj/item/goods/pda4
	materials = list(/obj/item/stack/sheet/mineral/plastic = 3, /obj/item/stack/sheet/metal = 1, /obj/item/weapon/stock_parts/capacitor = 1, /obj/item/weapon/stock_parts/scanning_module = 1, /obj/item/stack/sheet/mineral/gold = 1)

/datum/production_recipe/pda5
	parts_type = /obj/item/manufacturing_parts/electric
	finish_item = /obj/item/goods/pda5
	materials = list(/obj/item/stack/sheet/mineral/plastic = 2, /obj/item/stack/sheet/metal = 1, /obj/item/weapon/stock_parts/capacitor = 1, /obj/item/weapon/stock_parts/scanning_module = 1, /obj/item/stack/sheet/mineral/gold = 1)

/datum/production_recipe/pda6
	parts_type = /obj/item/manufacturing_parts/electric
	finish_item = /obj/item/goods/pda6
	materials = list(/obj/item/stack/sheet/mineral/plastic = 2, /obj/item/stack/sheet/metal = 1, /obj/item/weapon/stock_parts/capacitor = 1, /obj/item/weapon/stock_parts/scanning_module = 1, /obj/item/stack/sheet/mineral/gold = 1)

/datum/production_recipe/pda7
	parts_type = /obj/item/manufacturing_parts/electric
	finish_item = /obj/item/goods/pda7
	materials = list(/obj/item/stack/sheet/mineral/plastic = 5, /obj/item/stack/sheet/metal = 1, /obj/item/weapon/stock_parts/capacitor = 1, /obj/item/weapon/stock_parts/scanning_module = 1, /obj/item/stack/sheet/mineral/gold = 1)

/datum/production_recipe/pda8
	parts_type = /obj/item/manufacturing_parts/electric
	finish_item = /obj/item/goods/pda8
	materials = list(/obj/item/stack/sheet/mineral/plastic = 5, /obj/item/stack/sheet/metal = 1, /obj/item/weapon/stock_parts/capacitor = 1, /obj/item/weapon/stock_parts/scanning_module = 1, /obj/item/stack/sheet/mineral/gold = 1)

/datum/production_recipe/bee1
	parts_type = /obj/item/manufacturing_parts/electric
	finish_item = /obj/item/goods/bee1
	materials = list(/obj/item/stack/sheet/mineral/plastic = 1, /obj/item/stack/sheet/metal = 7, /obj/item/weapon/stock_parts/capacitor = 2, /obj/item/weapon/stock_parts/manipulator = 2, /obj/item/weapon/stock_parts/scanning_module = 1, /obj/item/stack/sheet/mineral/gold = 1)

/datum/production_recipe/bee2
	parts_type = /obj/item/manufacturing_parts/electric
	finish_item = /obj/item/goods/bee2
	materials = list(/obj/item/stack/sheet/mineral/plastic = 1, /obj/item/stack/sheet/metal = 7, /obj/item/weapon/stock_parts/capacitor = 2, /obj/item/weapon/stock_parts/manipulator = 2, /obj/item/weapon/stock_parts/scanning_module = 1, /obj/item/stack/sheet/mineral/gold = 1)

/datum/production_recipe/bee3
	parts_type = /obj/item/manufacturing_parts/electric
	finish_item = /obj/item/goods/bee3
	materials = list(/obj/item/stack/sheet/mineral/plastic = 1, /obj/item/stack/sheet/metal = 7, /obj/item/weapon/stock_parts/capacitor = 2, /obj/item/weapon/stock_parts/manipulator = 2, /obj/item/weapon/stock_parts/scanning_module = 1, /obj/item/stack/sheet/mineral/gold = 1)

/datum/production_recipe/bee4
	parts_type = /obj/item/manufacturing_parts/electric
	finish_item = /obj/item/goods/bee4
	materials = list(/obj/item/stack/sheet/mineral/plastic = 1, /obj/item/stack/sheet/metal = 7, /obj/item/weapon/stock_parts/capacitor = 2, /obj/item/weapon/stock_parts/manipulator = 2, /obj/item/weapon/stock_parts/scanning_module = 1, /obj/item/stack/sheet/mineral/gold = 1)

/datum/production_recipe/smallbot
	parts_type = /obj/item/manufacturing_parts/electric
	finish_item = /obj/item/goods/smallbot
	materials = list(/obj/item/stack/sheet/mineral/plastic = 7, /obj/item/stack/sheet/metal = 1, /obj/item/weapon/stock_parts/capacitor = 1, /obj/item/weapon/stock_parts/manipulator = 1, /obj/item/weapon/stock_parts/scanning_module = 1, /obj/item/stack/sheet/mineral/gold = 1)

/datum/production_recipe/printer
	parts_type = /obj/item/manufacturing_parts/electric
	finish_item = /obj/item/goods/printer
	materials = list(/obj/item/stack/sheet/mineral/plastic = 7, /obj/item/stack/sheet/metal = 1, /obj/item/weapon/stock_parts/capacitor = 1, /obj/item/weapon/stock_parts/micro_laser = 1, /obj/item/weapon/stock_parts/scanning_module = 1, /obj/item/stack/sheet/mineral/gold = 1)

/datum/production_recipe/scaner
	parts_type = /obj/item/manufacturing_parts/electric
	finish_item = /obj/item/goods/scaner
	materials = list(/obj/item/stack/sheet/mineral/plastic = 7, /obj/item/stack/sheet/metal = 1, /obj/item/weapon/stock_parts/capacitor = 1, /obj/item/weapon/stock_parts/micro_laser = 1, /obj/item/weapon/stock_parts/scanning_module = 1, /obj/item/stack/sheet/mineral/gold = 1)

/datum/production_recipe/fax
	parts_type = /obj/item/manufacturing_parts/electric
	finish_item = /obj/item/goods/fax
	materials = list(/obj/item/stack/sheet/mineral/plastic = 7, /obj/item/stack/sheet/metal = 1, /obj/item/weapon/stock_parts/capacitor = 1, /obj/item/weapon/stock_parts/micro_laser = 1, /obj/item/weapon/stock_parts/scanning_module = 1, /obj/item/stack/sheet/mineral/gold = 1)

/datum/production_recipe/medpouch
	parts_type = /obj/item/manufacturing_parts/cloth
	finish_item = /obj/item/goods/medpouch
	materials = list(/obj/item/stack/sheet/cloth = 2, /obj/item/stack/sheet/metal = 1)


//-----------BIG ITEMS-----------//
/datum/production_recipe/cash
	parts_type = /obj/item/manufacturing_parts/electric
	finish_item = /obj/structure/goods/cash
	materials = list(/obj/item/stack/sheet/mineral/plastic = 5, /obj/item/stack/sheet/metal = 15, /obj/item/weapon/stock_parts/capacitor = 2, /obj/item/weapon/stock_parts/scanning_module = 1, /obj/item/stack/sheet/mineral/gold = 1)

/datum/production_recipe/bigbot
	parts_type = /obj/item/manufacturing_parts/electric
	finish_item = /obj/structure/goods/bigbot
	materials = list(/obj/item/stack/sheet/mineral/plastic = 15, /obj/item/stack/sheet/metal = 10, /obj/item/weapon/stock_parts/capacitor = 4, /obj/item/weapon/stock_parts/scanning_module = 2, /obj/item/stack/sheet/mineral/gold = 1)


//-----------FURNITURE-----------//
//Stools
/datum/production_recipe/stool1
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/structure/goods/furniture/stool
	materials = list(/obj/item/stack/sheet/wood = 3, /obj/item/stack/sheet/cloth = 2)

/datum/production_recipe/stool2
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/stool/stool2
	materials = list(/obj/item/stack/sheet/metal = 4, /obj/item/stack/sheet/cloth = 1)

/datum/production_recipe/stool3
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/stool/stool3
	materials = list(/obj/item/stack/sheet/metal = 5)

/datum/production_recipe/stool4
	parts_type = /obj/item/manufacturing_parts/cloth
	finish_item = /obj/structure/goods/furniture/stool/stool4
	materials = list(/obj/item/stack/sheet/cloth = 5)

/datum/production_recipe/stool5
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/stool/stool5
	materials = list(/obj/item/stack/sheet/metal = 3, /obj/item/stack/sheet/cloth = 2)

//Chairs
/datum/production_recipe/chair1
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/structure/goods/furniture/chair
	materials = list(/obj/item/stack/sheet/wood = 6, /obj/item/stack/sheet/cloth = 4)

/datum/production_recipe/chair2
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/chair/chair2
	materials = list(/obj/item/stack/sheet/metal = 8, /obj/item/stack/sheet/cloth = 2)

/datum/production_recipe/chair3
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/chair/chair3
	materials = list(/obj/item/stack/sheet/metal = 10)

/datum/production_recipe/chair4
	parts_type = /obj/item/manufacturing_parts/cloth
	finish_item = /obj/structure/goods/furniture/chair/chair4
	materials = list(/obj/item/stack/sheet/cloth = 10)

/datum/production_recipe/chair5
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/chair/chair5
	materials = list(/obj/item/stack/sheet/metal = 6, /obj/item/stack/sheet/cloth = 4)

//Beds
/datum/production_recipe/bed1
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/structure/goods/furniture/bed
	materials = list(/obj/item/stack/sheet/wood = 10, /obj/item/stack/sheet/cloth = 5)

/datum/production_recipe/bed2
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/bed/bed2
	materials = list(/obj/item/stack/sheet/metal = 12, /obj/item/stack/sheet/cloth = 3)

/datum/production_recipe/bed3
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/bed/bed3
	materials = list(/obj/item/stack/sheet/metal = 15)

/datum/production_recipe/bed4
	parts_type = /obj/item/manufacturing_parts/cloth
	finish_item = /obj/structure/goods/furniture/bed/bed4
	materials = list(/obj/item/stack/sheet/cloth = 15)

/datum/production_recipe/bed5
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/bed/bed5
	materials = list(/obj/item/stack/sheet/metal = 10, /obj/item/stack/sheet/cloth = 5)

//Tables
/datum/production_recipe/table1
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/structure/goods/furniture/table
	materials = list(/obj/item/stack/sheet/wood = 15)

/datum/production_recipe/table2
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/structure/goods/furniture/table/table2
	materials = list(/obj/item/stack/sheet/wood = 7)

/datum/production_recipe/table3
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/table/table3
	materials = list(/obj/item/stack/sheet/metal = 10)

/datum/production_recipe/table4
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/table/table4
	materials = list(/obj/item/stack/sheet/metal = 5)

/datum/production_recipe/table5
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/table/table5
	materials = list(/obj/item/stack/sheet/metal = 15)

/datum/production_recipe/table6
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/table/table6
	materials = list(/obj/item/stack/sheet/metal = 7)

/datum/production_recipe/table7
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/table/table7
	materials = list(/obj/item/stack/sheet/metal = 7, /obj/item/stack/sheet/metal = 8)

/datum/production_recipe/table8
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/table/table8
	materials = list(/obj/item/stack/sheet/metal = 15)

/datum/production_recipe/table9
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/structure/goods/furniture/table/table9
	materials = list(/obj/item/stack/sheet/wood = 10)

/datum/production_recipe/table10
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/structure/goods/furniture/table/table10
	materials = list(/obj/item/stack/sheet/wood = 15)

//Mirrors
/datum/production_recipe/mirror1
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/structure/goods/furniture/mirror
	materials = list(/obj/item/stack/sheet/wood = 5, /obj/item/stack/sheet/glass = 10)

/datum/production_recipe/mirror2
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/mirror/mirror2
	materials = list(/obj/item/stack/sheet/metal = 5, /obj/item/stack/sheet/glass = 10)

/datum/production_recipe/mirror3
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/mirror/mirror3
	materials = list(/obj/item/stack/sheet/metal = 10, /obj/item/stack/sheet/glass = 10)

//Coatracks
/datum/production_recipe/coatrack1
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/structure/goods/furniture/coatrack
	materials = list(/obj/item/stack/sheet/wood = 5)

/datum/production_recipe/coatrack2
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/coatrack/coatrack2
	materials = list(/obj/item/stack/sheet/metal = 5)

/datum/production_recipe/coatrack3
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/coatrack/coatrack3
	materials = list(/obj/item/stack/sheet/metal = 5)

//Bins
/datum/production_recipe/bin1
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/structure/goods/furniture/bin
	materials = list(/obj/item/stack/sheet/wood = 7)

/datum/production_recipe/bin2
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/bin/bin2
	materials = list(/obj/item/stack/sheet/metal = 7)

/datum/production_recipe/bin3
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/bin/bin3
	materials = list(/obj/item/stack/sheet/metal = 7)

//Bootracks
/datum/production_recipe/bootrack1
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/structure/goods/furniture/bootrack
	materials = list(/obj/item/stack/sheet/wood = 3)

/datum/production_recipe/bootrack2
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/bootrack/bootrack2
	materials = list(/obj/item/stack/sheet/metal = 3)

/datum/production_recipe/bootrack3
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/bootrack/bootrack3
	materials = list(/obj/item/stack/sheet/metal = 3)

//Etc
/datum/production_recipe/grill
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/grill
	materials = list(/obj/item/stack/sheet/metal = 10)

/datum/production_recipe/barstool
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/structure/goods/furniture/barstool
	materials = list(/obj/item/stack/sheet/metal = 7)

//-----------ETC-----------//
/datum/production_recipe/mars_globe
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/item/mars_globe
	materials = list(/obj/item/stack/sheet/wood = 4)

/datum/production_recipe/venus_globe
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/item/venus_globe
	materials = list(/obj/item/stack/sheet/wood = 4)

/datum/production_recipe/earth_globe
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/item/earth_globe
	materials = list(/obj/item/stack/sheet/wood = 4)

/datum/production_recipe/yargon_globe
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/item/yargon_globe
	materials = list(/obj/item/stack/sheet/wood = 4)

/datum/production_recipe/newtons_pendulum
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/item/newtons_pendulum
	materials = list(/obj/item/stack/sheet/metal = 2)

/datum/production_recipe/woodenclock
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/item/woodenclock
	materials = list(/obj/item/stack/sheet/wood = 6)

/datum/production_recipe/wallclock
	parts_type = /obj/item/manufacturing_parts/metal
	finish_item = /obj/item/wallclock
	materials = list(/obj/item/stack/sheet/metal = 4)

/datum/production_recipe/tableclock
	parts_type = /obj/item/manufacturing_parts/electric
	finish_item = /obj/item/tableclock
	materials = list(/obj/item/stack/sheet/mineral/plastic = 5, /obj/item/stack/sheet/metal = 1, /obj/item/weapon/stock_parts/capacitor = 1)

/datum/production_recipe/portrait
	parts_type = /obj/item/manufacturing_parts/wood
	finish_item = /obj/item/portrait
	materials = list(/obj/item/stack/sheet/wood = 4)