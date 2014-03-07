/*
Quadrants are
[Q1][Q2]
[Q3][Q4]

*/

/proc/subtractRGB(var/rgb, var/amount)
	var/list/rgblist = ReadRGB(rgb)
	var/red = rgblist[1] - amount
	var/green = rgblist[2] - amount
	var/blue = rgblist[3] - amount
	return rgb(red,green,blue)

/obj/lightingsquare
	icon = 'icons/lighting.dmi'
	icon_state = "lightsquare"
	blend_mode = BLEND_MULTIPLY
	layer = 10
	color = rgb(50,50,50)
	var/defaultcolor = rgb(50,50,50)
	var/list/effect = list()

/obj/lightingsquare/proc/setQuadrant(var/quadrant)
	if(quadrant == 1)
		pixel_y = 16
		pixel_x = 0
	if(quadrant == 2)
		pixel_y = 16
		pixel_x = 16
	if(quadrant == 3)
		pixel_y = 0
		pixel_x = 0
	if(quadrant == 4)
		pixel_y = 0
		pixel_x = 16
/obj/lightingsquare/proc/darken(var/shades)
	color = defaultcolor
	color = subtractRGB(color, shades * 10)

/obj/lightingsquare/proc/setColor(var/newcol)
	color = newcol
/obj/lightingsquare/proc/reset()
	color = defaultcolor

atom/proc/SetLuminosity(var/lumin)
	src.luminosity = lumin

atom/proc/SetOpacity(var/new_opacity)
	if(new_opacity == null)
		new_opacity = !opacity
	else if(opacity == new_opacity)
		return
	opacity = new_opacity



area
	var/lighting_use_dynamic = 1 //for legacy problems

/turf
	var/list/lightquadrants = list()
	var/lighting_lumcount = 0
	var/lighting_changed = 0

/turf/New()
	..()
	var/area/Area = src.loc
	if(istype(Area) && Area.lighting_use_dynamic)
		var/obj/lightingsquare/q1 = new /obj/lightingsquare()
		q1.loc = src
		q1.setQuadrant(1)
		lightquadrants += q1

		var/obj/lightingsquare/q2 = new /obj/lightingsquare()
		q2.loc = src
		q2.setQuadrant(2)
		lightquadrants += q2

		var/obj/lightingsquare/q3 = new /obj/lightingsquare()
		q3.loc = src
		q3.setQuadrant(3)
		lightquadrants += q3

		var/obj/lightingsquare/q4 = new /obj/lightingsquare()
		q4.loc = src
		q4.setQuadrant(4)
		lightquadrants += q4

turf/proc/shift_to_subarea()
	//legacy

/turf/proc/updateQuads(var/direction, var/distance)
	var/obj/lightingsquare/lq1 = lightquadrants[1]
	var/obj/lightingsquare/lq2 = lightquadrants[2]
	var/obj/lightingsquare/lq3 = lightquadrants[3]
	var/obj/lightingsquare/lq4 = lightquadrants[4]
	if(distance == 0)
		return
	if(direction == NORTH)
		var/a1 = distance * 2
		var/a2 = distance * 2 - 1
		lq1.darken(a2)
		lq2.darken(a2)
		lq3.darken(a1)
		lq4.darken(a1)
	if(direction == SOUTH)
		var/a1 = distance * 2
		var/a2 = distance * 2 - 1
		lq1.darken(a1)
		lq2.darken(a1)
		lq3.darken(a2)
		lq4.darken(a2)
	if(direction == EAST)
		var/a1 = distance * 2
		var/a2 = distance * 2 - 1
		lq1.darken(a1)
		lq2.darken(a2)
		lq3.darken(a1)
		lq4.darken(a2)
	if(direction == WEST)
		var/a1 = distance * 2
		var/a2 = distance * 2 - 1
		lq1.darken(a2)
		lq2.darken(a1)
		lq3.darken(a2)
		lq4.darken(a1)
	if(direction == NORTHWEST)
		var/a1 = distance * 2 //mid
		var/a2 = distance * 2 - 1 //close
		var/a3 = distance * 2 + 1 //far
		lq1.darken(a2)
		lq2.darken(a1)
		lq3.darken(a1)
		lq4.darken(a3)
	if(direction == NORTHEAST)
		var/a1 = distance * 2 //mid
		var/a2 = distance * 2 - 1 //close
		var/a3 = distance * 2 + 1 //far
		lq1.darken(a1)
		lq2.darken(a2)
		lq3.darken(a3)
		lq4.darken(a1)
	if(direction == SOUTHWEST)
		var/a1 = distance * 2 //mid
		var/a2 = distance * 2 - 1 //close
		var/a3 = distance * 2 + 1 //far
		lq1.darken(a1)
		lq2.darken(a3)
		lq3.darken(a2)
		lq4.darken(a1)
	if(direction == SOUTHEAST)
		var/a1 = distance * 2 //mid
		var/a2 = distance * 2 - 1 //close
		var/a3 = distance * 2 + 1 //far
		lq1.darken(a3)
		lq2.darken(a1)
		lq3.darken(a1)
		lq4.darken(a2)
/datum/light_source
	var/mobile = 0
	var/atom/parent
	var/__x = 0
	var/__y = 0
	var/color = rgb(230,230,230)
	var/list/effect
	effect = new/list()

/datum/light_source/New(atom/par)
	..()
	if(istype(parent, /atom/movable))	mobile = 1
	else								mobile = 0
	parent = par
	__x = parent.x
	__y = parent.y

	lighting_controller.lights += src

/datum/light_source/proc/removeLight()
	for(var/turf in effect)
		var/turf/T = turf
		var/obj/lightingsquare/lq1 = T.lightquadrants[1]
		var/obj/lightingsquare/lq2 = T.lightquadrants[2]
		var/obj/lightingsquare/lq3 = T.lightquadrants[3]
		var/obj/lightingsquare/lq4 = T.lightquadrants[4]
		lq1.reset()
		lq2.reset()
		lq3.reset()
		lq4.reset()
	del src

/datum/light_source/proc/check()
	if(!parent)
		removeLight()
		return 1

	if(mobile)
		if(parent.x != __x || parent.y != __y)
			__x = parent.x
			__y = parent.y

	if(parent.loc && parent.luminosity > 0)
		effect = effectArea()
		for(var/turf in effect)
			var/turf/T = turf
			var/direction = get_dir(src.parent, T)
			var/obj/lightingsquare/lq1 = T.lightquadrants[1]
			var/obj/lightingsquare/lq2 = T.lightquadrants[2]
			var/obj/lightingsquare/lq3 = T.lightquadrants[3]
			var/obj/lightingsquare/lq4 = T.lightquadrants[4]
			if(lq1.color != color)

				lq1.setColor(color)
				lq2.setColor(color)
				lq3.setColor(color)
				lq4.setColor(color)
			T.updateQuads(direction, effect[T])


	return 0

/datum/light_source/proc/effectArea()
	. = list()
	for(var/turf/T in view(parent.luminosity, parent))

		var/lumdistance = lum(T)
		if(lumdistance > 0)
			.[T] = lumdistance
	return .

/datum/light_source/proc/lum(turf/A)
	return parent.luminosity - max(abs(A.x-__x),abs(A.y-__y))

/datum/light_source/proc/setColor(var/col)
	color = col

atom
	var/datum/light_source/light
	New()
		..()
		light = new /datum/light_source(src)

