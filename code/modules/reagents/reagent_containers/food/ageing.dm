/obj/structure/ageing_shelf
    name = "ageing shelf"
    desc = "Its a small wooden shelf for pickle jars."
    icon = 'icons/obj/cond_shelf.dmi'
    icon_state = "age_shelf"
    anchored = TRUE
    density = FALSE
    opacity = FALSE
    dir = SOUTH

    var/list/can_be_placed = list(/obj/item/weapon/reagent_containers/item_liquid_container/jar)

    var/max_items_inside = 6
    var/jars
    var/list/jar_coords = list(5,3, 13,3, 21,3,  5,16, 13,16, 21,16)
    var/image/jar
    var/list/previous_contents = list()
    var/memory_saved = FALSE
    var/list/name_to_type = list("tomato" = /obj/item/weapon/reagent_containers/food/snacks/grown/tomato, "cucumber" = /obj/item/weapon/reagent_containers/food/snacks/grown/cucumber)

/obj/structure/ageing_shelf/atom_init()
	. = ..()
	jar = image('icons/obj/cond_shelf.dmi', icon_state = "jar")
	Read_Memory()
	for(var/i in previous_contents)
		var/obj/item/weapon/reagent_containers/item_liquid_container/jar/can = new /obj/item/weapon/reagent_containers/item_liquid_container/jar()
		for(1 to rand(1,4))
			var/food = new name_to_type[i]()
			can.handle_item_insertion(food)
		contents += can
		jars += 1
	update_icon()
	START_PROCESSING(SSobj, src)

/obj/structure/ageing_shelf/update_icon()
    cut_overlays()
    if(jars > 0 && jars < 7)
        for(var/i = 1 to jars)
            var/image/holder = jar
            switch(dir)
                if(NORTH)
                    holder.pixel_x = -jar_coords[2 * i - 1]
                    holder.pixel_y = -jar_coords[2 * i]
                if(SOUTH)
                    holder.pixel_x = jar_coords[2 * i - 1]
                    holder.pixel_y = jar_coords[2 * i]
                if(EAST)
                    holder.pixel_y = jar_coords[2 * i - 1]
                    holder.pixel_x = -jar_coords[2 * i]
                if(WEST)
                    holder.pixel_y = -jar_coords[2 * i - 1]
                    holder.pixel_x = jar_coords[2 * i]
            add_overlay(holder)

/obj/structure/ageing_shelf/process()
    if(SSticker.current_state == GAME_STATE_FINISHED && !memory_saved)
        Write_Memory()
        STOP_PROCESSING(SSobj, src)

/obj/structure/ageing_shelf/attackby(obj/O, mob/user)
	if(istype(O, /obj/item/weapon/reagent_containers/item_liquid_container/jar) && do_after(user, 15, TRUE, src, FALSE, TRUE))
		user.drop_from_inventory(O, src)
		visible_message("<span class='notice'>[user] put a jar to \the [src]</span>")
		jars += 1
		update_icon()

/obj/structure/ageing_shelf/attack_hand(mob/user)
	if(jars && do_after(user, 15, TRUE, src, FALSE, TRUE))
		user.put_in_hands(pick(contents))
		visible_message("<span class='notice'>[user] picked a jar from \the [src]</span>")
		jars -= 1
		update_icon()

/obj/structure/ageing_shelf/proc/Read_Memory()
    var/savefile/S = new /savefile("data/obj_saves/Ageing.sav")
    S["contents"] 			>> previous_contents

    if(isnull(previous_contents))
        previous_contents = list("cucumber", "tomato", "cucumber")

/obj/structure/ageing_shelf/proc/Write_Memory()
	var/savefile/S = new /savefile("data/obj_saves/Ageing.sav")
	var/list/contents_names = list()
	for(var/obj/item/weapon/reagent_containers/food/snacks/grown/Food in contents)
		contents_names += Food.name
	S["contents"] 			<< contents_names
	memory_saved = TRUE
