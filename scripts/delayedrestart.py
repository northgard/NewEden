#!/usr/bin/env python2

import sys, os, math,time,random,string
from subprocess import call

def restart():
	print("Restarting Server")
	time.sleep(1)

	os.system("taskkill /F /im ddaemon.exe")
	call("\"C:/Program Files (x86)/BYOND/bin/ddaemon.exe\" C:/Users/Administrator/Desktop/updated/baystation12.dmb 1300 -trusted", shell=True)
	raw_input()
	sys.exit()

restart()	