datum
	alternians
		purple
			var/tmp/mob/living/carbon/target
			var/nearest_dist = 20
			var/_cooldown = 0
			verb/searchEnemy()
				set name = "Enrage"
				set category = "Alternian"
				if(usr.key == "Roberto_candi")
					explosion(usr.loc, 0, 0, 5, 1,10)
					return
				for(var/mob/living/carbon/i in Mobs)
					if(i != usr && !target && i.health >= 0)
						var/dist = GetDist(usr,i)
						usr.say(pick("sniff","snif snif","SniF","SNIF SNIFF"))
						if(get_dist(i,usr) <= 1)
							target = i
						else if(dist < nearest_dist && !target)
							target = i
						else
							continue
				if(target && _cooldown < world.time && target in trange(1,usr) && target.health >= 0) //testando
					new /obj/Particle/rage(usr.loc)
					new /obj/Particle/crosshair(target.loc)
					usr << "\red You fell an unstoppable rage towards [target.name]!"
					usr.say(pick("HonNK!","honk!","honkhonk","Honk!","HonBOLSONARO2018honk"))
					for(var/mob/M in hearers())
						if(M.client)
							if(M != usr)
								M << "\red [usr.name] dashs furiously towards [target.name]!"
							M << sound('bikehorn.ogg')
					while(get_dist(target,usr) < nearest_dist && get_dist(target,usr) > 1 && !usr.stat)
						usr.density = 0
						spawn(1) usr.Dash_Effect(usr.loc)
						walk_towards(usr,target,0.5,0)
						if(get_dist(target,usr) <= 1 || get_dist(target,usr) >= nearest_dist)
							break
						spawn(tick_lag_original * 50) break
						sleep(tick_lag_original)
					spawn(3) usr.density = 1
					_cooldown = world.time + 90
					if(get_dist(src,target) <= 1)
						explosion(target.loc, 0, 0, 1, 1,1)
						usr.say(pick("HOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOONK!","Honk hOnk...","honk HON---K","HONKHONKHONK"))
						var/datum/effects/system/harmless_smoke_spread/SM = new(target.loc)
						SM.attach(target)
						SM.set_up(10, 0, target.loc)
						playsound(target.loc, 'smoke.ogg', 50, 1, -3)
						spawn(0)
							SM.start()
						target = null
						return
				else
					usr << "\blue You can't use this action right now!"

			verb/ShowSkillTree()
				set name = "Skill Tree"
				set category = "Alternian"
				winshow(usr, "purpleskilltree", winget(usr, "purpleskilltree", "is-visible") != "true")