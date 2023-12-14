/obj/machinery/hs/rust_forge
	name = "Rust Forge"
	desc = "Forge nigga"
	icon = 'rust_forge.dmi'
	icon_state = "forge"
	bound_width = 224 //32.7
	bound_height = 64 //32.2
	density = 1
	var/m_amount = 0.0
	var/g_amount = 0.0
	var/operating = 0.0
	var/opened = 0.0
	var/temp = null
	anchored = 1.0
	var/list/L = list()
	var/list/LL = list()

	var/area/input
	var/area/output

	var/list/inputs = list()
	var/list/outputs = list()

	New()
		..()
		special_processing += src
		for(var/area/a in world)
			if(istype(a, /area/alternianShip/Forge/Input/))
				inputs += a
			else if(istype(a, /area/alternianShip/Forge/Output/))
				outputs += a
			else
				continue

	special_process()
		for(var/area/a in inputs)
			for(var/obj/O in a.contents)
				if(istype(O, /obj/item/weapon/sheet/metal))
					spawn(16)
						//flick("molting",src)
						src.m_amount += O:height * O:width * O:length * 10000000.0
						animate(O,alpha = 0, time = 10, easing = ELASTIC_EASING)
						spawn(10) del(O)
						for(var/mob/M in hearers())
							if(M.client)
								M << "\blue The [O] melts! Metal Amount : [m_amount]"
						new /obj/Particle/red_particles(O.loc)
			for(var/mob/m in a.contents)
				var/tmp/turf/t = get_turf(m)
				if(!findtext(t.icon_state,"lava"))
					return
				if(istype(m, /mob/living/carbon/human/))
					for(var/mob/M in hearers())
						if(M.client)
							M << "\blue The [m] melts!"
					new /obj/Particle/red_particles(m.loc)
					m.gib()
		sleep(tick_lag_original)

	attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)
		if (istype(O, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = O
			if (prob(99) && G.affecting)
				G.affecting.gib()
				m_amount += 50000
			return

		if (istype(O, /obj/item/weapon/sheet/metal))
			if (src.m_amount < 150000.0)
				spawn(16)
					//flick("molting",src)
					src.m_amount += O:height * O:width * O:length * 100000.0
					O:amount--
					if (O:amount < 1)
						del(O)
