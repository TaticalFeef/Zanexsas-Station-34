/mob/living/carbon/human/proc/assignRandomTentacleType()
	var/list/tentacle_types = typesof(/datum/tentacleType) - /datum/tentacleType
	var/type = pick(tentacle_types)
	var/datum/tentacleType/t = new type()
	tentacle = t

/mob/living/carbon/human/MouseDrop_T(mob/living/carbon/human/M as mob, mob/user as mob)
	if(!istype(M, /mob/living/carbon/human)) return
	if(user != M) return
	if(M == src) return
	if(get_dist(M, src) > 1) return
	if(istype(M, /mob/living/silicon/ai)) return
	if(LinkBlocked(M.loc, src.loc)) return

	src.requestConsent(user)

/mob/living/carbon/human/proc/requestConsent(var/mob/living/carbon/human/R)
	//R = Requester
	var/choice = alert(src, "[R] wants to perform a tentacle interaction. Do you consent?", "Consent Request", "Yes", "No")
	if(choice == "Yes")
		R.partner = src
		src.partner = R
		R.consent = TRUE
		src.consent = TRUE
		R.performInteraction()
	else
		R << "[src] não aceitou seu pedido..."

/mob/living/carbon/human/proc/performInteraction()
	partner.fug()

/mob/living/carbon/human/proc/tentacly()
	var/mob/living/carbon/human/p = src.partner
	if(!p)
		src << "Não possui parceiro!"
		return
	if(get_dist(p, src) > 1)
		src << "Longe demais!"
		return
	if(src.tired == 0 && src.gender == "male" && src.consent && src.partner.consent)
		src.dir = get_dir(src, src.partner)

		view() << "<font color=purple><b>[src]</b> performs an action on <b>[p]</b></font>"
		src.do_tentacly_animation(p)
		src.bucketMeter += 10
	else
		src << "<font color=blue>You are too tired or lacking consent to do that.</font>"

	if(src.bucketMeter >= MAX_BUCKET_METER)
		view() << "<big><font color=purple><b>[src]</b> Splurges!</font></big>"
		src.bucketMeter = 0
		var/obj/cleanable/bucket_juice/C = new(src.loc)
		C.name = "DNA Juice"
		src.tentacle.applyEffect(src, src.partner, C)
		GET_COMPONENT_FROM(mood, /datum/component/mood, src)
		if(mood)
			mood.add_moodlet(/datum/moodlet/afterglow)
		else
			src << "\red You feel nothing at all..."
		//hum
		if(partner.gender == "male")
			GET_COMPONENT_FROM(moodPartner, /datum/component/mood, src.partner)
			if(moodPartner)
				moodPartner.add_moodlet(/datum/moodlet/sodomized)
		src.tired = 1
		src.consent = FALSE
		src.partner.consent = FALSE
		src.partner.partner = null
		src.partner = null
		sleep(REST_PERIOD)
		src.tired = 0

/mob/living/carbon/human/proc/fug()
	var/trpHTML = {"
	<Title>Interaction Options</Title>
	<Body style='background-color: #dfdfdf;'>
	<p>Select an action</p>
	<a href='?src=\ref[src];action=bucket' class='aButton'>Tentacle Interaction (10 - 15)</a>
	<a href='?src=\ref[src];action=other' class='aButton'>Other Interaction</a>
	</Body>
	"}
	usr << browse(trpHTML, "window=tentacle")

/mob/living/carbon/human/Topic(href,href_list[])
	switch(href_list["action"])
		if("startgame")
			usr << "Starting game..."
		if("bucket")
			usr:tentacly()
		if("other")
			usr:gib()


/mob/living/carbon/human/proc/do_tentacly_animation(mob/living/P)
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/final_pixel_y = initial(pixel_y)

	var/direction = get_dir(src, P)
	if(direction & NORTH)
		pixel_y_diff = 8
	else if(direction & SOUTH)
		pixel_y_diff = -8

	if(direction & EAST)
		pixel_x_diff = 8
	else if(direction & WEST)
		pixel_x_diff = -8

	if(pixel_x_diff == 0 && pixel_y_diff == 0)
		pixel_x_diff = rand(-3,3)
		pixel_y_diff = rand(-3,3)
		animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
		animate(pixel_x = initial(pixel_x), pixel_y = initial(pixel_y), time = 2)
		return

	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
	animate(pixel_x = initial(pixel_x), pixel_y = final_pixel_y, time = 2)
