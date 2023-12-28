/mob/living/carbon/human/
	New()
		..()
		spawn()
			force = rand(1,10)
			AddComponent(/datum/component/mood)

	Stat()
		..()
		statpanel("Stats","Force: [src.force * 10]")

//eek
///mob/living/carbon/human/ComponentInitialize()
//	..()