#!/usr/bin/env python2

import sys, os, math,time,random,string
from subprocess import call

def restart():
	print("Restarting Server")
	time.sleep(1)

	os.system("taskkill /F /im dreamdaemon.exe")
	call("\"C:/Program Files (x86)/BYOND/bin/dreamdaemon.exe\" C:/Users/Administrator/Dropbox/Baystation12/baystation12.dmb 1300 -trusted", shell=True)
	raw_input()
	sys.exit()

restart()	