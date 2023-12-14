
skilltree
	var/list/layout=list(

	//this is the way I'd imagined it easiest to do a skill tree -- graphically made, and easy to see.

	//screen size; 11x11
list(,,,,,,,,,,),
list(,,,,,,,,,,),
list(,,,,,,,,,,),
list(,,,,,,,,,,),
list(,,,,,,,,,,), //y1-11
list(,,,,,,,,,,),
list(,,,,,,,,,,),
list(,,,,,,,,,,),
list(,,,,,,,,,,),
list(,,,,,,,,,,),
list(,,,,,,,,,,)
		//x1-11
)

#define EARW  /skill/arrow(loc=CURRENT_SCHEME,dir=EAST)
#define WARW  /skill/arrow(loc=CURRENT_SCHEME,dir=WEST)
#define NARW  /skill/arrow(loc=CURRENT_SCHEME,dir=NORTH)
#define SARW  /skill/arrow(loc=CURRENT_SCHEME,dir=SOUTH)
#define NEARW /skill/arrow(loc=CURRENT_SCHEME,dir=NORTHEAST)
#define SEARW /skill/arrow(loc=CURRENT_SCHEME,dir=SOUTHEAST)
#define NWARW /skill/arrow(loc=CURRENT_SCHEME,dir=NORTHWEST)
#define SWARW /skill/arrow(loc=CURRENT_SCHEME,dir=SOUTHWEST)

//this is a really nice way of organizing data, it saves a lot of typing, and, since each is used twice
//it saves a fair amount of retyping, too.

#define BOLT    /skill/magician/bolt
#define ASSLT   /skill/magician/assault
#define PSNTH   /skill/magician/poisontouch
#define QUAKE   /skill/magician/quake
#define NBOLT   /skill/magician/netherbolt

#define FSHLD   /skill/magician/fireshield
#define ISHLD   /skill/magician/watershield
#define WSHLD   /skill/magician/windshield
#define ESHLD   /skill/magician/earthshield
#define MSHLD   /skill/magician/magicshield

//here is a sample tree using the above skills
//it comes up in reverse of what you would think -- the SHLD skills appear at the top

	magician
		layout=list(
list(     ,     ,NBOLT,     ,     ,,,,,,),
list(     ,     ,     ,     ,     ,,,,,,),
list(BOLT ,     ,ASSLT,     ,     ,,,,,,),
list(     ,     ,     ,     ,     ,,,,,,),
list(     ,     ,PSNTH,     ,QUAKE,,,,,,),
list(     ,     ,     ,     ,     ,,,,,,),
list(     ,     ,     ,     ,     ,,,,,,),
list(     ,     ,FSHLD,     ,ISHLD,,,,,,),
list(MSHLD,     ,     ,     ,     ,,,,,,),
list(     ,     ,ESHLD,     ,WSHLD,,,,,,),
list(     ,     ,     ,     ,     ,,,,,,)

)

#define STRK     /skill/runeknight/strike
#define WSTRK    /skill/runeknight/waterstrike
#define FSTRK    /skill/runeknight/firestrike
#define SSTRK    /skill/runeknight/swiftstrike
#define JAB      /skill/runeknight/jab
#define THROWING    /skill/runeknight/throwing
#define FTHRW    /skill/runeknight/firethrow

#define WIMBU    /skill/runeknight/windimbue
#define IIMBU    /skill/runeknight/waterimbue
#define FIMBU    /skill/runeknight/fireimbue
#define EIMBU    /skill/runeknight/earthimbue
#define MIMBU    /skill/runeknight/magicimbue



	runeknight
		layout=list(
list(     ,     ,     ,     ,     ,     ,     ,     ,     ,,),
list(     ,     ,     ,     ,     ,     ,     ,     ,     ,,),
list(MIMBU,     ,FIMBU,     ,IIMBU,     ,WIMBU,     ,EIMBU,,),
list(     ,     ,     ,     ,     ,     ,     ,     ,     ,,),
list(     ,     ,     ,     ,     ,     ,     ,     ,     ,,),
list(     ,     ,     ,     ,     ,     ,     ,     ,     ,,),
list(     ,     ,JAB  ,     ,     ,     ,     ,     ,     ,,),
list(     ,     ,     ,     ,     ,     ,     ,     ,     ,,),
list(STRK ,     ,THROWING,     ,FTHRW,     ,     ,     ,     ,,),
list(     ,     ,     ,     ,     ,     ,     ,     ,     ,,),
list(     ,     ,FSTRK,     ,WSTRK,     ,     ,     ,     ,,)

)

