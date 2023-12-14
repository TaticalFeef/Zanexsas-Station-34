datum/Ability
	var/name = ""
	var/description = ""
	var/abilityType = ""

	var/_icon
	var/list/behaviours

	var/atom/particle

	var/requiresTarget = FALSE
	var/canCastOnSelf = FALSE

	var/cooldown = 0
	var/castTime = 0 //'-' ... :3 lolizinha                   -         ss
	var/cost = 0

datum/Ability/New(_name, _sprite, behaviours)
	..()
	if(!name || !description || !_icon || !behaviours || !particle || !cooldown)
		name = _name
		description = "Default" //metodo depois para criar descri�ao baseada com as behaviours
		_icon = _sprite
		behaviours = behaviours
		cooldown = 0
		requiresTarget = FALSE
		canCastOnSelf = FALSE
		
datum/Ability/proc/Use()
	return 1