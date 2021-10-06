/obj/structure/ageing_shelf
    name = "ageing shelf"
	desc = "Its a small wooden shelf for pickle jars."
	icon = 'icons/obj/cond_shelf.dmi'
	icon_state = "age_shelf"
	anchored = TRUE
	density = FALSE
	opacity = FALSE

    max_items_inside = 6
    list/can_be_placed = list(/obj/item/weapon/reagent_containers/item_liquid_container/jar)

    var/jars
    var/list/jar_coords = list(5,3, 13,3, 21,3,  5,13, 13,13, 21,13)
    var/image/jar

/obj/structure/ageing_shelf/atom_init()
    . = ..()
    jar = image('icons/obj/cond_shelf.dmi', icon_state = "jar")

/obj/structure/ageing_shelf/update_icon()
    cut_overlays()
    if(jars > 0 && jars < 7)
      for(var/i = 1 to jars)
         var/image/holder = jar
          holder.pixel_x(list[2 * i - 1])
          holder.pixel_y(list[2 * i])
         add_overlay(holder)

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