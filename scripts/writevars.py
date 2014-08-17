#!/usr/bin/env python2


import sys, os, math,time,random,string,zlib
count = 0
returnstring = '''def varis():
	return variables
variables={'''
for var in sys.argv:
	print(var)
	if count > 0:
		vartable = var.split("=")
		print(vartable)
		if count == 1:
			returnstring = returnstring + "'" + vartable[0] + "': \""+vartable[1]+"\""
		else:
			returnstring = returnstring + ", '" + vartable[0] + "': \""+vartable[1]+"\""
	count = count + 1
returnstring = returnstring + "}"
		
f = open('C:\\Users\\Administrator\\Dropbox\\Baystation12\\scripts\\objvars.py', 'w+')
print(returnstring)
f.write(returnstring)
f.close()

sys.exit()
