/mob/living/carbon/bee
	name = "bee"
	desc = "These look really big. Are they even bees?"
	voice_name = "bee"
	voice_message = "buzzes"
	icon = 'bee.dmi'
	icon_state = "petbee-wings"
	heightSize = 14
	var/l_delay = 0
	var/nice = 0
	var/s = 0
	var/mob/owner
	var/recalling = FALSE
	gender = NEUTER
	New()
		..()
		nice = nice + rand(0,90)
	ProcessHeight()
		nice = nice + 2
		s = 16+(sin(nice)*4)
		heightZ = ((((s) - heightZ)/8) + heightZ)

		ySpeed = 0
		..()
/mob/living/carbon/bee/Life()
	if(world.time < l_delay)
		return

	if(!client && recalling == TRUE && owner)
		density = 0
		walk_towards(src, owner, 0.5, 0)
		addtimer(CALLBACK(src, .proc/checkRecall), tick_lag_original * 100)
	else if(!recalling)
		step_rand(src)
		l_delay = world.time + rand(5, 7)

/mob/living/carbon/bee/proc/checkRecall()
	if(get_dist(owner, src) <= 1)
		density = 1
		// mandar o gold nigga recolher a abelha
		if(owner && recalling)
			for(var/datum/alternians/gold/gold_datum in owner.contents)
				gold_datum.removeBee(src)
			recalling = FALSE
	else
		recalling = FALSE

/mob/living/carbon/bee/Destroyed()
	..()
	new /obj/Particle/honeypot(src.loc)
	src.loc = null
	owner = null