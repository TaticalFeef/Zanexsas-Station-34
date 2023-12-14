datum
	mood
		normal
			desc = "ok mula"
			moodAdditive = 10

			meetConditions()
				if(owner.health >= owner.maxhealth/2)
					return TRUE
				else
					return FALSE

		rage
			desc = "OK BUDDY RETARD NOEW STOP"
			moodAdditive = -10

			meetConditions()
				if(owner.health <= owner.maxhealth/3 && owner:alternian_blood_type == "Purple")
					return TRUE
				else
					return FALSE

