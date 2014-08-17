/*
Ideas for the subtle effects of hallucination:

Light up oxygen/plasma indicators (done)
Cause health to look critical/dead, even when standing (done)
Characters silently watching you
Brief flashes of fire/space/bombs/c4/dangerous shit (done)
Items that are rare/traitorous/don't exist appearing in your inventory slots (done)
Strange audio (should be rare) (done)
Gunshots/explosions/opening doors/less rare audio (done)

*/

mob/living/carbon/var
	image/halimage
	image/halbody
	obj/halitem
	hal_screwyhud = 0 //1 - critical, 2 - dead, 3 - oxygen indicator, 4 - toxin indicator
	handling_hal = 0
	hal_crit = 0

mob/living/carbon/proc/handle_hallucinations()
	if(handling_hal) return
	handling_hal = 1
	while(hallucination > 20)
		sleep(rand(200,500)/(hallucination/25))
		var/halpick = rand(1,70)
		switch(halpick)
			if(0 to 15)
				//Screwy HUD
				//src << "Screwy HUD"
				hal_screwyhud = pick(1,2,3,3,4,4)
				spawn(rand(100,250))
					hal_screwyhud = 0
			if(16 to 25)
				//Strange items
				//src << "Traitor Items"
				if(!halitem)
					halitem = new
					var/list/slots_free = list(ui_lhand,ui_rhand)
					if(l_hand) slots_free -= ui_lhand
					if(r_hand) slots_free -= ui_rhand
					if(istype(src,/mob/living/carbon/human))
						var/mob/living/carbon/human/H = src
						if(!H.belt) slots_free += ui_belt
						if(!H.l_store) slots_free += ui_storage1
						if(!H.r_store) slots_free += ui_storage2
					if(slots_free.len)
						halitem.screen_loc = pick(slots_free)
						halitem.layer = 50
						switch(rand(1,6))
							if(1) //revolver
								halitem.icon = 'icons/obj/gun.dmi'
								halitem.icon_state = "revolver"
								halitem.name = "Revolver"
							if(2) //c4
								halitem.icon = 'icons/obj/assemblies.dmi'
								halitem.icon_state = "plastic-explosive0"
								halitem.name = "Mysterious Package"
								if(prob(25))
									halitem.icon_state = "c4small_1"
							if(3) //sword
								halitem.icon = 'icons/obj/weapons.dmi'
								halitem.icon_state = "sword1"
								halitem.name = "Sword"
							if(4) //stun baton
								halitem.icon = 'icons/obj/weapons.dmi'
								halitem.icon_state = "stunbaton"
								halitem.name = "Stun Baton"
							if(5) //emag
								halitem.icon = 'icons/obj/card.dmi'
								halitem.icon_state = "emag"
								halitem.name = "Cryptographic Sequencer"
							if(6) //flashbang
								halitem.icon = 'icons/obj/grenade.dmi'
								halitem.icon_state = "flashbang1"
								halitem.name = "Flashbang"
						if(client) client.screen += halitem
						spawn(rand(100,250))
							if(client)
								client.screen -= halitem
							halitem = null
			if(26 to 49)
				//Flashes of danger
				//src << "Danger Flash"
				if(!halimage)
					var/list/possible_points = list()
					for(var/turf/simulated/floor/F in view(src,world.view))
						possible_points += F
					if(possible_points.len)
						var/turf/simulated/floor/target = pick(possible_points)

						switch(rand(1,3))
							if(1)
								//src << "Space"
								halimage = image('icons/turf/space.dmi',target,"[rand(1,25)]",TURF_LAYER)
							if(2)
								//src << "Fire"
								halimage = image('icons/effects/fire.dmi',target,"1",TURF_LAYER)
							if(3)
								//src << "C4"
								halimage = image('icons/obj/assemblies.dmi',target,"plastic-explosive2",OBJ_LAYER+0.01)


						if(client) client.images += halimage
						spawn(rand(10,50)) //Only seen for a brief moment.
							if(client) client.images -= halimage
							halimage = null


			if(50 to 60)
				//sounds
				//halltexttospeech(var/text, var/speed, var/pitch, var/accent, var/voice, var/echo)
				var/list/traitoritems = list("esword", "cryptographic sequencer", "laser gun", "detomatix cartridge", "energy crossbow", "freedom implant")
				var/list/voices = list("mb-en1", "mb-us2")
				var/list/verbs = list("whack", "hit", "bludgeon", "smack")
				var/list/sharpverbs = list("slice", "cut", "stab", "shank")
				var/list/getverbs = list("pick up", "grab", "get")
				var/list/dosomething = list("stab you", "beat you", "kill you", "space you", "eat you", "bite you", "rob you", "mug you", "absorb you", "cut your head off", "cut your left arm off", "cut your right arm off", "cut your left leg off", "cut your right leg off", "cut your ears off", "gouge your eyes out")
				var/list/goingto = list("about to", "going to", "getting ready to")
				var/soundpick = rand(1,2)
				switch(soundpick)
					if(1)
						//otherplayers
						var/list/otherplayers = list()
						var/list/objects = list()
						for(var/mob/living/M in oview(5,src))
							otherplayers.Add(M)
						for(var/obj/O in oview(5,src))
							if(O.anchored == 0)
								objects.Add(O)
						if(otherplayers.len > 0)
							var/mob/living/chosen = pick(otherplayers)
							var/oppick = rand(1,50)
							var/voice2 = "+whisperf"
							if(prob(50))
								voice2 = "+whisper"
							switch(oppick)
								if(1 to 2)
									if(chosen.back)
										src.show_message("<span class='notice'>[chosen] puts the [pick(traitoritems)] into \the [chosen.back].</span>")
									else
										src.show_message("<span class='notice'>[chosen] puts the [pick(traitoritems)] into the backpack.</span>")

								if(3 to 8)
									var/obj/randomobject = pick(objects)
									var/verb1 = pick(verbs)
									var/get = pick(getverbs)
									if(randomobject.sharp)
										verb1 = pick(sharpverbs)
									var/text = "[get] [randomobject] and [verb1] [chosen] "
									if(prob(30))
										text += "with it"
									if(hascall(src,"halltexttospeech"))
										src:halltexttospeech(text, rand(150, 200), rand(1,99), voice2, pick(voices), 1)
										spawn(15)
											if(fexists("sound/playervoices/hall[src.ckey].ogg"))
												var/fname = file("sound/playervoices/hall[src.ckey].ogg")
												var/sound/S = sound(fname, wait = 1, channel = 0)
												S.status = SOUND_STREAM
												S.x = rand(-10,10)
												S.y = rand(-10,10)
												S.z = rand(-10,10)
												src << S
												if(prob(50))
													src:halltexttospeech("do it", rand(150, 200), rand(1,99), voice2, pick(voices), 1)
													spawn(15)
														if(fexists("sound/playervoices/hall[src.ckey].ogg"))
															var/sound/S2 = sound(fname, wait = 1, channel = 0)
															S2 = sound(fname, wait = 1, channel = 0)
															S2.environment = 0
															S2.status = SOUND_STREAM
															S2.x = rand(-10,10)
															S2.y = rand(-10,10)
															S2.z = rand(-10,10)
															src << S
								if(9 to 14)
									var/going = pick(goingto)
									var/something = pick(dosomething)
									var/text = "[chosen] is [going] [something]"
									if(hascall(src,"halltexttospeech"))
										src:halltexttospeech(text, rand(150, 200), rand(1,99), voice2, pick(voices), 1)
										spawn(15)
											if(fexists("sound/playervoices/hall[src.ckey].ogg"))
												var/fname = file("sound/playervoices/hall[src.ckey].ogg")
												var/sound/S = sound(fname, wait = 1, channel = 0)
												S.status = SOUND_STREAM
												S.x = rand(-10,10)
												S.y = rand(-10,10)
												S.z = rand(-10,10)
												src << S
									else
										src << text

			if(66 to 70)
				//Flashes of danger
				//src << "Danger Flash"
				if(!halbody)
					var/list/possible_points = list()
					for(var/turf/simulated/floor/F in view(src,world.view))
						possible_points += F
					if(possible_points.len)
						var/turf/simulated/floor/target = pick(possible_points)
						switch(rand(1,4))
							if(1)
								halbody = image('icons/mob/human.dmi',target,"husk_l",TURF_LAYER)
							if(2,3)
								halbody = image('icons/mob/human.dmi',target,"husk_s",TURF_LAYER)
							if(4)
								halbody = image('icons/mob/alien.dmi',target,"alienother",TURF_LAYER)
	//						if(5)
	//							halbody = image('xcomalien.dmi',target,"chryssalid",TURF_LAYER)

						if(client) client.images += halbody
						spawn(rand(50,80)) //Only seen for a brief moment.
							if(client) client.images -= halbody
							halbody = null
