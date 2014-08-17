var/bumptime = world.time
/datum/socket_talk
	var
		enabled = 1
	New()
		..()
		src.enabled = 1

		if(enabled)
			call("DLLSocket.dll","establish_connection")("127.0.0.1","8019")

	proc
		send_raw(message)
			if(enabled)
				return call("DLLSocket.dll","send_message")(message)
		receive_raw()
			if(enabled)
				return call("DLLSocket.dll","recv_message")()

var/datum/socket_talk/socket_talk = new()

var/list/sendQueue = list()

/proc/processSocket(message)
	if(message != "" && message)
		world.log << message

/proc/scriptController()
	while(1)
		spawn(0)
			if(bumptime <= world.time)
				bumptime = world.time + 5
				var/action[0]
				action["action"] = "bump"
				sendQueue += list2params(action)
			processSocket(socket_talk:receive_raw())
			if(sendQueue.len > 0)
				for(var/message in sendQueue)
					socket_talk:send_raw(message)
				sendQueue = list()
		sleep(1)


