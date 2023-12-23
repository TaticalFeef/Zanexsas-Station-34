/obj/machinery/hs/rust_forge
	name = "Rust Forge"
	desc = "Forge for smelting and crafting."
	icon = 'rust_forge.dmi'
	icon_state = "forge"
	bound_width = 224
	bound_height = 64
	density = TRUE
	anchored = TRUE
	var/area/input
	var/m_amount = 0
	var/g_amount = 0
	var/operating = FALSE
	var/opened = FALSE
	var/temp = null
	var/list/possible_crafts = list("I1", "I2")

/obj/machinery/hs/rust_forge/New()
	..()
	special_processing += src
	locateInputArea()

/obj/machinery/hs/rust_forge/proc/locateInputArea()
	input = locate("forge_input")

/obj/machinery/hs/rust_forge/special_process()
	if(input)
		for(var/obj/item/weapon/sheet/metal/M in input.contents)
			animate(M, alpha = 0, time = 10, easing = ELASTIC_EASING)
			addtimer(CALLBACK(src, .proc/processMetal, M), 16)

		for(var/mob/m in input.contents)
			var/tmp/turf/t = get_turf(m)
			if(!findtext(t.icon_state, "lava"))
				continue
			if(istype(m, /mob/living/carbon/human/))
				for(var/mob/M in hearers(src))
					if(M.client)
						M << "\blue The [m] melts!"
				new /obj/Particle/red_particles(m.loc)
				m.gib()
	sleep(tick_lag_original)

/obj/machinery/hs/rust_forge/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)
	if (istype(O, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = O
		if (prob(99) && G.affecting)
			G.affecting.gib()
			m_amount += 50000
		return
	if(istype(O, /obj/item/weapon/sheet/metal))
		var/obj/item/weapon/sheet/metal = O
		if(m_amount < 150000.0)
			addtimer(CALLBACK(src, .proc/processMetal, metal), 16)

/obj/machinery/hs/rust_forge/proc/processMetal(obj/item/weapon/sheet/metal)
	if(metal)
		m_amount += metal.height * metal.width * metal.length * 100000.0
		metal.amount--
		if(metal.amount <= 0)
			new /obj/Particle/red_particles(metal.loc)
			zDel(metal)
			hearers(src) << "<span class='notice'>The [metal] melts! Metal Amount: [m_amount]</span>"