/*			if(71 to 72)
				//Fake death
//				src.sleeping_willingly = 1
				src.sleeping = 20
				hal_crit = 1
				hal_screwyhud = 1
				spawn(rand(50,100))
//					src.sleeping_willingly = 0
					src.sleeping = 0
					hal_crit = 0
					hal_screwyhud = 0*/
	handling_hal = 0




/*obj/machinery/proc/mockpanel(list/buttons,start_txt,end_txt,list/mid_txts)

	if(!mocktxt)

		mocktxt = ""

		var/possible_txt = list("Launch Escape Pods","Self-Destruct Sequence","\[Swipe ID\]","De-Monkify",\
		"Reticulate Splines","Plasma","Open Valve","Lockdown","Nerf Airflow","Kill Traitor","Nihilism",\
		"OBJECTION!","Arrest Stephen Bowman","Engage Anti-Trenna Defenses","Increase Captain IQ","Retrieve Arms",\
		"Play Charades","Oxygen","Inject BeAcOs","Ninja Lizards","Limit Break","Build Sentry")

		if(mid_txts)
			while(mid_txts.len)
				var/mid_txt = pick(mid_txts)
				mocktxt += mid_txt
				mid_txts -= mid_txt

		while(buttons.len)

			var/button = pick(buttons)

			var/button_txt = pick(possible_txt)

			mocktxt += "<a href='?src=\ref[src];[button]'>[button_txt]</a><br>"

			buttons -= button
			possible_txt -= button_txt

	return start_txt + mocktxt + end_txt + "</TT></BODY></HTML>"

proc/check_panel(mob/M)
	if (istype(M, /mob/living/carbon/human) || istype(M, /mob/living/silicon/ai))
		if(M.hallucination < 15)
			return 1
	return 0*/

