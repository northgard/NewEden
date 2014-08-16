
/atom/proc/takePic(var/radius)
	var/list/objects = list()
	for(var/obj/objec in range(radius, src))
		if(istype(objec.loc, /mob))
			continue
		var/list/object = list()
		var/dir = 0
		if(objec.dir == 8)
			dir = 3
		else if(objec.dir == 4)
			dir = 2
		else if(objec.dir == 1)
			dir = 1
		object["icon"] = "[objec.icon]/[objec.icon_state]\[[dir]].png"
		object["x"] = objec.x - src.x
		object["y"] = src.y - objec.y
		object["layer"] = objec.layer
		if(objec.pixel_x != 0)
			object["offsetx"] = objec.pixel_x
		if(objec.pixel_y != 0)
			object["offsety"] = objec.pixel_y
		if(istype(objec, /mob/living/carbon) || istype(objec, /mob/living/silicon))
			object["name"] = "[objec.name]"
		var/list/overlays = list()
		object["overlays"] = overlays
		objects += list(object)
	for(var/turf/objec in range(radius, src))
		if(istype(objec.loc, /mob))
			continue
		var/list/object = list()
		var/dir = 0
		if(objec.dir == 8)
			dir = 3
		else if(objec.dir == 4)
			dir = 2
		else if(objec.dir == 1)
			dir = 1
		object["icon"] = "[objec.icon]/[objec.icon_state]\[[dir]].png"
		object["x"] = objec.x - src.x
		object["y"] = src.y - objec.y
		object["layer"] = objec.layer
		if(objec.pixel_x != 0)
			object["offsetx"] = objec.pixel_x
		if(objec.pixel_y != 0)
			object["offsety"] = objec.pixel_y
		if(istype(objec, /mob/living/carbon) || istype(objec, /mob/living/silicon))
			object["name"] = "[objec.name]"
		var/list/overlays = list()
		object["overlays"] = overlays
		objects += list(object)
	for(var/mob/living/objec in range(radius, src))
		if(istype(objec.loc, /mob))
			continue
		if(istype(objec, /mob/living/carbon/human))
			continue
		var/list/object = list()
		var/dir = 0
		if(objec.dir == 8)
			dir = 3
		else if(objec.dir == 4)
			dir = 2
		else if(objec.dir == 1)
			dir = 1
		object["icon"] = "[objec.icon]/[objec.icon_state]\[[dir]].png"
		object["x"] = objec.x - src.x
		object["y"] = src.y - objec.y
		object["layer"] = objec.layer
		if(objec.pixel_x != 0)
			object["offsetx"] = objec.pixel_x
		if(objec.pixel_y != 0)
			object["offsety"] = objec.pixel_y
		if(istype(objec, /mob/living/carbon) || istype(objec, /mob/living/silicon))
			object["name"] = "[objec.name]"
		var/list/overlays = list()
		object["overlays"] = overlays
		objects += list(object)
	for(var/mob/living/carbon/human/objec in range(radius, src))
		if(istype(objec.loc, /mob))
			continue
		var/list/object = list()
		var/dir = 0
		if(objec.dir == 8)
			dir = 3
		else if(objec.dir == 4)
			dir = 2
		else if(objec.dir == 1)
			dir = 1
		object["icon"] = "[objec.icon]/[objec.icon_state]\[[dir]].png"
		object["x"] = objec.x - src.x
		object["y"] = src.y - objec.y
		object["layer"] = objec.layer
		if(objec.pixel_x != 0)
			object["offsetx"] = objec.pixel_x
		if(objec.pixel_y != 0)
			object["offsety"] = objec.pixel_y
		if(istype(objec, /mob/living/carbon) || istype(objec, /mob/living/silicon))
			object["name"] = "[objec.name]"
		var/list/overlays = list()
		if(objec.w_uniform != null && isloc(objec.w_uniform))
			var/list/overl = list()
			overl["icon"] = "icons/mob/uniform.dmi/"+objec.w_uniform.item_color+"\[[dir]\].png"
			overlays += list(overl)
		if(objec.belt != null && isloc(objec.belt))
			var/list/overl = list()
			overl["icon"] = "icons/mob/belt.dmi/"+objec.belt.item_color+"\[[dir]\].png"
			overlays += list(overl)
		if(objec.back != null && isloc(objec.back))
			var/list/overl = list()
			overl["icon"] = "icons/mob/back.dmi/"+objec.back.item_color+"\[[dir]\].png"
			overlays += list(overl)
		if(objec.glasses != null && isloc(objec.glasses))
			var/list/overl = list()
			overl["icon"] = "icons/mob/eyes.dmi/"+objec.glasses.item_color+"\[[dir]\].png"
			overlays += list(overl)
		if(objec.head != null && isloc(objec.head))
			var/list/overl = list()
			overl["icon"] = "icons/mob/head.dmi/"+objec.head.item_color+"\[[dir]\].png"
			overlays += list(overl)
		if(objec.shoes != null && isloc(objec.shoes))
			var/list/overl = list()
			overl["icon"] = "icons/mob/feet.dmi/"+objec.shoes.item_color+"\[[dir]\].png"
			overlays += list(overl)
		if(objec.gloves != null && isloc(objec.gloves))
			var/list/overl = list()
			overl["icon"] = "icons/mob/hands.dmi/"+objec.gloves.item_color+"\[[dir]\].png"
			overlays += list(overl)
		if(objec.wear_mask != null && isloc(objec.wear_mask))
			var/list/overl = list()
			overl["icon"] = "icons/mob/mask.dmi/"+objec.wear_mask.item_color+"\[[dir]\].png"
			overlays += list(overl)
		if(objec.wear_suit != null && isloc(objec.wear_suit))
			var/list/overl = list()
			overl["icon"] = "icons/mob/suit.dmi/"+objec.wear_suit.item_color+"\[[dir]\].png"
			overlays += list(overl)
		object["overlays"] = overlays
		objects += list(object)
	var/objjson = list2json(objects)
	ext_python("wipe.py", "\ref[src].txt")
	file("scripts/\ref[src].txt") << objjson
	ext_python("takepic.py", "\ref[src]", radius)