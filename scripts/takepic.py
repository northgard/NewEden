#!/usr/bin/env python

import sys, os, traceback, fnmatch, argparse

from byond.DMI import DMI
from PIL import Image
import sys
import json
import os.path

desktop = "C:/Users/Administrator/Desktop/"
pointer = sys.argv[1]
radius = int(sys.argv[2])

im = Image.new("RGBA", ((1+(radius + radius))*64,(1+(radius + radius))*64), "white")
f = open("scripts/"+pointer+".txt")
pic = json.loads(f.read())

layer = sorted(pic, key=lambda pics: pics["layer"])
mid = radius * 64
for obj in layer:
	filename = desktop + obj["icon"]
	filename = filename.encode('ascii', 'ignore')
	if os.path.isfile(filename) != True:
		filename = filename.replace('[1]', '[0]').replace('[2]', '[0]').replace('[3]', '[0]').replace('[4]', '[0]')
		if os.path.isfile(filename) != True:
			continue
	print obj, (mid + (obj["x"] * 64), mid+ (obj["y"] * 64))
	image = Image.open(filename)
	image = image.resize((64,64))
	offsetx, offsety = 0, 0
	if "offsetx" in obj:
		offsetx = obj["offsetx"] * 2
	if "offsety" in obj:
		offsety = -obj["offsety"] * 2
	im.paste(image, (mid + (obj["x"] * 64) + offsetx, mid+ (obj["y"] * 64) + offsety), image)
im.save(pointer+".png")