/*NOTES:
These are powers specific to the Xenoborg mob. They should theoretically be called up with the standard powers.
*/

/mob/living/carbon/alien/humanoid/proc/borgresin() // -- TLE
	set name = "Secrete Iron (25)"
	set desc = "Secrete liquid iron to shape into station structures."
	set category = "Alien"

	if(powerc(25))
		var/choice = input("Choose what you wish to shape.","Iron building") as null|anything in list("Floor","Wall","Airlock","Chair","Table","Locker") //would do it through typesof but then the player choice would have the type path and we don't want the internal workings to be exposed ICly - Urist
		if(!choice || !powerc(25))	return
		adjustToxLoss(-25)
		src << "\green You shape a [choice]."
		for(var/mob/O in viewers(src, null))
			O.show_message(text("\red <B>[src] spews out a molten metal substance and begins to shape it!</B>"), 1)
		switch(choice)
			if("Floor")
				new /turf/simulated/floor(loc)
			if("Wall")
				new /turf/simulated/wall(loc)
			if("Airlock")
				new /obj/machinery/door/airlock(loc)
			if("Chair")
				new /obj/structure/stool/bed/chair(loc)
			if("Table")
				new /obj/structure/table(loc)
			if("Locker")
				new /obj/structure/closet(loc)
	return


/mob/living/carbon/alien/humanoid/proc/borgtoxin(mob/target as mob in oview())
	set name = "Spit Electrode  (10)"
	set desc = "Shoots a ball of electricity at a target, paralyzing them for a short time if they are not wearing protective gear."
	set category = "Alien"

	if(powerc(10))
		if(isalien(target))
			src << "\green This target is immune to stunning!"
			return
		adjustToxLoss(-10)
		src << "\green You spit an electrode at [target]."
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				O << "\red [src] spits an electrode at [target]!"
		//I'm not motivated enough to revise this. Prjectile code in general needs update.
		var/turf/T = loc
		var/turf/U = (istype(target, /atom/movable) ? target.loc : target)

		if(!U || !T)
			return
		while(U && !istype(U,/turf))
			U = U.loc
		if(!istype(T, /turf))
			return
		if (U == T)
			usr.bullet_act(new /obj/item/projectile/energy/electrode(usr.loc), get_organ_target())
			return
		if(!istype(U, /turf))
			return

		var/obj/item/projectile/energy/electrode/A = new /obj/item/projectile/energy/electrode(usr.loc)
		A.current = U
		A.yo = U.y - T.y
		A.xo = U.x - T.x
		A.process()
	return