#!/usr/bin/env python2


import sys, os, math,time,random,string,zlib,objvars

variables = objvars.varis()

objtype = sys.argv[1]
pointer = sys.argv[2]
intent  = sys.argv[3]
f2 = open('C:/Users/Administrator/Dropbox/Baystation12/scripts/log.txt', 'w+')

f = open('C:/Users/Administrator/Dropbox/Baystation12/scripts/'+pointer+'.txt', 'w+')
returnstring = ""
#freq<var;icon_state=test.var2=1,proc;open=1,pointer=[pointer1]>var;icon_state=test.var2=1,proc;open=1,pointer=[pointer2]
frequency = zlib.crc32(objtype) / 200000
frequency = 44100 + frequency
if objtype.find("/door") != -1:
	
	if intent == "hurt":
		returnstring=str(frequency)	+"<var;locked=1,proc;close=1.update_icon=1,pointer="+pointer
	if intent == "grab":
		returnstring=str(frequency)	+"<var;locked=0,proc;close=1.update_icon=1,pointer="+pointer
	if intent == "disarm":
		returnstring =str(frequency)	+"<var;welded=1,proc;close=1.update_icon=1,pointer="+pointer
	if intent == "help":
		if variables["density"] == "1":
			returnstring =str(frequency)	+"<var;welded=0.locked=0,proc;open=1,pointer="+pointer
		if variables["density"] == "0":
			returnstring =str(frequency)	+"<var;welded=0.locked=0,proc;close=1,pointer="+pointer

if objtype.find("/firealarm") != -1:
	returnstring = str(frequency)	+"<var;novar=0,proc;alarm=1,pointer="+pointer
	if intent == "help":
		returnstring = str(frequency)	+"<var;none=24,proc;reset=1,pointer="+pointer

if objtype.find("/door_control") != -1:
	returnstring = str(frequency)	+"<var;novar=0,proc;alarm=1,pointer="+pointer
	if intent == "help":
		returnstring = str(frequency)	+"<var;none=24,proc;reset=1,pointer="+pointer

if objtype.find("/mob/living") != -1:
	if intent == "grab":
		returnstring=str(frequency)	+"<var;halloss=+15,proc;Stun=2.Weaken=1,pointer="+pointer
	if intent == "hurt":
		returnstring=str(frequency)	+"<var;halloss=+30,proc;emote=me:1:yells in pain and falls to the ground.Weaken=4.Stun=3,pointer="+pointer
	if intent == "help":
		returnstring=str(frequency)	+"<var;halloss=0,proc;adjustOxyLoss=-50.adjustToxLoss=-50.adjustBruteLoss=-50.adjustFireLoss=-50.adjustCloneLoss=-50.adjustBrainLoss=-50,pointer="+pointer
if objtype.find("/aicard") != -1:
	if intent == "hurt":
		returnstring=str(frequency)	+"<var;none=1,proc;emote=me:1:yells in pain as it disintegrates.Del=1,pointer="+pointer
	if intent == "hold":
		returnstring=str(frequency)	+"<var;none=1,proc;emote=me:1:yells in pain as it's circuit starts to fry,pointer="+pointer

if objtype.find("/conveyor_switch") != -1:
	if intent == "help":
		returnstring=str(frequency)	+"<var;position=1,proc;update=1,pointer="+pointer

if objtype.find("/light") != -1:
	if variables["status"] == "2":
		returnstring=str(frequency)	+"<var;status=0,proc;update=0.seton=1,pointer="+pointer
	if variables["status"] == "0":
		if intent == "help":
			returnstring=str(frequency)	+"<var;luminosity="+str(int(variables("luminosity")) + 2)+".brightness=+2,proc;update=0.seton=1,pointer="+pointer
		if intent == "grab":
			returnstring=str(frequency)	+"<var;luminosity="+str(int(variables("luminosity")) - 2)+".brightness=-2,proc;update=0.seton=1,pointer="+pointer
		if intent == "hurt":
			returnstring=str(frequency)	+"<var;luminosity=0,proc;update=0.seton=0,pointer="+pointer

if objtype.find("/smes") != -1:
	if intent == "help":
		returnstring=str(frequency)	+"<var;charge=+500000,proc;none=1,pointer="+pointer
	if intent == "hurt":
		returnstring=str(frequency)	+"<var;charge=-500000,proc;none=1,pointer="+pointer

if objtype.find("/vending") != -1:
	returnstring=str(frequency)	+"<var;none=1,proc;malfunction=,pointer="+pointer

if objtype.find("/table") != -1:
	returnstring=str(frequency)	+"<var;none=1,proc;destroy=1,pointer="+pointer

if objtype.find("/machinery/hydroponics") != -1:
	if intent == "help":
		returnstring=str(frequency)	+"<var;waterlevel=100,proc;none=1,pointer="+pointer
		
if objtype.find("/apc") != -1:
	if intent == "help":
		returnstring=str(frequency)	+"<var;none=1,proc;none=1,pointer="+pointer+">var;charge=2500,proc;none=1,pointer="+variables["cell"]
	if intent == "hurt":
		returnstring=str(frequency)	+"<var;none=1,proc;none=1,pointer="+pointer+">var;charge=0,proc;none=1,pointer="+variables["cell"]

if objtype.find("/closet") != -1:
	if intent == "help" and variables["opened"] == "1":
		returnstring=str(frequency)	+"<var;locked=0,proc;close=1,pointer="+pointer
	if intent == "help" and variables["opened"] == "0":
		returnstring=str(frequency)	+"<var;locked=0,proc;open=1,pointer="+pointer
	if intent == "hurt":
		returnstring=str(frequency)	+"<var;locked=1.icon_state="+variables["icon_locked"]+",proc;close=1.update_icon=1,pointer="+pointer
	if intent == "disarm":
		if variables["welded"] == "1":
			returnstring=str(frequency)	+"<var;welded=0,proc;close=1,pointer="+pointer
		if variables["welded"] == "0":
			returnstring=str(frequency)	+"<var;welded=1,proc;close=1,pointer="+pointer

if objtype.find("/alarm") != -1:
	if intent == "help":
		returnstring=str(frequency)	+"<var;mode=1,proc;apply_mode=1,pointer="+pointer
	if intent == "hurt":
		returnstring=str(frequency)	+"<var;mode=3,proc;apply_mode=1,pointer="+pointer
	
f.write(returnstring)
f.close()
f2.write(returnstring+'\n')
f2.close()
print(variables)

if os.path.isfile('C:\\Users\\Administrator\\Dropbox\\Baystation12\\scripts\\'+pointer+'.txt'):
	a=1	
	#os.remove('C:\\Users\\Administrator\\Dropbox\\Baystation12\\scripts\\'+pointer+'.txt')
os.remove('C:/Users/Administrator/Dropbox/Baystation12/scripts/objvars.py')
os.remove('C:/Users/Administrator/Dropbox/Baystation12/scripts/objvars.pyc')
#raw_input()
sys.exit()
