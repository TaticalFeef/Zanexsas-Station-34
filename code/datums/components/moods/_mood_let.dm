/datum/moodlet
	var/message = ""
	var/intensity = 0
	var/duration = 0
	var/timestamp = 0

/datum/moodlet/proc/is_expired()
	return (world.time > (timestamp + duration))