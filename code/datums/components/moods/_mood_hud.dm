/obj/screen/mood_hud
	name = "mood"
	icon = 'moods.dmi'
	screen_loc = "EAST,NORTH-5"
	plane = 10
	appearance_flags = PIXEL_SCALE | TILE_BOUND | NO_CLIENT_COLOR

/obj/screen/mood_hud/proc/update_icon(mob/living/owner)
	GET_COMPONENT_FROM(mood_component, /datum/component/mood, owner)
	if(mood_component)
		switch(mood_component.mood_value)
			if(11 to INFINITY)
				icon_state = "jolly_mood"
			if(1 to 10)
				icon_state = "happy_mood"
			if(0 to -10)
				icon_state = "sad_mood"
			if(-INFINITY to -11)
				icon_state = "suicide_mood"
			else
				icon_state = "neutral_mood"

/obj/screen/mood_hud/Click()
	GET_COMPONENT_FROM(mood, /datum/component/mood, usr)
	if(mood)
		mood.print_mood(usr)

/mob
	var/obj/screen/mood_hud/mood_button = null

/obj/hud/proc/instantiate_mood_button()
	if(!mymob.mood_button)
		mymob.mood_button = new

	mymob.client.screen += mymob.mood_button