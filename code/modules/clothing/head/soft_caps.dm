/obj/item/clothing/head/soft
	name = "cargo cap"
	desc = "It's a baseball hat in a tasteless yellow color."
	icon_state = "redsoft"
	flags = HEADCOVERSEYES
	siemens_coefficient = 0.9
	body_parts_covered = 0

	dyed_type = DYED_SOFTCAP

	action_button_name = "Flip Cap"

	var/flipped = FALSE
	var/cap_color = "cargo"

	var/hue = 309
	var/brightness = 0.01
	var/saturation = 0.82

/obj/item/clothing/head/soft/atom_init()
	. = ..()
	color = transform_color(hue,saturation,brightness)

/obj/item/clothing/head/soft/wash_act(w_color)
	. = ..()
	var/obj/item/clothing/dye_type = get_dye_type(w_color)
	if(!dye_type)
		return

	var/obj/item/clothing/head/soft/S = dye_type

	cap_color = initial(S.cap_color)
	icon_state = "[cap_color][flipped ? "soft_flipped" : "soft"]"

/obj/item/clothing/head/soft/attack_self(mob/living/carbon/human/user)
	flipped = !flipped
	if(flipped)
		icon_state = "redsoft_flipped"
		to_chat(user, "You flip the hat backwards.")
	else
		icon_state = "redsoft"
		to_chat(user, "You flip the hat back in normal position.")

	update_inv_mob()

/obj/item/clothing/head/soft/red
	name = "red cap"
	desc = "It's a baseball hat in a tasteless red color."
	cap_color = "red"
	hue = 3
	brightness = 0.05
	saturation = 0.80

/obj/item/clothing/head/soft/blue
	name = "blue cap"
	desc = "It's a baseball hat in a tasteless blue color."
	cap_color = "blue"
	hue = 131
	brightness = 0.01
	saturation = 0.82

/obj/item/clothing/head/soft/green
	name = "green cap"
	desc = "It's a baseball hat in a tasteless green color."
	cap_color = "green"
	hue = 225
	brightness = 0.01
	saturation = 0.82

/obj/item/clothing/head/soft/yellow
	name = "yellow cap"
	desc = "It's a baseball hat in a tasteless yellow color."
	cap_color = "yellow"
	hue = 323
	brightness = 0.17
	saturation = 0.96

/obj/item/clothing/head/soft/grey
	name = "grey cap"
	desc = "It's a baseball hat in a tasteful grey color."
	cap_color = "grey"
	hue = 360
	brightness = 0.06
	saturation = 0.0

/obj/item/clothing/head/soft/orange
	name = "orange cap"
	desc = "It's a baseball hat in a tasteless orange color."
	cap_color = "orange"
	hue = 336
	brightness = 0.01
	saturation = 0.82

/obj/item/clothing/head/soft/mime
	name = "white cap"
	desc = "It's a baseball hat in a tasteless white color."
	cap_color = "mime"
	hue = 360
	brightness = 0.66
	saturation = 0.0

/obj/item/clothing/head/soft/purple
	name = "purple cap"
	desc = "It's a baseball hat in a tasteless purple color."
	cap_color = "purple"
	hue = 87
	brightness = 0.05
	saturation = 0.57

/obj/item/clothing/head/soft/rainbow
	name = "rainbow cap"
	desc = "It's a baseball hat in a bright rainbow of colors."
	icon_state = "rainbowsoft"
	cap_color = "rainbow"

/obj/item/clothing/head/soft/sec
	name = "security cap"
	desc = "It's baseball hat in tasteful red color."
	icon_state = "secsoft"
	cap_color = "sec"

/obj/item/clothing/head/soft/sec/corp
	name = "corporate security cap"
	desc = "It's baseball hat in corporate colors."
	icon_state = "corpsoft"
	cap_color = "corp"

/obj/item/clothing/head/soft/trash
	name = "trash cap"
	desc = "It's baseball hat."
	icon_state = "trashsoft"
	cap_color = "trash"

/obj/item/clothing/head/soft/janitor
	name = "janitor cap"
	desc = "It's janitor hat."
	icon_state = "janitorsoft"
	cap_color = "janitor"

/obj/item/clothing/head/soft/nt_pmc_cap
	name = "NT PMC Cap"
	desc = "Dark cap used by the private security corporation. This one looks good."
	icon_state = "nt_pmcsoft"
	item_state = "necromancer"
	cap_color = "nt_pmc"

/obj/item/clothing/head/soft/paramed
	name = "first responder cap"
	desc = "It's first responder hat. Shows who's saving lives here."
	icon_state = "frsoft"
	cap_color = "fr"
