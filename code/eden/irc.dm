


/proc/stringsplit(txt, character)
	var/cur_text = txt
	var/last_found = 1
	var/found_char = findtext(cur_text,character)
	var/list/list = list()
	if(found_char)
		var/fs = copytext(cur_text,last_found,found_char)
		list += fs
		last_found = found_char+length(character)
		found_char = findtext(cur_text,character,last_found)
	while(found_char)
		var/found_string = copytext(cur_text,last_found,found_char)
		last_found = found_char+length(character)
		list += found_string
		found_char = findtext(cur_text,character,last_found)
	list += copytext(cur_text,last_found,length(cur_text)+1)
	return list

/datum/IRCController
	var
		list/oocmessages = list()
	proc
		getCommands()
			var/f = file("scripts/commands.txt")
			var/filetext = file2text(f)
			ext_python("wipe.py", "commands.txt")
			if(filetext != "")
				var/list/filelist = stringsplit(filetext, "\n")
				for(var/v in filelist)
					var/command = params2list(v)
					if(command["command"] == "proc")
						var/procname = command["procname"]
						var/atom/obj
						if(findtext(command["pointer"], "\[0x"))
							obj = locate(command["pointer"])
						else
							for(var/mob/M in player_list)
								if(M.ckey == command["pointer"])
									obj = M
						var/list/args2 = text2list(command["args"], ";;")
						var/list/args1 = list()
						for(var/argu in args2)
							if(findtext(argu, "\[0x"))
								if(isloc(locate(argu)))
									argu = locate(argu)
							else
								if(text2num(argu))
									argu = text2num(argu)
							args1.Add(argu)
						if(obj && isloc(obj))
							call(obj, procname)(arglist(args1))
						else
							call(text2path(procname))(arglist(args1))
					if(command["command"] == "var")
						var/varname = command["varname"]
						var/atom/obj
						if(findtext(command["pointer"], "\[0x"))
							obj = locate(command["pointer"])
						else
							for(var/mob/M in player_list)
								if(M.ckey == command["pointer"])
									obj = M
						if(hasvar(obj, varname))
							var/value = command["value"]

							if(findtext(value, "\[0x"))
								if(isloc(locate(value)))
									obj.vars[varname] = locate(value)
							else
								if(text2num(value))
									obj.vars[varname] = text2num(value)
								else
									obj.vars[varname] = value
					if(command["command"] == "getvar")
						var/varname = command["varname"]
						var/nick = command["nick"]
						var/atom/obj
						if(findtext(command["pointer"], "\[0x"))
							obj = locate(command["pointer"])
						else
							for(var/mob/M in player_list)
								if(M.ckey == command["pointer"])
									obj = M
						if(hasvar(obj, varname))
							var/vartext = ""
							var/thevar = obj.vars[varname]
							if(islist(thevar))
								vartext = list2json(thevar)
							else if(isloc(thevar))
								vartext = "{\"1\":\"\ref[thevar]\"}"
							else
								vartext = "{\"1\":\"[thevar]\"}"
							var/list/irccommand = list()
							irccommand["command"] = "getvar"
							irccommand["nick"] = nick
							irccommand["message"] = vartext
							IRCController.writeCommand(irccommand)

					if(command["command"] == "pm")
						var/pmtxt = command["message"]
						var/pmname = command["name"]
						for(var/client/C in clients)
							if(C.ckey == pmname)
								C << pmtxt
					if(command["command"] == "ooc")
						var/ooctxt = command["message"]
						var/oocname = command["name"]
						for(var/client/C in clients)
							if(C.prefs.toggles & CHAT_OOC)
								C << "<font color=\"crimson\">\[IRC]</font> <font color='#0099cc'><span class='ooc'><span class='prefix'>OOC:</span> <EM>[sanitize(oocname)]:</EM> <span class='message'>[sanitize(ooctxt)]</span></span></font>"
					if(command["command"] == "msay")
						var/msaytxt = command["message"]
						var/msayname = command["name"]
						for(var/client/C in admins)
							if((R_ADMIN|R_MOD|R_MENTOR) & C.holder.rights)
								C << "<span class='mod'><EM>[msayname]</EM>: <span class='message'>[msaytxt]</span></span>"




		writeCommand(var/list/commands)
			var/params = list2params(commands)
			ext_python("writecommand.py", "\""+params + "\"")


/proc/ircInterface()
	spawn while(1)
		IRCController.getCommands()
		sleep(20)
