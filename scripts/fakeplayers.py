#!/usr/bin/env python2


import sys, os, math,time,random


#num = int(sys.argv[1])
num= = 1
count = 5

os.system("start taskkill /F /im telnet.exe")

os.system("start taskkill /F /im espeak.exe")
if num:
	#count = int(math.floor(random.randint(6,8 + math.floor(num / 2.5)) - math.floor(num * .50)))
	
	#time.sleep(1)
	#if num <= 2:
		#count = 0

	if count > 0:
		for x in range(1, count + 1):
			os.system("start /min telnet 127.0.0.1 1300")	
sys.exit()

