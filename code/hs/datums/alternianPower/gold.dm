datum/alternians/gold
	var/max_dist = 30
	var/max_bees = 3
	var/clock/timer
	var/checking = FALSE
	var/recalled = FALSE
	var/list/bees = list()

	New()
		..()
		timer = new /clock

datum/alternians/gold/verb/spawnBees()
	set name = "Beemance"
	set category = "Alternian"
	if(bees.len >= max_bees)
		usr << "<span class='notice'>You can't spawn more bees!</span>"
		return

	var/mob/living/carbon/bee/b = new(owner.loc)
	b.owner = owner
	bees += b
	spawn(1) new /obj/Particle/honeypot(b.loc)

datum/alternians/gold/verb/commandBees()
	set name = "Command Bees"
	set category = "Alternian"
	if(bees.len <= 0)
		usr << "<span class='notice'>You have no bees!</span>"
		return

	var/choice = input("Select an action for your bees:", "Bee Command") as null|anything in list("Recall", "Attack")
	if(!choice) return

	switch(choice)
		if("Recall")
			recallBees()
		if("Attack")
			var/mob/living/t = input("Choose your target") as mob in view(owner)
			if(t)
				for(var/mob/living/carbon/bee/b in bees)
					if(b.owner == owner)
						b.startAttack(t)
		//	break
		// Implement bee attack behavior
		//if("Defend")
		//	break
		// Implement bee defend behavior
		//if("Scout")
		// Implement bee scout behavior
		// Add more cases as needed

datum/alternians/gold/proc/recallBees()
	for(var/mob/living/carbon/bee/b in bees)
		if(b.owner == owner)
			new /obj/Particle/honeypot(b.loc)
			b.recalling = TRUE
	//checkBees()

datum/alternians/gold/proc/checkBees()
	if(checking || bees.len <= 0)
		return

	checking = TRUE
	timer.Start()
	while(bees.len > 0 && timer.seconds <= 20)
		sleep(10)
		for(var/mob/living/carbon/bee/b in bees)
			if(b.owner != owner || !b)
				bees -= b
				if(b) zDel(b)
	checking = FALSE
	timer.Reset()
	timer.Stop()

datum/alternians/gold/proc/removeBee(mob/living/carbon/bee/bee)
	if(bee in bees)
		bees -= bee
		zDel(bee)

/obj/machinery/power/goldEnergy/
	icon = 'icons/hs/hs_structures.dmi'
	icon_state = "voidsucc"
	var/sgen = 4000
	density = 0
	New()
		special_processing += src
		..()

	special_process()
		sgen *= rand(1,4)
		add_avail(sgen)

datum/alternians/goldEnergy
	parent_type = /obj/machinery/power
	icon = 'hs_structures.dmi'
	icon_state = "voidsucc"
	var/sgen = 4000
	density = 0

datum/alternians/goldEnergy/New(_owner)
	special_processing += src
	..(_owner)

datum/alternians/goldEnergy/special_process()
	sgen *= rand(1,4)
	add_avail(sgen)