atom/proc/Highlight(apply, _color)
	if(apply)
		filters = filter(type="outline", size=1, _color ? _color : rgb(255,255,255))
	else
		filters = null