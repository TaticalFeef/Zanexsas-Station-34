/obj/cleanable/bucket_juice
	name = "Bucket Juice"
	desc = "A mysterious liquid."
	icon = 'interact.dmi'

	New()
		. = ..()
		icon_state = "cum[rand(1,12)]"
		filters = new /list()

	Click()
		set src in oview(1)
		view() << "<font color=blue>[usr] cleans up the [src.name]</font>"
		zDel(src)

	Destroyed()
		. = ..()
		filters = null
		return .