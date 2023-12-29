/datum/controller/subsystem/mobs
    var/list/mobs_list = list()

/datum/controller/subsystem/mobs/proc/process_mobs()
	for(var/mob/M in mobs_list)
		if(!M)
			continue
		CHECK_TICK()
		M.Life()

/datum/controller/subsystem/mobs/proc/add_mob(mob/M)
	if(istype(M))
		mobs_list += M

/datum/controller/subsystem/mobs/proc/remove_mob(mob/M)
	if(M in mobs_list)
		mobs_list -= M

/mob/New()
	. = ..()
	if(master_controller && master_controller.mobs_subsystem)
		var/datum/controller/subsystem/mobs/mob_ss = master_controller.mobs_subsystem
		mob_ss.add_mob(src)

/mob/Destroyed()
	if(master_controller && master_controller.mobs_subsystem)
		var/datum/controller/subsystem/mobs/mob_ss = master_controller.mobs_subsystem
		mob_ss.remove_mob(src)
	. = ..()
