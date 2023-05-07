/mob/living/carbon/human/is_busy(atom/target, show_warning = TRUE)
	if(busy_with_action)
		if(HAS_TRAIT(src, TRAIT_MULTITASKING))
			if(busy_left_hand && busy_right_hand)
				if(show_warning)
					to_chat(src, "<span class='warning'>You are busy. Please finish or cancel your current action.</span>")
				return TRUE

			if(hand)
				if(busy_left_hand)
					if(show_warning)
						to_chat(src, "<span class='warning'>Your left hand is busy. Please finish or cancel your current action, or try the other hand.</span>")
					return TRUE
			else
				if(busy_right_hand)
					if(show_warning)
						to_chat(src, "<span class='warning'>Your right hand is busy. Please finish or cancel your current action, or try the other hand.</span>")
					return TRUE
		else
			if(show_warning)
				to_chat(src, "<span class='warning'>You are busy. Please finish or cancel your current action.</span>")
			return TRUE
	if(target && target.in_use_action)
		if(show_warning)
			to_chat(src, "<span class='warning'>Please wait while someone else will finish interacting with [target].</span>")
		return TRUE
	return FALSE

/mob/living/carbon/human/become_busy(_hand = 0) // 0 is right hand, don't question it we don't have defines for this yet.
	if(_hand)
		busy_left_hand = TRUE
	else
		busy_right_hand = TRUE
	busy_with_action = TRUE

/mob/living/carbon/human/become_not_busy(_hand = 0) // See remark above.
	if(_hand)
		busy_left_hand = FALSE
	else
		busy_right_hand = FALSE
	if(!busy_left_hand && !busy_right_hand)
		busy_with_action = FALSE

/mob/living/carbon/human/generate_rentgene(size = 96)
	var/icon/rentgene
	for(var/obj/item/organ/external/Bodypart in bodyparts)
		var/rentgene_state = 0
		if(Bodypart.is_stump)
			rentgene_state = 2
		else if(Bodypart.is_broken())
			rentgene_state = 1
		if(Bodypart.burn_dam < 100)
			rentgene.Blend(icon('icons/obj/rentgene.dmi', "[species.name]_[Bodypart.name]_skin_[rentgene_state]"), ICON_OVERLAY, 1, 1)
		rentgene.Blend(icon('icons/obj/rentgene.dmi', "[species.name]_[Bodypart.name]_bone_[rentgene_state]"), ICON_OVERLAY, 1, 1)
	return rentgene
