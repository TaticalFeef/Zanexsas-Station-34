/mob/living/carbon/enemy/hs/rustFollower
	name = "Rust Follower"
	desc = "RUN BOI"
	icon_state = "droid"
	density = 0
	maxhealth = 10
	heightSize = 32
	var/mob/living/carbon/human/owner
	var/acting = FALSE
	var/cooldown = 0
	var/nearest_dist = 5
	var/mob/living/nearest_mob = null
	var/spread = 0.1

/mob/living/carbon/enemy/hs/rustFollower/New(loc, var/mob/living/carbon/human/_owner)
	. = ..()
	owner = _owner
	if(loc)
		src.loc = loc
	sleep()
	density = 1

/mob/living/carbon/enemy/hs/rustFollower/ex_act()
	return

/mob/living/carbon/enemy/hs/rustFollower/EnemyProcess()
	if(frm_counter % 5 == 3 && src.alpha > 0)
		var/alpha_decrement = 150 / 40
		src.alpha = max(0, src.alpha - alpha_decrement)

	if(cooldown < world.time)
		if(!owner)
			if(prob(70)) step_rand(src)
		else if(!acting)
			findTargets()
		cooldown = world.time + 10
		if(prob(10)) speakAss(pick("really cool kanye","FODA-SE"))

	if(src.alpha <= 0)
		new /obj/Particle/skull (src.loc)
		zDel(src)

/mob/living/carbon/enemy/hs/rustFollower/proc/speakAss(ass)
	src << text("\blue You said [].", ass)
	for(var/mob/O in oviewers())
		if ((O.client && !( O.blinded )))
			O << text("\red [] says \"[]\".", usr.name,ass)

/mob/living/carbon/enemy/hs/rustFollower/proc/Shoot()
	acting = TRUE
	if(nearest_mob)
		new /obj/Particle/skull (nearest_mob.loc)
		speakAss("Shooting [nearest_mob.name]")
		for(var/i in 1 to 5)
			var/angle = get_angle(src, nearest_mob)
			var/obj/projectile/hs/spine/G = new(locate(x,y,z))
			G.owner = src
			G.X_SPEED = cos(angle) * 9
			G.Y_SPEED = -sin(angle) * 9 //me matar
		sleep(10)
	acting = FALSE

/mob/living/carbon/enemy/hs/rustFollower/proc/findTargets()
	acting = TRUE
	nearest_mob = null
	nearest_dist = 5

	for(var/mob/i in oviewers(5, src))
		if(i != owner && i != src && istype(i,/mob/living))
			var/dist = GetDist(src, i)
			if(dist < nearest_dist)
				nearest_mob = i
				nearest_dist = dist

	if(nearest_mob)
		if(prob(1))
			src.loc = nearest_mob.loc
		else
			walk_towards(src, nearest_mob, 0.5, 0)
			while(GetDist(src, nearest_mob) > 1 && nearest_mob)
				sleep(1)
			if(GetDist(src, nearest_mob) <= 1)
				Shoot()
	else
		step_rand(src)

	acting = FALSE