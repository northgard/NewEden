/proc/PrecacheObjects()
	createPool("fire", /obj/fire)
	createPool("spark", /obj/effect/effect/sparks)
	//Make 150 fires
	var/i
	for(i=0, i<250, i++)
		var/cache = new /obj/fire()
		pool("fire", cache)
	//Make 10 sparks
	for(i=0, i<30, i++)
		var/cache = new /obj/effect/effect/sparks()
		pool("spark", cache)