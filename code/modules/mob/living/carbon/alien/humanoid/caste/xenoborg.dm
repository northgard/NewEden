/mob/living/carbon/alien/humanoid/xenoborg
	name = "XenoBorg 1.0"
	caste = "s"
	maxHealth = 250
	health = 250
	storedPlasma = 500
	max_plasma = 500
	icon_state = "xeborg_s"
	plasma_rate = 50

/mob/living/carbon/alien/humanoid/xenoborg/New()
	var/datum/reagents/R = new/datum/reagents(500)
	reagents = R
	R.my_atom = src
	if(name == "XenoBorg 1.0")
		name = text("XenoBorg 1.0 ([rand(1, 1000)])")
	real_name = name
	verbs.Add(/mob/living/carbon/alien/humanoid/proc/plant,/mob/living/carbon/alien/humanoid/proc/borgresin,/mob/living/carbon/alien/humanoid/proc/corrosive_acid,/mob/living/carbon/alien/humanoid/proc/borgtoxin, /mob/living/carbon/alien/humanoid/proc/regurgitate)
	..()

/mob/living/carbon/alien/humanoid/xenoborg


	handle_regular_hud_updates()

		..() //-Yvarov

		if (healths)
			if (stat != 2)
				switch(health)
					if(200 to INFINITY)
						healths.icon_state = "health0"
					if(150 to 200)
						healths.icon_state = "health1"
					if(100 to 150)
						healths.icon_state = "health2"
					if(50 to 100)
						healths.icon_state = "health3"
					if(0 to 50)
						healths.icon_state = "health4"
					else
						healths.icon_state = "health5"
			else
				healths.icon_state = "health6"
