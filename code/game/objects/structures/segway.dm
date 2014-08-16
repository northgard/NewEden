

//old style retardo-cart
/obj/structure/stool/bed/chair/segway
	name = "segway"
	icon = 'icons/obj/vehicles.dmi'
	desc = "A convenient way to get around"
	icon_state = "segway"
	anchored = 1
	density = 1
	var/mob/living/carbon/occupant


/obj/structure/stool/bed/chair/segway/New()
	handle_rotation()

/obj/structure/stool/bed/chair/segway/Bump(var/atom/obstacle)
	occupant = buckled_mob
	if(istype(obstacle, /obj))
		var/obj/O = obstacle
		if(istype(O , /obj/machinery/door))
			if(src.occupant)
				O.Bumped(src.occupant)
		else if(!O.anchored)
			step(obstacle,src.dir)
		else
			obstacle.Bumped(src)
	else if(istype(obstacle, /mob/living/carbon/human))
		if(obstacle && src.occupant)
			var/mob/M = obstacle
			M.stunned = 2
			M.weakened = 2
			src.occupant.stunned = 4
			src.occupant.weakened = 4
			src.occupant.take_organ_damage(rand(2,5))
			playsound(src, 'bang.ogg', 25)
			src.unbuckle()
			var/wasdense = 0
			if(M.density == 1)
				M.density = 0
				wasdense = 1
			src.occupant.throw_at(obstacle, 5, 3)
			if(wasdense == 1)
				spawn(1)
					M.density = 1
			for(var/mob/living/carbon/V in ohearers(6, src))
				V.show_message("\red <B>[src.occupant] has crashed into [M] with their [src.name]!</B>",1)
	else
		obstacle.Bumped(src)
	return




/obj/structure/stool/bed/chair/segway/relaymove(mob/user, direction)
	if(user.stat || user.stunned || user.weakened || user.paralysis)
		unbuckle()

	step(src, direction)
	update_mob()
	handle_rotation()




/obj/structure/stool/bed/chair/segway/Move()
	sleep(1)
	..()
	handle_rotation()
	update_mob()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.loc = loc


/obj/structure/stool/bed/chair/segway/buckle_mob(mob/M, mob/user)
	if(M != user || !ismob(M) || get_dist(src, user) > 1 || user.restrained() || user.lying || user.stat || M.buckled || istype(user, /mob/living/silicon))
		return

	unbuckle()

	M.visible_message(\
		"<span class='notice'>[M] steps onto the segway!</span>",\
		"<span class='notice'>You step onto the segway!</span>")
	M.buckled = src
	M.loc = loc
	M.dir = dir
	M.update_canmove()
	buckled_mob = M
	update_mob()
	add_fingerprint(user)


/obj/structure/stool/bed/chair/segway/unbuckle()
	if(buckled_mob)
		buckled_mob.pixel_x = 0
		buckled_mob.pixel_y = 0
	..()


/obj/structure/stool/bed/chair/segway/handle_rotation()
	if(dir == SOUTH)
		layer = FLY_LAYER
	else
		layer = OBJ_LAYER

	if(buckled_mob)
		if(buckled_mob.loc != loc)
			buckled_mob.buckled = null //Temporary, so Move() succeeds.
			buckled_mob.buckled = src //Restoring

	update_mob()


/obj/structure/stool/bed/chair/segway/proc/update_mob()
	if(istype(src.loc, /turf/space))
		icon_state = "segwayjet"
		name = "jet segway"
	else
		icon_state = "segway"
		name = "segway"
	if(buckled_mob)
		buckled_mob.dir = dir
		switch(dir)
			if(SOUTH)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 7
			if(WEST)
				buckled_mob.pixel_x = 8
				buckled_mob.pixel_y = 7
			if(NORTH)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 6
			if(EAST)
				buckled_mob.pixel_x = -8
				buckled_mob.pixel_y = 7


/obj/structure/stool/bed/chair/segway/bullet_act(var/obj/item/projectile/Proj)
	if(buckled_mob)
		if(prob(90))
			return buckled_mob.bullet_act(Proj)
	visible_message("<span class='warning'>[Proj] ricochets off the segway!</span>")
