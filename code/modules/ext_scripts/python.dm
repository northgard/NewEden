
/proc/ext_python(var/script, var/args, var/scriptsprefix = 1)
	if(scriptsprefix) script = "scripts/" + script

	if(world.system_type == MS_WINDOWS)
		script = replacetext(script, "/", "\\")

	var/command = config.python_path + " " + script + " " + args

	return shell(command)

/*
var/pathtoroot = "C:/Users/Administrator/Desktop/bs12/scripts/"

/proc/ext_python(var/script, var/args, var/customprefix = 0)
	if(customprefix == 0)
		script = pathtoroot + script
	script = replacetext(script, "/", "\\")
	spawn(0)
		call("Python.dll", "run_python")(script,args)
	return
*/