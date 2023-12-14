/obj/machinery/hydroponics/tray/olive
	icon = 'hs_structures.dmi'
	icon_state = "olive_tray"
	desc = "High Quality Olive Tray"
	special_process()
		if(planted_crop)
			desc = "It's a olive hydroponics tray. It has <b>[planted_crop]</b> planted.<br><font color='#00FF00'><b>Grow Status : %[round((min(7,grow_state)/7)*100)]</b>"
			//every crop has a grow time of 6
			if(frm_counter % 3 == 1)
				grow_state += tick_lag_original/40
			if(round(grow_state) != grow_state_old)
				grow_state_old = round(grow_state)
				Get_Overlay()
		else
			grow_state = 0
			grow_state_old = -1