#define in_range(source, user) (get_dist(source, user) <= 1 && (get_step(source, 0)?:z) == (get_step(user, 0)?:z))

proc/trange(var/Range=0,var/atom/Center=null)
	if(Center==null||Range==0) return
	var/_x1y1 = locate(min(Center.x-Range,0),min(Center.y-Range,0),Center.z)
	var/_x2y2 = locate(max(Center.x+Range,world.maxx),max(Center.y+Range,world.maxx),Center.z)
	return block(_x1y1,_x2y2)
