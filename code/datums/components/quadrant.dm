var/global/list/kismesis_pairs = list()
var/global/list/moiral_pairs = list()
var/global/list/matesprit_pairs = list()
var/global/list/all_partners = list()

/datum/component/quadrant
	var/mob/living/owner
	var/mob/living/matesprit
	var/mob/living/moiral
	var/mob/living/kismesis
	var/quadrants_filled = FALSE

/datum/component/quadrant/New(mob/living/_owner)
	. = ..()
	owner = _owner
	all_partners += _owner
	initialize_quadrants()
	RegisterSignal(owner, COMSIG_HUMAN_LIFE, .proc/check_for_partners)

/datum/component/quadrant/proc/initialize_quadrants()
	var/list/quadrant_types = list("matesprit", "moiral", "kismesis")
	var/list/quadrant_pairs = list("matesprit" = matesprit_pairs, "moiral" = moiral_pairs, "kismesis" = kismesis_pairs)

	for(var/quadrant in quadrant_types)
		var/partner = src.vars[quadrant]

		if(!partner)
			partner = pick_available_partner(quadrant)
			src.vars[quadrant] = partner

		if(partner)
			//hmmmmmmmmmmmmmmmmmmmm
			quadrant_pairs[quadrant] += list(owner, partner)

	check_quadrants_filled()

/datum/component/quadrant/proc/pick_available_partner(quadrant_type)
	var/list/available_partners = all_partners.Copy()
	available_partners -= owner

	switch(quadrant_type)
		if("matesprit")
			for(var/i in matesprit_pairs)
				available_partners -= i
		if("moiral")
			for(var/i in moiral_pairs)
				available_partners -= i
		if("kismesis")
			for(var/i in kismesis_pairs)
				available_partners -= i

	return length(available_partners) ? pick(available_partners) : null

/datum/component/quadrant/proc/check_for_partners()
	if(quadrants_filled)
		return

	initialize_quadrants()
	check_quadrants_filled()

/datum/component/quadrant/proc/check_quadrants_filled()
	if(matesprit && moiral && kismesis)
		quadrants_filled = TRUE
		all_partners -= owner
		UnregisterSignal(owner, COMSIG_HUMAN_LIFE)

/datum/component/quadrant/proc/is_in_any_quadrant(mob/living/partner)
	return (partner == matesprit || partner == moiral || partner == kismesis)

//TRAIÇÕES WAHHHH
/datum/component/quadrant/proc/react_to_external_influence(external_factor, mob/living/offender)
	switch(external_factor)
		if(FACTOR_CHEATING)
			handle_cheating(offender)
		if(FACTOR_PARTNER_DEATH)
			handle_partner_death(offender)
		if(FACTOR_OWNER_DEATH)
			handle_owner_death()

//só acontece com matesprit
/datum/component/quadrant/proc/handle_cheating(mob/living/offender)
	if(matesprit == offender)
		matesprit = null
		matesprit_pairs -= list(owner, matesprit)
	GET_COMPONENT_FROM(mood, /datum/component/mood, owner)
	if(mood)
		mood.add_moodlet(/datum/moodlet/cuck)

/datum/component/quadrant/proc/handle_partner_death(mob/living/partner)
	if(partner == matesprit)
		matesprit = null
	if(partner == moiral)
		moiral = null
	if(partner == kismesis)
		kismesis = null
	GET_COMPONENT_FROM(mood, /datum/component/mood, owner)
	if(mood)
		mood.add_moodlet(/datum/moodlet/grief)

/datum/component/quadrant/proc/handle_owner_death()
	if(matesprit)
		matesprit_pairs -= list(owner, matesprit)
	if(moiral)
		moiral_pairs -= list(owner, moiral)
	if(kismesis)
		kismesis_pairs -= list(owner, kismesis)