/obj/effect/fake_attacker
	icon = null
	icon_state = null
	name = ""
	desc = ""
	density = 0
	anchored = 1
	opacity = 0
	var/mob/living/carbon/human/my_target = null
	var/weapon_name = null
	var/obj/item/weap = null
	var/image/stand_icon = null
	var/image/currentimage = null
	var/icon/base = null
	var/s_tone
	var/mob/living/clone = null
	var/image/left
	var/image/right
	var/image/up
	var/collapse
	var/image/down

	var/health = 100

	attackby(var/obj/item/weapon/P as obj, mob/user as mob)
		step_away(src,my_target,2)
		for(var/mob/M in oviewers(world.view,my_target))
			M << "\red <B>[my_target] flails around wildly.</B>"
		my_target.show_message("\red <B>[src] has been attacked by [my_target] </B>", 1) //Lazy.

		src.health -= P.force


		return

	HasEntered(var/mob/M, somenumber)
		if(M == my_target)
			step_away(src,my_target,2)
			if(prob(30))
				for(var/mob/O in oviewers(world.view , my_target))
					O << "\red <B>[my_target] stumbles around.</B>"

	New()
		..()
		spawn(300)
			if(my_target)
				my_target.hallucinations -= src
			del(src)
		step_away(src,my_target,2)
		spawn attack_loop()


	proc/updateimage()
	//	del src.currentimage


		if(src.dir == NORTH)
			del src.currentimage
			src.currentimage = new /image(up,src)
		else if(src.dir == SOUTH)
			del src.currentimage
			src.currentimage = new /image(down,src)
		else if(src.dir == EAST)
			del src.currentimage
			src.currentimage = new /image(right,src)
		else if(src.dir == WEST)
			del src.currentimage
			src.currentimage = new /image(left,src)
		my_target << currentimage


	proc/attack_loop()
		while(1)
			sleep(rand(5,10))
			if(src.health < 0)
				collapse()
				continue
			if(get_dist(src,my_target) > 1)
				src.dir = get_dir(src,my_target)
				step_towards(src,my_target)
				updateimage()
			else
				if(prob(15))
					if(weapon_name)
						my_target << sound(pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg'))
						my_target.show_message("\red <B>[my_target] has been attacked with [weapon_name] by [src.name] </B>", 1)
						my_target.halloss += 8
						if(prob(20)) my_target.eye_blurry += 3
						if(prob(33))
							if(!locate(/obj/effect/overlay) in my_target.loc)
								fake_blood(my_target)
					else
						my_target << sound(pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg'))
						my_target.show_message("\red <B>[src.name] has punched [my_target]!</B>", 1)
						my_target.halloss += 4
						if(prob(33))
							if(!locate(/obj/effect/overlay) in my_target.loc)
								fake_blood(my_target)

			if(prob(15))
				step_away(src,my_target,2)

	proc/collapse()
		collapse = 1
		updateimage()

/proc/fake_blood(var/mob/target)
	var/obj/effect/overlay/O = new/obj/effect/overlay(target.loc)
	O.name = "blood"
	var/image/I = image('icons/effects/blood.dmi',O,"floor[rand(1,7)]",O.dir,1)
	target << I
	spawn(300)
		del(O)
	return

var/list/non_fakeattack_weapons = list(/obj/item/weapon/gun/projectile, /obj/item/ammo_magazine/a357,\
	/obj/item/weapon/gun/energy/crossbow, /obj/item/weapon/melee/energy/sword,\
	/obj/item/weapon/storage/box/syndicate, /obj/item/weapon/storage/box/emps,\
	/obj/item/weapon/cartridge/syndicate, /obj/item/clothing/under/chameleon,\
	/obj/item/clothing/shoes/syndigaloshes, /obj/item/weapon/card/id/syndicate,\
	/obj/item/clothing/mask/gas/voice, /obj/item/clothing/glasses/thermal,\
	/obj/item/device/chameleon, /obj/item/weapon/card/emag,\
	/obj/item/weapon/storage/toolbox/syndicate, /obj/item/weapon/aiModule,\
	/obj/item/device/radio/headset/syndicate,	/obj/item/weapon/plastique,\
	/obj/item/device/powersink, /obj/item/weapon/storage/box/syndie_kit,\
	/obj/item/toy/syndicateballoon, /obj/item/weapon/gun/energy/laser/captain,\
	/obj/item/weapon/hand_tele, /obj/item/weapon/rcd, /obj/item/weapon/tank/jetpack,\
	/obj/item/clothing/under/rank/captain, /obj/item/device/aicard,\
	/obj/item/clothing/shoes/magboots, /obj/item/blueprints, /obj/item/weapon/disk/nuclear,\
	/obj/item/clothing/suit/space/nasavoid, /obj/item/weapon/tank)

/proc/fake_attack(var/mob/living/target)
//	var/list/possible_clones = new/list()
	var/mob/living/carbon/human/clone = null
	var/clone_weapon = null

	for(var/mob/living/carbon/human/H in living_mob_list)
		if(H.stat || H.lying) continue
//		possible_clones += H
		clone = H
		break	//changed the code a bit. Less randomised, but less work to do. Should be ok, world.contents aren't stored in any particular order.

//	if(!possible_clones.len) return
//	clone = pick(possible_clones)
	if(!clone)	return

	//var/obj/effect/fake_attacker/F = new/obj/effect/fake_attacker(outside_range(target))
	var/obj/effect/fake_attacker/F = new/obj/effect/fake_attacker(target.loc)
	if(clone.l_hand)
		if(!(locate(clone.l_hand) in non_fakeattack_weapons))
			clone_weapon = clone.l_hand.name
			F.weap = clone.l_hand
	else if (clone.r_hand)
		if(!(locate(clone.r_hand) in non_fakeattack_weapons))
			clone_weapon = clone.r_hand.name
			F.weap = clone.r_hand

	F.name = clone.name
	F.my_target = target
	F.weapon_name = clone_weapon
	target.hallucinations += F


	F.left = image(clone,dir = WEST)
	F.right = image(clone,dir = EAST)
	F.up = image(clone,dir = NORTH)
	F.down = image(clone,dir = SOUTH)

//	F.base = new /icon(clone.stand_icon)
//	F.currentimage = new /image(clone)

/*



	F.left = new /icon(clone.stand_icon,dir=WEST)
	for(var/icon/i in clone.overlays)
		F.left.Blend(i)
	F.up = new /icon(clone.stand_icon,dir=NORTH)
	for(var/icon/i in clone.overlays)
		F.up.Blend(i)
	F.down = new /icon(clone.stand_icon,dir=SOUTH)
	for(var/icon/i in clone.overlays)
		F.down.Blend(i)
	F.right = new /icon(clone.stand_icon,dir=EAST)
	for(var/icon/i in clone.overlays)
		F.right.Blend(i)

	target << F.up
	*/

	F.updateimage()