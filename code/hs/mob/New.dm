/mob/living/carbon/human/
	New()
		..()
		spawn()
			all_partners += src
			force = rand(1,10)
			AddComponent(/datum/component/mood)
			AddComponent(/datum/component/quadrant)

	Stat()
		..()
		statpanel("Stats","Force: [src.force * 10]")
		GET_COMPONENT_FROM(quadrants, /datum/component/quadrant, src)
		if(quadrants)
			statpanel("Quadrants")
			stat("Matesprit: ", quadrants.matesprit ? quadrants.matesprit.name : "None")
			stat("Moiral: ", quadrants.moiral ? quadrants.moiral.name : "None")
			stat("Kismesis: ", quadrants.kismesis ? quadrants.kismesis.name : "None")

//eek
///mob/living/carbon/human/ComponentInitialize()
//	..()