skill
	Click()
		if(usr.skillpoints<=0)
			usr << "You have no skill points to spend."
			return
		if(usr.busy)return
		usr.busy=TRUE

		if(reqskill)

			if(!(src in usr.skills))

				if(!(locate(reqskill) in usr.skills))

					var/skill/req=new reqskill
					usr << "You must first get \"[req]\"[reqskilllvl>1 ? " to the level [reqskilllvl]" : ""]."
					del req
					usr.busy=FALSE
					return
				else

					var/tskill=locate(reqskill) in usr.skills
					if(tskill && usr.skills[tskill]<reqskilllvl)

						var/skill/req=new reqskill
						usr << "You must first get \"[req]\"[reqskilllvl>1 ? " to the level [reqskilllvl]" : ""]."
						del req
						usr.busy=FALSE
						return

		if(!(locate(type) in usr.skills))
					//just checkin'
			if(alert(usr,"Are you sure you want to buy [src]?","[src]","Yes","No")=="Yes")
				usr.skills += src
				usr.skills[src]=1
				usr.skillpoints-=skillcost
				usr.client.load_tree(usr.class)
				usr << "You learned [src]!"
		else
					//verification of the skills existance
			var/skill/x=locate(type) in usr.skills
			if(!x)usr << "Odd issue here.."
			if(usr.skills[x]>=x.maxlevel)
				usr << "[src] is currently at level [maxlevel], the maximum level."
				usr.busy=FALSE
				return

			if(alert(usr,"Are you sure you want to raise [src]'s level to [curlevel+1]?","[src]","Yes","No")=="Yes")

				usr.skills[x]++
				usr.skillpoints-=skillcost
				usr.client.load_tree(usr.class)
					//reload the tree afterwards, so you can visually see the changes
		usr.busy=FALSE

	icon='icons.dmi'

	New(newloc)
		if(istext(newloc))
			screen_loc = newloc
					//thanks again to lummox

	available/icon_state="available"
					//blue
	unbuyable/icon_state="unbuyable"
					//red
	completed/icon_state="completed"
					//green
	arrow
		icon_state="arrow"
		New(loc,dir)
			dir=dir

	parent_type=/obj

	var
		curlevel   =0
		maxlevel   =5
		reqskill
		reqskilllvl=1
		skillcost  =1
					//again, with the test magician.
					//I tried to organize it, so it goes in order of advancement
					//they're also very condensed, but linear.
	magician
		bolt       {icon_state="bolt"}
		poisontouch{icon_state="poisontouch";reqskill=BOLT}
					//this one requires bolt
		assault    {icon_state="magstrike";reqskill=BOLT}
		netherbolt {icon_state="netherbolt";reqskill=BOLT;reqskilllvl=3}
					//this one requires bolt to be at level 3.
		quake      {icon_state="quake";reqskill=PSNTH}

		magicshield{icon_state="defnether"}
		fireshield {icon_state="deffire";reqskill=MSHLD}
		watershield{icon_state="defwater";reqskill=FSHLD}
		windshield {icon_state="defwind";reqskill=ESHLD}
		earthshield{icon_state="defearth";reqskill=MSHLD}


	runeknight
		strike     {icon_state="strike"}
		swiftstrike{icon_state="swiftstrike";reqskill=STRK}
		throwing      {icon_state="throw";reqskill=STRK}
		firestrike {icon_state="firestrike";reqskill=STRK}
		jab        {icon_state="jab";reqskill=STRK;reqskilllvl=3}
		waterstrike{icon_state="waterstrike";reqskill=FSTRK}
		firethrow  {icon_state="firethrow";reqskill=THROWING}

		magicimbue{icon_state="offnether"}
		fireimbue {icon_state="offfire";reqskill=MIMBU}
		waterimbue{icon_state="offwater";reqskill=FIMBU}
		windimbue {icon_state="offwind";reqskill=IIMBU}
		earthimbue{icon_state="offearth";reqskill=WIMBU}