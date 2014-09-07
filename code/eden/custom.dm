/obj/custom
	name = "Custom Object"

/obj/custom/proc/load(var/type)
	global.socket_talk.send_raw("a=init&t=[type]")

/obj/custom/verb/loadobj(message as text)
	src.load(message)

proc/processdata(message)
	world << message

proc/getdata()

	spawn while(1)
		processdata(global.socket_talk.receive_raw())

