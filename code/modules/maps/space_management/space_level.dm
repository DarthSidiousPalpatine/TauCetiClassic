/datum/space_level
	var/name = "NAME MISSING"
	var/list/traits
	var/z_value = 1 //actual z placement
	var/linkage = SELFLOOPING
	var/list/data_trees = list()

/datum/space_level/New(new_z, new_name, list/new_traits = list())
	z_value = new_z
	name = new_name
	traits = new_traits
	linkage = new_traits[ZTRAIT_LINKAGE]
