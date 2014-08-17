
var/list/deleteq = list()
/proc/deleteQueue()
	spawn while(1)
		if(deleteq.len > 0)
			var/obj/object = deleteq[1]
			deleteq.Remove(object)
			del object
		sleep(20)

/proc/addDeleteQueue(var/obj/object)
	deleteq += object
	object.loc = null