/obj/item/weapon/reagent_containers/food/drinks/cans
	name = "soda can"
	var/canopened = 0

/obj/item/weapon/reagent_containers/food/drinks/cans/atom_init()
	. = ..()

	if(!canopened)
		flags &= ~OPENCONTAINER
		verbs -= /obj/item/weapon/reagent_containers/food/drinks/proc/gulp_whole

/obj/item/weapon/reagent_containers/food/drinks/cans/attack_self(mob/user)
	if (!canopened)
		playsound(src, pick(SOUNDIN_CAN_OPEN), VOL_EFFECTS_MASTER, rand(10, 50))
		to_chat(user, "<span class='notice'>You open the drink with an audible pop!</span>")
		flags |= OPENCONTAINER
		verbs += /obj/item/weapon/reagent_containers/food/drinks/proc/gulp_whole
		canopened = 1
	else
		return

/obj/item/weapon/reagent_containers/food/drinks/cans/attack(mob/living/M, mob/user, def_zone)
	if(!CanEat(user, M, src, "drink")) return

	if (!canopened)
		to_chat(user, "<span class='notice'>You need to open the drink!</span>")
		return
	var/datum/reagents/R = src.reagents
	var/fillevel = gulp_size

	if(!R.total_volume || !R)
		to_chat(user, "<span class='warning'>None of [src] left, oh no!</span>")
		return 0

	if(M == user)
		if(isliving(M))
			var/mob/living/L = M
			if(taste)
				L.taste_reagents(src.reagents)
		to_chat(M, "<span class='notice'>You swallow a gulp of [src].</span>")
		if(reagents.total_volume)
			reagents.trans_to_ingest(M, gulp_size)
			reagents.reaction(M, INGEST)
			addtimer(CALLBACK(reagents, /datum/reagents.proc/trans_to, M, gulp_size), 5)

		playsound(M, 'sound/items/drink.ogg', VOL_EFFECTS_MASTER, rand(10, 50))
		return 1
	else if (!canopened)
		to_chat(user, "<span class='notice'> You need to open the drink!</span>")
		return

	else
		M.visible_message("<span class='rose'>[user] attempts to feed [M] [src].</span>", \
						"<span class='warning'><B>[user]</B> attempts to feed you <B>[src]</B>.</span>")
		if(!do_mob(user, M)) return
		M.visible_message("<span class='rose'>[user] feeds [M] [src].</span>", \
						"<span class='warning'><B>[user]</B> feeds you <B>[src]</B>.</span>")

		M.log_combat(user, "fed [name], reagents: [reagentlist(src)] (INTENT: [uppertext(user.a_intent)])")

		if(reagents.total_volume)
			reagents.trans_to_ingest(M, gulp_size)

		if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
			var/mob/living/silicon/robot/bro = user
			bro.cell.use(30)
			var/refill = R.get_master_reagent_id()
			addtimer(CALLBACK(R, /datum/reagents.proc/add_reagent, refill, fillevel), 600)

		playsound(M, 'sound/items/drink.ogg', VOL_EFFECTS_MASTER, rand(10, 50))
		return 1

/obj/item/weapon/reagent_containers/food/drinks/cans/afterattack(atom/target, mob/user, proximity, params)
	if(!proximity) return

	if (!is_open_container())
		to_chat(user, "<span class='notice'>You need to open [src]!</span>")
		return

	if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.
		var/obj/structure/reagent_dispensers/RD = target
		if(!RD.reagents.total_volume)
			to_chat(user, "<span class='warning'>[RD] is empty.</span>")
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, "<span class='warning'>[src] is full.</span>")
			return

		var/trans = RD.reagents.trans_to(src, RD.amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>You fill [src] with [trans] units of the contents of [target].</span>")

	else if(target.is_open_container()) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, "<span class='warning'>[src] is empty.</span>")
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, "<span class='warning'>[target] is full.</span>")
			return

		var/datum/reagent/refill
		var/datum/reagent/refillName
		if(isrobot(user))
			refill = reagents.get_master_reagent_id()
			refillName = reagents.get_master_reagent_name()

		var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>You transfer [trans] units of the solution to [target].</span>")

		if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
			var/mob/living/silicon/robot/bro = user
			var/chargeAmount = max(30,4*trans)
			bro.cell.use(chargeAmount)
			to_chat(user, "Now synthesizing [trans] units of [refillName]...")
			addtimer(CALLBACK(src, .proc/refill_by_borg, user, refill, trans), 300)

	else if((user.a_intent == INTENT_HARM) && reagents.total_volume && istype(target, /turf/simulated))
		to_chat(user, "<span class = 'notice'>You splash the solution onto [target].</span>")
		reagents.standard_splash(target, user=user)

