#define TENTACLE_POWER_THRESHOLD 10
#define TENTACLE_DAMAGE_MULTIPLIER 10

/datum/tentacleType
	var/name
	var/description
	var/power

/datum/tentacleType/proc/applyEffect(mob/living/user, mob/living/target, obj/cleanable/bucket_juice/b)
	return

/datum/tentacleType/StrongTentacle
	name = "Strong Tentacle"
	description = "A powerful and sturdy tentacle."
	power = 50

/datum/tentacleType/StrongTentacle/applyEffect(mob/living/user, mob/living/target, obj/cleanable/bucket_juice/b)
	target.TakeBruteDamage(power * TENTACLE_DAMAGE_MULTIPLIER)
	world << "TAKE FURY!"
	view() << "<font color=red><b>[target] SCREAMS!</b></font>"

/datum/tentacleType/HealingTentacle
	name = "Healing Tentacle"
	description = "A tentacle with healing capabilities."
	power = -20

/datum/tentacleType/HealingTentacle/applyEffect(mob/living/user, mob/living/target, obj/cleanable/bucket_juice/b)
	target.TakeBruteDamage(power)
	b.name = "Gaia's Seed"