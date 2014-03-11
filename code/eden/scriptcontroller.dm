
/datum/socket_talk
	var
		enabled = 1
	New()
		..()
		src.enabled = 1

		if(enabled)
			call("DLLSocket.so","establish_connection")("127.0.0.1","8019")

	proc
		send_raw(message)
			if(enabled)
				return call("DLLSocket.so","send_message")(message)
		receive_raw()
			if(enabled)
				return call("DLLSocket.so","recv_message")()

var/datum/socket_talk/socket_talk = new()

var/list/sendQueue = list("start")

/proc/processSocket(message)
	world << message

/proc/scriptController()
	spawn while(1)
		processSocket(socket_talk:receive_raw())
		if(sendQueue.len > 0)
			for(var/message in sendQueue)
				socket_talk:send_raw(message)
		sleep(1)


