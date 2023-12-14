/mob/living/carbon/human/
	New()
		..()
		spawn()
			moods += new /datum/mood/normal/ (src)
			mood_handler = new /datum/mood_handler/ (src)

			force = rand(1,10)

	Stat()
		..()
		statpanel("Stats","Force: [src.force * 10]")