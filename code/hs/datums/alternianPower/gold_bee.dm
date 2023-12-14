/mob/living/carbon/bee
	var/attacking = FALSE
	var/mob/living/target

	proc/startAttack(mob/living/t)
		attacking = TRUE
		target = t

	proc/performAttack()
		if(!target || !attacking)
			return

		walk_to(src, target, 1, 2)
		new /obj/Particle/crosshair(target.loc)
		while(attacking && get_dist(src, target) > 1)
			sleep(1)
			spawn(tick_lag_original)
				spawn(1) src.Dash_Effect(src.loc)
			if(get_dist(src, target) <= 1)
				target.TakeBruteDamage(10)
				for(var/mob/M in hearers())
					if(M.client)
						if(M != src)
							M << "\red [src.name] stings [target.name]!"
						M << sound('sound/items/Crowbar.ogg')
				attacking = FALSE

		attacking = FALSE
		walk_to(src, null)

	Life()
		..()
		if(attacking)
			performAttack()