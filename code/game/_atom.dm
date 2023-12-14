/atom/Dispose()
	if(reagents)
		cdel(reagents)
	if(light)
		cdel(light)
		light = null
	. = ..()

/atom/Recycle()
	return