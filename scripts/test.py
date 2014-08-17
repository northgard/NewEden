#!/usr/bin/env python2
import sys
print "WORKS"

f = open("scripts/test.txt", "w+")
for argu in sys.argv:
	f.write(argu + "\n")
f.close()
while 1:
	raw_input()