//DRINKS

/obj/item/weapon/reagent_containers/food/drinks/cans/cola
	name = "Space Cola"
	desc = "Cola. in space."
	icon_state = "cola"
	list_reagents = list("cola" = 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle
	name = "Bottled Water"
	desc = "Introduced to the vending machines by Skrellian request, this water comes straight from the Martian poles."
	icon_state = "waterbottle"
	list_reagents = list("water" = 30)

///chem list, minus foods/drinks/base chems/paint and special chems, only for waterbottle/relic
#define RELIC_WATER_CHEM_LIST list(\
	"stoxin2", "inaprovaline", "ryetalyn", "paracetamol", "tramadol", "oxycodone", "sterilizine", "leporazine",\
	"kelotane", "dermaline", "dexalin", "dextromethorphan", "dexalinp", "tricordrazine", "anti_toxin", "thermopsis",\
	"synaptizine", "hyronalin", "arithrazine", "alkysine", "imidazoline", "aurisine", "peridaxon", "kyphotorin",\
	"bicaridine", "hyperzine", "cryoxadone", "clonexadone", "rezadone", "spaceacillin", "ethylredoxrazine",\
	"vitamin", "lipozine", "stimulants", "nanocalcium", "toxin", "amatoxin", "mutagen", "phoron", "lexorin",\
	"slimejelly", "cyanide", "minttoxin", "carpotoxin", "zombiepowder", "mindbreaker", "plantbgone", "stoxin",\
	"chloralhydrate", "potassium_chloride", "potassium_chlorophoride", "beer2", "mutetoxin", "sacid", "pacid",\
	"alphaamanitin", "aflatoxin", "chefspecial", "dioxin", "mulligan", "mutationtoxin", "amutationtoxin", "space_drugs",\
	"serotrotium", "cryptobiolin", "impedrezene", "ectoplasm", "methylphenidate", "methylphenidate", "citalopram",\
	"citalopram", "paroxetine", "paroxetine", "lube", "plasticide", "glycerol", "nitroglycerin",\
	"thermite", "virusfood", "fuel", "cleaner", "xenomicrobes", "fluorosurfactant", "foaming_agent", "nicotine",\
	"ammonia", "glue", "diethylamine", "luminophore","nanites", "nanites2", "nanobots", "mednanobots", "ectoplasm")

/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle/relic
	desc = "A bottle of water filled with unknown liquids. It seems to be radiating some kind of energy."
	list_reagents = list()

/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle/relic/atom_init()
	var/reagents = volume
	while(reagents)
		var/newreagent = rand(1, min(reagents, 30))
		list_reagents += list(pick(RELIC_WATER_CHEM_LIST) = newreagent)
		reagents -= newreagent
	. = ..()

#undef RELIC_WATER_CHEM_LIST

