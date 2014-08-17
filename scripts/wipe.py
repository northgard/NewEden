#!/usr/bin/env python2
import sys

arg1 = sys.argv[1]

if arg1 == "blah":
	arg1 = "commands.txt"
print arg1
print 'C:/Users/Administrator/Desktop/bs12/scripts/'+arg1

	
f = open('C:/Users/Administrator/Desktop/bs12/scripts/'+arg1, "r+")

f.seek(0)
f.truncate()
f.close()