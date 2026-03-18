SUBSYSTEM_DEF(cargo_access)
	name = "Cargo Access"
	init_order = SS_INIT_DEFAULT
	flags = SS_NO_INIT | SS_NO_FIRE

	var/basic_access = access_cargo
	var/head_access = access_qm
	var/additional_accesses = list(access_cargoshop, access_mining, access_mining_station, access_mailsorting, access_recycler)

	var/records = list()

/datum/controller/subsystem/cargo_access/proc/has_basic_access(list/access)
	for(var/access_num in access)
		if(access_num == basic_access)
			return TRUE

	return FALSE

/datum/controller/subsystem/cargo_access/proc/get_account_access(account_number, list/access)
	if(!has_basic_access(access))
		return access

	var/datum/data/record/record = records[account_number]
	if(!record)
		return access

	var/list/additional_access = list()
	additional_access |= record.fields["additional_access"]
	if(is_elected_head(account_number))
		additional_access |= head_access

	return  access |= additional_access

/datum/controller/subsystem/cargo_access/proc/add_account_record(account_number, list/access)
	if(!has_basic_access(access))
		return

	var/datum/data/record/record = records[account_number]
	if(record)
		return

	var/datum/data/record/new_record = new()
	new_record.fields["account_number"] = account_number
	new_record.fields["vote_for"] = null
	new_record.fields["additional_access"] = list()

	for(var/access_num in access)
		if(access_num == head_access)
			new_record.fields["additional_access"] |= additional_accesses
			break

	records[account_number] = new_record

/datum/controller/subsystem/cargo_access/proc/toggle_vote(voter_account_number, elected_account_number)
	var/datum/data/record/voter_record = records[voter_account_number]
	if(!voter_record)
		return

	var/datum/data/record/elected_record = records[elected_account_number]
	if(!elected_record)
		return

	voter_record.fields["vote_for"] = voter_record.fields["vote_for"] == elected_record ? null : elected_record

/datum/controller/subsystem/cargo_access/proc/is_elected_head(account_number)
	var/datum/data/record/record = records[account_number]
	if(!record)
		return FALSE

	var/list/account_number_to_vote = list()

	for(var/datum/record/check_record in records)
		var/datum/record/voted_for = check_record.fields["vote_for"]
		if(!voted_for)
			continue

		if(account_number_to_vote[voted_for.fields["account_number"]])
			account_number_to_vote[voted_for.fields["account_number"]]++
		else
			account_number_to_vote[voted_for.fields["account_number"]] = 1

	var/elected_account_number = null
	for(var/acc_num in account_number_to_vote)
		if(!elected_account_number)
			elected_account_number = acc_num
			continue

		if(account_number_to_vote[elected_account_number] < account_number_to_vote[acc_num])
			elected_account_number = acc_num

	return elected_account_number == account_number
