/atom/Destroyed()
	if(reagents)
		zDel(reagents)
	if(light)
		zDel(light)
		light = null
	. = ..()

/atom/Recycle()
	return