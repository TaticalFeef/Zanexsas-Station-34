#define LAGCHECK(x) while (world.tick_usage > x) sleep(world.tick_lag)
#define GLOBAL_LIST_EMPTY(X) /datum/GLOB/var/list/X = list()

/datum/GLOB

var/datum/dynamicQueue/delete_queue

var/list/normalBloodTypes = list("Mutant","Rust","Bronze","Gold","Lime","Olive","Jade","Teal","Cerulean","Indigo")
var/list/highBloodTypes = list("Purple","Violet","Fuchsia")
var/list/allBloodTypes = list("Mutant","Rust","Bronze","Gold","Lime","Olive","Jade","Teal","Cerulean","Indigo","Purple","Violet","Fuchsia")

var/list/highblood_whitelist = list("Zanexsas","Jogn_iceberg","Newbjloko","Harmonyc")
// Isso precisa ser carregado de um arquivo de texto, ou preferencialmente de um banco de dados.


var/list/titleSongs = list(	//Pra colocar uma musica no lobby e so colocar o numero e a musica
    'chahut.ogg',
    'karako.ogg',
    'marvus.ogg',
)

proc/notifyAction(var/mob/_usr, var/mob/target, var/actionMsg, var/soundPath)
	for(var/mob/M in hearers(world.view, _usr))
		if(M.client)
			if(M != _usr)
				M << "\red [usr.name] [actionMsg] [target.name]!"
				M << sound(soundPath)