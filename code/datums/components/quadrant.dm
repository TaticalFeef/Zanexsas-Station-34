var/global/list/kismesis_pairs = list()
var/global/list/moiral_pairs = list()
var/global/list/matesprit_pairs = list()
var/global/list/all_partners = list()

/datum/component/quadrant
	var/mob/living/owner
	var/mob/living/matesprit
	var/mob/living/moiral
	var/mob/living/kismesis

/datum/component/quadrant/New(mob/living/_owner)
	. = ..()
	owner = _owner
	initialize_quadrants()

/datum/component/quadrant/proc/initialize_quadrants()
	matesprit = pick_available_partner("matesprit")
	moiral = pick_available_partner("moiral")
	kismesis = pick_available_partner("kismesis")

	matesprit_pairs += list(owner, matesprit)
	moiral_pairs += list(owner, moiral)
	kismesis_pairs += list(owner, kismesis)

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

/datum/component/quadrant/proc/is_in_any_quadrant(mob/living/partner)
	return (partner == matesprit || partner == moiral || partner == kismesis)