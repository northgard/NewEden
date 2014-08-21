/proc/PrecacheObjects()
	createPool("spark", /obj/effect/effect/sparks)
	var/i
	//Make 10 sparks
	for(i=0, i<30, i++)
		var/cache = new /obj/effect/effect/sparks()
		pool("spark", cache)