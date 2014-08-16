#!/usr/bin/env python

import sys, os, traceback, fnmatch, argparse

from byond.DMI import DMI
from PIL import Image, ImageFont, ImageDraw
import sys
import json
import os.path

desktop = "C:/Users/Administrator/Desktop/"
pointer = sys.argv[1]
radius = int(sys.argv[2])

im = Image.new("RGBA", ((1+(radius + radius))*64,(1+(radius + radius))*64), "white")
try:
	f = open("scripts/"+pointer+".txt")
except:
	f = open(""+pointer+".txt")
pic = json.loads(f.read())

layer = sorted(pic, key=lambda pics: pics["layer"])
mid = radius * 64
#font = ImageFont.truetype("arial.ttf", 15)
for obj in layer:
	if(obj["icon"].find("/body_") != -1 and obj["icon"].find("human.dmi") == -1):
		obj["icon"] = "icons/mob/human.dmi" + obj["icon"]
	filename = desktop + obj["icon"]
	filename = filename.encode('ascii', 'ignore')
	if os.path.isfile(filename) != True:
		filename = filename.replace('[1]', '[0]').replace('[2]', '[0]').replace('[3]', '[0]').replace('[4]', '[0]')
		if os.path.isfile(filename) != True:
			continue
	print obj, (mid + (obj["x"] * 64), mid+ (obj["y"] * 64))
	
	image = Image.open(filename)
	image = image.resize((64,64)) 
	if(len(obj["overlays"]) > 0):
		overlays = Image.new("RGBA", (64,64), "white")
		for overl in obj["overlays"]:
			icon = overl["icon"].encode('ascii', 'ignore')
			if (icon.find("/[") != -1):
				continue
			if (icon.find("uniform.dmi") != -1):
				icon = icon.replace("[", "_s[")

			filenameo = desktop + "" + icon
			filenameo = filenameo.encode('ascii', 'ignore')
			if os.path.isfile(filenameo) != True:
				filenameo = filenameo.replace('[1]', '[0]').replace('[2]', '[0]').replace('[3]', '[0]').replace('[4]', '[0]')
				if os.path.isfile(filenameo) != True:
					print(filenameo)
			print(filenameo)
			
			imageo = Image.open(filenameo).resize((64,64))
			imageo.convert('RGBA')
			overlays.paste(imageo) 
		image.paste(overlays, (0,0), image)
	offsetx, offsety = 0, 0
	if "offsetx" in obj:
		offsetx = obj["offsetx"] * 2
	if "offsety" in obj:
		offsety = -obj["offsety"] * 2
	#if "name" in obj:
		#draw.text((mid + (obj["x"] * 64) + offsetx, mid+ (obj["y"] * 64) + offsety) + 15, name, font=font)
	im.paste(image, (mid + (obj["x"] * 64) + offsetx, mid+ (obj["y"] * 64) + offsety), image)
	
	
im.save(pointer+".png")