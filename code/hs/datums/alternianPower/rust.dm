datum
	alternians
		rust
			var/_cooldown = 0
			var/cdmsg = "Necromancy is in cooldown blacko."
			verb
				beUseless()
					set name = "Kill your fucking self"
					set category = "Alternian"

					new /obj/Particle/skull(usr.loc)
					new /obj/Particle/red_particles(src.loc)
					spawn(5) usr:gib()

				necromancy()
					set name = "Necromancy"
					set category = "Alternian"

					if(_cooldown < world.time)
						new /obj/Particle/skull(usr.loc)
						var/mob/living/carbon/enemy/hs/rustFollower/r = new(src.loc,src)
						while(r.health > 0)
							_cooldown = world.time + 1
							cdmsg = "The nigra is still alive."
							usr.loc = r.loc
							sleep(tick_lag_original)
						_cooldown = world.time + rand(10,90)
					else
						usr << "[cdmsg]"