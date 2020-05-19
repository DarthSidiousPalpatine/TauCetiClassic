/obj/item/media/walkmoon
	name = "walkmoon"
	desc = "This is an NT3 player for music."
	icon = 'icons/obj/jukebox.dmi'
	icon_state = "blue_white_walkmoon_item"
	w_class = ITEM_SIZE_SMALL

	var/obj/item/media/walkmoon/headphones
	var/playing = FALSE

	// Playlist to load at startup.
	var/playlist_id = "bar"

	var/list/playlist
	var/current_song  = 0
	var/last_reload   = 0

/obj/item/media/walkmoon/atom_init() // starts without a cell for rnd
	. = ..()
	if(ispath(headphones))
		headphones = new headphones(src, src)
	else
		headphones = new(src, src)
	update_icon()

/obj/item/media/walkmoon/Destroy()
	. = ..()

/obj/item/media/walkmoon/update_icon()
	if(headphones) //in case paddles got destroyed somehow.
		if(headphones.loc == src)
			icon_state = "blue_white_walkmoon_item"
		else
			if (playing)
				icon_state = "blue_white_walkmoon_inv_on"
			else
				icon_state = "blue_white_walkmoon_inv_idle"

/obj/item/media/walkmoon/proc/check_reload()
	return world.time > last_reload + JUKEBOX_RELOAD_COOLDOWN

/obj/item/media/walkmoon/ui_interact(mob/user)
	if(!playlist)
		var/url="[config.media_base_url]/index.php?playlist=[playlist_id]"
		var/response = world.Export(url)
		playlist=list()
		if(response)
			var/json = file2text(response["CONTENT"])
			if("/>" in json)
				visible_message("<span class='warning'>[bicon(src)] \The [src] buzzes, unable to update its playlist.</span>","<em>You hear a buzz.</em>")
				return
			var/json_reader/reader = new()
			reader.tokens = reader.ScanJson(json)
			reader.i = 1
			var/songdata = reader.read_value()
			for(var/list/record in songdata)
				playlist += new /datum/song_info(record)
			if(playlist.len==0)
				visible_message("<span class='warning'>[bicon(src)] \The [src] buzzes, unable to update its playlist.</span>","<em>You hear a buzz.</em>")
				return
			visible_message("<span class='notice'>[bicon(src)] \The [src] beeps, and the menu on its front fills with [playlist.len] items.</span>","<em>You hear a beep.</em>")
		else
			return
	var/t = "<h1>Walkmoon Interface</h1>"

	if(playlist == null)
		t += "\[DOWNLOADING PLAYLIST, PLEASE WAIT\]"
	else
		if(check_reload())
			t += "<b>Playlist:</b> "
		t += "<br />"
		if(current_song && current_song < playlist.len)
			var/datum/song_info/song=playlist[current_song]
			t += "<b>Current song:</b> [song.artist] - [song.title]<br />"
		t += "<table class='prettytable'><tr><th colspan='2'>Artist - Title</th><th>Album</th></tr>"
		var/i
		for(i = 1,i <= playlist.len,i++)
			var/datum/song_info/song=playlist[i]
			t += "<tr><th>#[i]</th><td><A href='?src=\ref[src];song=[i]' class='nobg'>[song.displaytitle()]</A></td><td>[song.album]</td></tr>"
		t += "</table>"

	var/datum/browser/popup = new (user,"jukebox",name,420,700)
	popup.set_content(t)
	popup.open()

/obj/item/media/walkmoon/attack_self(mob/user)

	user.set_machine(src)
	ui_interact(user) //NanoUI requires this proc
	return

/obj/machinery/media/jukebox/Topic(href, href_list)
	. = ..()
	if(!.)
		return

	if (href_list["song"])
		current_song=CLAMP(text2num(href_list["song"]), 1, playlist.len)
		update_music()
		update_icon()

	updateUsrDialog()