/obj/item/weapon/reagent_containers/food/drinks/cans/space_mountain_wind
	name = "Space Mountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind"
	list_reagents = list("spacemountainwind" = 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/thirteenloko
	name = "Thirteen Loko"
	desc = "The CMO has advised crew members that consumption of Thirteen Loko may result in seizures, blindness, drunkeness, or even death. Please Drink Responsibly."
	icon_state = "thirteen_loko"
	list_reagents = list("thirteenloko" = 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb
	name = "Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors."
	icon_state = "dr_gibb"
	list_reagents = list("dr_gibb" = 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/starkist
	name = "Star-kist"
	desc = "The taste of a star in liquid form. And, a bit of tuna...?"
	icon_state = "starkist"
	list_reagents = list("sodawater" = 15, "orangejuice" = 15)

/obj/item/weapon/reagent_containers/food/drinks/cans/space_up
	name = "Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up"
	list_reagents = list("space_up" = 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/lemon_lime
	name = "Lemon-Lime"
	desc = "You wanted ORANGE. It gave you Lemon Lime."
	icon_state = "lemon-lime"
	list_reagents = list("lemon_lime" = 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/iced_tea
	name = "Vrisk Serket Iced Tea"
	desc = "That sweet, refreshing southern earthy flavor. That's where it's from, right? South Earth?"
	icon_state = "ice_tea_can"
	list_reagents = list("icetea" = 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/grape_juice
	name = "Grapel Juice"
	desc = "500 pages of rules of how to appropriately enter into a combat with this juice!"
	icon_state = "purple_can"
	list_reagents = list("grapejuice" = 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/tonic
	name = "T-Borg's Tonic Water"
	desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."
	icon_state = "tonic"
	list_reagents = list("tonic" = 50)

/obj/item/weapon/reagent_containers/food/drinks/cans/sodawater
	name = "Soda Water"
	desc = "A can of soda water. Still water's more refreshing cousin."
	icon_state = "sodawater"
	list_reagents = list("sodawater" = 50)


/obj/item/weapon/reagent_containers/item_liquid_container/pickles
	name = "Jar"
	desc = "A jar for food preservation"
	icon = 'icons/obj/drinks.dmi'
	icon_state = "jar"
	w_class = SIZE_TINY

	//Liquid_vars
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(10,20,30)
	list_reagents = list("brine" = 90)
	volume = 100

	//Item_vars
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/grown/cucumber/pickled,
					/obj/item/weapon/reagent_containers/food/snacks/grown/tomato/pickled)

	max_w_class = SIZE_TINY //Max size of objects that this object can store (in effect only if can_hold isn't set)
	max_storage_space = null //Total storage cost of items this can hold. Will be autoset based on storage_slots if left null.
	storage_slots = 7 //The number of storage slots in this container.

	use_to_pickup = FALSE	//Set this to make it possible to use this item in an inverse way, so you can have the item in your hand and click items on the floor to pick them up.
	display_contents_with_number = FALSE	//Set this to make the storage item group contents of the same type and display them as a number.
	allow_quick_empty = TRUE	//Set this variable to allow the object to have the 'empty' verb, which dumps all the contents on the floor.
	allow_quick_gather = FALSE	//Set this variable to allow the object to have the 'toggle mode' verb, which quickly collects all items from a tile.
	list/use_sound = null // sound played when used. null for no sound.

	var/items = 0
	var/item = null
	var/item_name = null
	var/image/filling

/obj/item/weapon/reagent_containers/item_liquid_container/pickles/atom_init()
	. = ..()
	if(prob(50))
		item = /obj/item/weapon/reagent_containers/food/snacks/grown/cucumber/pickled
		can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/grown/cucumber/pickled)
		item_name = "pickled cucumber"
	else
		item = /obj/item/weapon/reagent_containers/food/snacks/grown/tomato/pickled
		can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/grown/tomato/pickled)
		item_name = "pickled tomato"
	for(var/i = 1 to rand(1, 7))
		new item(src)
		items += 1
	update_icon()

	verbs += /obj/item/weapon/reagent_containers/item_liquid_container/proc/gulp_whole
	verbs += /obj/item/weapon/reagent_containers/item_liquid_container/pickles/proc/lid

/obj/item/weapon/reagent_containers/item_liquid_container/pickles/examine(mob/user)
	..()
	if(items > 0)
		to_chat(user, "<span class='info'>It contains some [item_name]s.</span>")

/obj/item/weapon/reagent_containers/item_liquid_container/pickles/update_icon()
	cut_overlay("[item_name]_[items + 1]")
	if(items > 0 && items < 8)
		add_overlay("[item_name]_[items]")
	else
		item_name = null
		can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/grown/cucumber/pickled,
						/obj/item/weapon/reagent_containers/food/snacks/grown/tomato/pickled)

	filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")
	cut_overlay(filling)

	if(reagents.total_volume)
		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)		filling.icon_state = "[icon_state]-10"
			if(10 to 24) 	filling.icon_state = "[icon_state]10"
			if(25 to 49)	filling.icon_state = "[icon_state]25"
			if(50 to 74)	filling.icon_state = "[icon_state]50"
			if(75 to 89)	filling.icon_state = "[icon_state]75"
			if(90 to 99)	filling.icon_state = "[icon_state]90"
			if(100 to INFINITY) filling.icon_state = "[icon_state]100"

		filling.icon += mix_color_from_reagents(reagents.reagent_list)
		add_overlay(filling)


/obj/item/weapon/reagent_containers/item_liquid_container/pickles/open(mob/user)
	if (!is_open_container())
		to_chat(user, "<span class='notice'>You need to open [src]!</span>")
		return
	..()

/obj/item/weapon/reagent_containers/item_liquid_container/pickles/handle_item_insertion()
	..()
	items += 1
	update_icon()

/obj/item/weapon/reagent_containers/item_liquid_container/pickles/remove_from_storage()
	items -= 1
	update_icon()
	..()

/obj/item/weapon/reagent_containers/item_liquid_container/pickles/proc/lid()
	set category = "Object"
	set name = "Toggle lid open/closed"
	set src in view(1)

	if (is_open_container())
		to_chat(usr, "<span class = 'notice'>You put the lid on \the [src].</span>")
		flags ^= OPENCONTAINER
	else
		to_chat(usr, "<span class = 'notice'>You take the lid off \the [src].</span>")
		flags |= OPENCONTAINER
