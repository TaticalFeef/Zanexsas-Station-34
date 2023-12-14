obj/projectile

datum/AbilityBehaviour
	var/name = ""
	var/desc = ""
	var/_icon
	var/startTime = "" // BEGIN MIDDLE END, basicamente um delay
	var/lifeDist = 0
	var/isRandomOn = FALSE
	var/mob/source
	var/mob/target
	var/atom/projectile

datum/AbilityBehaviour/New(_name, _desc, _sprite, _src, _trg)
	..()
	name = _name
	desc = _desc
	_icon = _sprite
	source = _src
	target = _trg

datum/AbilityBehaviour/proc/DoAction()
	world << "algum negro codou errado >:("
	return 1

datum/AbilityBehaviour/Ranged
	name = "Ranged Attack"
	desc = "A ranged attack!"
	startTime = BEGIN

	var/minDist = 1
	var/maxDist = 30

datum/AbilityBehaviour/Ranged/DoAction(mob/user = usr)
	checkDist(user)
	if(isRandomOn)
		lifeDist = rand(minDist,maxDist)

datum/AbilityBehaviour/Ranged/proc/checkDist(mob/user)
	set background = 1
	var/tmp/distorone
	var/obj/projectile/a = projectile
	if(!a.loc)
		a = new a.type
	do
		distorone = get_dist(source,target)
		walk_to(a,get_step(src,user.dir),0,0.5,0)
		if(distorone > lifeDist)
			a.loc = null
			del src
	while(distorone < lifeDist)

datum/AbilityBehaviour/AoE

datum/AbilityBehaviour/Self
