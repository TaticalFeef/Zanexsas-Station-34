/area/ruin
	icon = 'ruin_area.dmi'
	name = "ruina misterigoza"

var/global/list/occupied_turfs = list()

/datum/ruin_generator
	var/list/ruin_maps = list()

/datum/ruin_generator/New()
	initialize_ruins()

/datum/ruin_generator/proc/initialize_ruins()
	var/ruin_dir = "maps/ruins/"
	var/list/files = flist(ruin_dir)
	for(var/filename in files)
		if(findtext(filename, ".dmm"))
			ruin_maps += ruin_dir + filename

/datum/ruin_generator/proc/generate_ruins(z_level, ruin_number, area_type)
	while(ruin_number > 0)
		var/map_path = pick(ruin_maps)

		if(fexists(map_path))
			var/turf/random_turf = get_random_turf(z_level, area_type)
			if(random_turf)
				map_loader.load_map(map_path, random_turf.x, random_turf.y, z_level)
				mark_turfs_occupied(random_turf.x, random_turf.y, z_level)

				ruin_number--
			else
				break

/proc/get_random_turf(z_level, area_type)
	var/list/valid_turfs = list()
	for(var/turf/T in world)
		if(T.z == z_level && istype(T.loc, area_type) && is_turf_suitable(T))
			valid_turfs += T
	if(valid_turfs.len)
		return pick(valid_turfs)
	else
		return null

/proc/is_turf_suitable(turf/T)
	for(var/x_offset = 0 to 9)
		for(var/y_offset = 0 to 9)
			var/turf_key = "[T.x + x_offset],[T.y + y_offset],[T.z]"
			if(turf_key in occupied_turfs)
				return FALSE

	return TRUE

/proc/mark_turfs_occupied(x, y, z)
	for(var/x_offset = 0 to 9)
		for(var/y_offset = 0 to 9)
			var/turf_key = "[x + x_offset],[y + y_offset],[z]"
			occupied_turfs += turf_key

/world/New()
	. = ..()
	var/datum/ruin_generator/rg = new
	rg.generate_ruins(1, 10, locate(/area/ruin))
	return .


var/global/datum/maploader/map_loader = new()

/datum/maploader
	var/dmm_suite/map_suite = new()

/datum/maploader/proc/load_map(map_path as text, x, y, z)
	var/map_text = file2text(map_path)
	return map_suite.read_map(map_text, x, y, z)