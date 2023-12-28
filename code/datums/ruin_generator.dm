#define RUIN_SIZE 10

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

/datum/ruin_generator/proc/cache_ruin_areas(z_level, area_type)
	var/list/ruin_areas = list()
	for(var/area/A in world)
		if(istype(A, area_type) && A.z == z_level)
			ruin_areas += A
	return ruin_areas

/datum/ruin_generator/proc/generate_ruins(z_level, ruin_number, area_type)
	var/list/valid_turfs = generate_valid_turfs_list(z_level, area_type)
	while(ruin_number > 0 && valid_turfs.len)
		var/map_path = pick(ruin_maps)

		if(fexists(map_path))
			var/turf/random_turf = pick_n_pop(valid_turfs)
			if(random_turf && is_turf_suitable(random_turf))
				map_loader.load_map(map_path, random_turf.x, random_turf.y, z_level)
				var/list/new_valid_turfs = update_valid_turfs(valid_turfs, random_turf.x, random_turf.y, z_level)
				valid_turfs = new_valid_turfs
				ruin_number--
			else
				continue

/datum/ruin_generator/proc/generate_valid_turfs_list(z_level, area_type)
	var/list/valid_turfs = list()
	for(var/turf/T in world)
		if(T.z == z_level && istype(T.loc, area_type) && is_turf_suitable(T))
			if(!(T in valid_turfs))
				valid_turfs += T
	return valid_turfs

/proc/is_turf_suitable(turf/T)
	for(var/x_offset = 0 to RUIN_SIZE - 1)
		for(var/y_offset = 0 to RUIN_SIZE - 1)
			var/turf/checked_turf = locate(T.x + x_offset, T.y + y_offset, T.z)
			if(checked_turf in occupied_turfs)
				return FALSE
	return TRUE

/datum/ruin_generator/proc/update_valid_turfs(list/valid_turfs, x, y, z)
	for(var/x_offset = 0 to RUIN_SIZE - 1)
		for(var/y_offset = 0 to RUIN_SIZE - 1)
			var/turf/T = locate(x + x_offset, y + y_offset, z)
			occupied_turfs.Add(T)
	return valid_turfs

/proc/pick_n_pop(list/L)
	if(L.len == 0)
		return null
	var/index = rand(1, L.len)
	var/picked = L[index]
	L.Cut(index, index + 1)
	return picked

/world/New()
	. = ..()
	var/datum/ruin_generator/rg = new
	rg.generate_ruins(1, 40, locate(/area/ruin))
	return .


var/global/datum/maploader/map_loader = new()

/datum/maploader
	var/dmm_suite/map_suite = new()

/datum/maploader/proc/load_map(map_path as text, x, y, z)
	var/map_text = file2text(map_path)
	return map_suite.read_map(map_text, x, y, z)