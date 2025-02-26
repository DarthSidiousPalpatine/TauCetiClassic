//  Beacon randomly spawns in space
//	When a non-traitor (no special role in /mind) uses it, he is given the choice to become a traitor
//	If he accepts there is a random chance he will be accepted, rejected, or rejected and killed
//	Bringing certain items can help improve the chance to become a traitor


/obj/machinery/syndicate_beacon
	name = "Ominous Beacon"
	desc = "This looks suspicious..."
	icon = 'icons/obj/device.dmi'
	icon_state = "syndbeacon"

	anchored = TRUE
	density = TRUE
	use_power = NO_POWER_USE

	var/temptext = ""
	var/selfdestructing = 0
	var/charges = 1

/obj/machinery/syndicate_beacon/attack_ghost(mob/user) //Not needed, but showing of truncated string is not good
	return

/obj/machinery/syndicate_beacon/ui_interact(mob/user)
	var/dat = "<font color=#005500><i>Scanning [pick("retina pattern", "voice print", "fingerprints", "dna sequence")]...<br>Identity confirmed,<br></i></font>"
	if(ishuman(user) || isAI(user))
		if(is_special_character(user))
			dat += "<font color=#07700><i>Operative record found. Greetings, Agent [user.name].</i></font><br>"
		else if(charges < 1)
			dat += "<TT>Connection severed.</TT><BR>"
		else
			var/honorific = "Mr."
			if(user.gender == FEMALE)
				honorific = "Ms."
			dat += "<font color=red><i>Identity not found in operative database. What can the Syndicate do for you today, [honorific] [user.name]?</i></font><br>"
			if(!selfdestructing)
				dat += "<br><br><A href='byond://?src=\ref[src];betraitor=1;traitormob=\ref[user]'>\"[pick("I want to switch teams.", "I want to work for you.", "Let me join you.", "I can be of use to you.", "You want me working for you, and here's why...", "Give me an objective.", "How's the 401k over at the Syndicate?")]\"</A><BR>"
	dat += temptext

	var/datum/browser/popup = new(user, "window=syndbeacon", src.name)
	popup.set_content(dat)
	popup.open()

/obj/machinery/syndicate_beacon/is_operational()
	return TRUE

/obj/machinery/syndicate_beacon/Topic(href, href_list)
	. = ..()
	if(!.)
		return

	if(href_list["betraitor"])
		if(charges < 1)
			updateUsrDialog()
			return
		var/mob/M = locate(href_list["traitormob"])
		if(M.mind.special_role)
			temptext = "<i>We have no need for you at this time. Have a pleasant day.</i><br>"
			updateUsrDialog()
			return
		charges -= 1
		if(prob(50))
			temptext = "<font color=red><i><b>Double-crosser. You planned to betray us from the start. Allow us to repay the favor in kind.</b></i></font>"
			updateUsrDialog()
			spawn(rand(50,200))
				selfdestruct()
			return
		if(ishuman(M))
			var/mob/living/carbon/human/N = M
			var/datum/role/traitor/wishgranter/T = create_and_setup_role(/datum/role/traitor/syndbeacon, N)
			T.Greet(GREET_SYNDBEACON)

	updateUsrDialog()


/obj/machinery/syndicate_beacon/proc/selfdestruct()
	selfdestructing = 1
	var/power = rand(1, 3)
	spawn() explosion(src.loc, 0, power, power*3)



#define SCREWED 32

/obj/machinery/singularity_beacon //not the best place for it but it's a hack job anyway -- Urist
	name = "ominous beacon"
	desc = "This looks suspicious..."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "beacon"
	anchored = FALSE
	density = TRUE
	layer = MOB_LAYER - 0.1 //so people can't hide it and it's REALLY OBVIOUS
	stat = 0
	use_power = NO_POWER_USE

	var/active = 0 //It doesn't use up power, so use_power wouldn't really suit it
	var/icontype = "beacon"
	var/obj/structure/cable/attached = null


/obj/machinery/singularity_beacon/proc/Activate(mob/user = null)
	if(!checkWirePower())
		if(user)
			to_chat(user, "<span class='notice'>The connected wire doesn't have enough current.</span>")
		return 1
	for(var/obj/singularity/singulo in poi_list)
		if(singulo.z == z)
			singulo.target = src
	icon_state = "[icontype]1"
	active = 1
	if(user)
		to_chat(user, "<span class='notice'>You activate the beacon.</span>")


/obj/machinery/singularity_beacon/proc/Deactivate(mob/user = null)
	for(var/obj/singularity/singulo in poi_list)
		if(singulo.target == src)
			singulo.target = null
	icon_state = "[icontype]0"
	active = 0
	if(user)
		to_chat(user, "<span class='notice'>You deactivate the beacon.</span>")


/obj/machinery/singularity_beacon/attack_ai(mob/user)
	if(IsAdminGhost(user))
		return ..()

/obj/machinery/singularity_beacon/attack_hand(mob/user)
	. = ..()
	if(.)
		return 1
	user.SetNextMove(CLICK_CD_INTERACT)
	if(stat & SCREWED)
		return active ? Deactivate(user) : Activate(user)
	else
		to_chat(user, "<span class='warning'>You need to screw the beacon to the floor first!</span>")
		return 1


/obj/machinery/singularity_beacon/attackby(obj/item/weapon/W, mob/user)
	if(isscrewing(W))
		if(active)
			to_chat(user, "<span class='warning'>You need to deactivate the beacon first!</span>")
			return

		if(stat & SCREWED)
			stat &= ~SCREWED
			anchored = FALSE
			to_chat(user, "<span class='notice'>You unscrew the beacon from the floor.</span>")
			attached = null
			return
		else
			var/turf/T = loc
			if(isturf(T) && T.underfloor_accessibility >= UNDERFLOOR_INTERACTABLE)
				attached = locate() in T
			if(!attached)
				to_chat(user, "This device must be placed over an exposed cable.")
				return
			stat |= SCREWED
			anchored = TRUE
			to_chat(user, "<span class='notice'>You screw the beacon to the floor and attach the cable.</span>")
			return
	..()
	return


/obj/machinery/singularity_beacon/Destroy()
	if(active)
		Deactivate()
	return ..()

	/*
	* Added for a simple way to check power. Verifies that the beacon
	* is connected to a wire, the wire is part of a powernet (that part's
	* sort of redundant, since all wires either join or create one when placed)
	* and that the powernet has at least 1500 power units available for use.
	* Doesn't use them, though, just makes sure they're there.
	* - QualityVan, Aug 11 2012
	*/
/obj/machinery/singularity_beacon/proc/checkWirePower()
	if(!attached)
		return 0
	var/datum/powernet/PN = attached.get_powernet()
	if(!PN)
		return 0
	if(PN.avail < 1500)
		return 0
	return 1

/obj/machinery/singularity_beacon/process()
	if(!active)
		return
	else
		if(!checkWirePower())
			Deactivate()
	return


/obj/machinery/singularity_beacon/syndicate
	icontype = "beaconsynd"
	icon_state = "beaconsynd0"

#undef SCREWED
