#define HEARBAR_HEIGHT 28

/datum/hearbar
	var/image/bar
	var/shown = 0
	var/mob/user
	var/client/client
	var/bar_icon_state = "prog_bar"
	var/listindex

	var/style
	var/fontsize = 7

/datum/hearbar/New(mob/User, Text, atom/target, insert_under=TRUE)
	. = ..()
	if (!istype(target))
		EXCEPTION("Invalid target given")

	if(copytext_char(Text, length(Text)) == "!")
		fontsize = 12
		style += "font-weight: bold;"
	style = "font: 'Small Fonts'; -dm-text-outline: 1 black; font-size: [fontsize]px; [style]"

	bar = image(null, target)
	bar.layer = ABOVE_HUD_LAYER
	bar.plane = ABOVE_HUD_PLANE
	bar.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	bar.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	bar.maptext_width = 80
	bar.maptext_height = 64
	bar.maptext_x = -25
	bar.maptext = "<center><span style=\"[style]\">[Text]</span></center>"

	animate(bar, 1, alpha = 255, pixel_y = 16)

	LAZYINITLIST(User.hearbars)
	LAZYINITLIST(User.hearbars[bar.loc])

	var/list/bars = User.hearbars[bar.loc]
	if(insert_under)
		for(var/datum/hearbar/B in bars)
			B.shiftUp()
		bars.Add(src)
		listindex = 1
	else
		bars.Add(src)
		listindex = bars.len

	bar.pixel_y = 32 + (HEARBAR_HEIGHT * (listindex - 1))

	user = User
	if(user)
		client = user.client
		if(client)
			client.images += bar

/datum/hearbar/proc/shiftUp()
	++listindex
	bar.pixel_y += HEARBAR_HEIGHT

/datum/hearbar/proc/shiftDown()
	--listindex
	bar.pixel_y -= HEARBAR_HEIGHT

/datum/hearbar/proc/update()
	//world << "Update [progress] - [goal] - [(progress / goal)] - [((progress / goal) * 100)] - [round(((progress / goal) * 100), 5)]"
	if (!user || !user.client)
		shown = 0
		return
	if (user.client != client)
		if (client)
			client.images -= bar
		if (user.client)
			user.client.images += bar

	if (!shown)
		user.client.images += bar
		shown = 1

/datum/hearbar/Destroy()
	for(var/I in user.hearbars[bar.loc])
		var/datum/hearbar/P = I
		if(P != src && P.listindex > listindex)
			P.shiftDown()

	var/list/bars = user.hearbars[bar.loc]
	bars.Remove(src)
	if(!bars.len)
		LAZYREMOVE(user.hearbars, bar.loc)

	if (client)
		client.images -= bar

	QDEL_NULL(bar)
	. = ..()

#undef HEARBAR_HEIGHT
