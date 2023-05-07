/obj/structure/largecrate
	name = "large crate"
	desc = "A hefty wooden crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "densecrate"
	density = TRUE

/obj/structure/largecrate/attack_hand(mob/user)
	to_chat(user, "<span class='notice'>You need a crowbar to pry this open!</span>")
	return

/obj/structure/largecrate/attackby(obj/item/weapon/W, mob/user)
	if(isprying(W))
		new /obj/item/stack/sheet/wood(src)
		var/turf/T = get_turf(src)
		for(var/atom/movable/M in contents)
			M.forceMove(T)
		user.visible_message("<span class='notice'>[user] pries \the [src] open.</span>", \
							 "<span class='notice'>You pry open \the [src].</span>", \
							 "<span class='notice'>You hear splitting wood.</span>")
		qdel(src)
	else
		return attack_hand(user)

/obj/structure/largecrate/mule
	icon_state = "mulecrate"

/obj/structure/largecrate/generate_rentgene(size = 96)
	var/icon/rentgene = ..(size = size)

	var/inside_item_size = size
	var/inside_item_offset = round((size - inside_item_size) * 0.5)

	var/inside_mob_size = round(inside_item_size * 1.5)
	var/inside_mob_offset = round((size - inside_mob_size) * 0.5)

	for(var/atom/A in contents)
		if(ismob(A))
			var/icon/ItemIcon = A.generate_rentgene(size = inside_mob_size)
			rentgene.Blend(ItemIcon, ICON_OVERLAY, inside_mob_offset, inside_mob_offset/4)
		else
			var/icon/ItemIcon = A.generate_rentgene(size = inside_item_size)
			rentgene.Blend(ItemIcon, ICON_OVERLAY, inside_item_offset, rand(0, inside_item_size))
	return rentgene
