#!/usr/bin/env python2

'''
WINDOWS ONLY!
You need espeak: http://sourceforge.net/projects/espeak/files/espeak/espeak-1.47/espeak-1.47.11-win.zip/download
SOund eXchange (sox): http://sourceforge.net/projects/sox/files/sox/14.4.1/sox-14.4.1a-win32.zip/download
and WinVorbis for OggEnc: http://winvorbis.stationplaylist.com/WinVorbisSetup.exe

'''
import sys, os, re, string, random, math
from subprocess import call
import HTMLParser
h = HTMLParser.HTMLParser()

accent = sys.argv[1]
voice = sys.argv[2]
pitch = sys.argv[3]
echo = sys.argv[4]
speed = sys.argv[5]
text = h.unescape(sys.argv[6])
ckey = sys.argv[7]
type = sys.argv[8]

playervoicespath = "C:/Users/Administrator/Desktop/bs12/sound/playervoices/"
extra2 = ""
extra = ""
if type.find("/carbon/alien") != -1:
	voice = ""
	
	accent = "en-xn"
	
	extra2 = " flanger 0 5 10 100 1 sin 25 overdrive"



	
text = string.replace(text, "39", "'")
text = string.replace(text, "34", "")



if type.find("/silicon/ai") != -1:
	accent = "en-us"
	voice = "+f4"
	speed = 160
	extra = "-k20"
	extra2 = ""
	pitch = 50
	echo = "100"
	said = text.split(" ")
	said2 = []
	sysrandom = random.SystemRandom()
	initrandomnum = int(math.floor(sysrandom.random() * 80))
	randomnum = initrandomnum
	changeback = False
	
	for word in said:
		if text.find("!") != -1:
			pitch = 90
		aiextra = ""
		if(random.randint(1, 10)) > 8:
			ratenum = random.randint(8, 13) / 10
			if ratenum == 1:
				ratenum = ratenum - 0.1
			aiextra = ' rate="{}"'.format(ratenum)

		if(random.randint(1, 10)) > 4:
			randomnum = (sysrandom.random() * 40000 % 40)
			randomnum = int(math.floor(randomnum))
			changeback = True
		word = '<prosody pitch="{}"{}>{}</prosody> '.format(randomnum, aiextra,word)
		if changeback == True and (random.randint(1, 10)) > 5:
			randomnum = initrandomnum + random.randint(-20, 20)
		said2.append(word)
	text = ''.join(said2)
	filepath = "{}{}file.txt".format(playervoicespath,ckey)
	f = open(filepath, "w+")
	f.write(text)
	f.close()
	command = "espeak -m -w {}{}u.wav -v{}{} -f {} -p {} -s {} -a 100 {}".format(playervoicespath, ckey, accent,voice,playervoicespath + "" + ckey+"file.txt",pitch,speed,extra)
elif type.find("/carbon/human") != -1:
	said = text.split(" ")
	said2 = []
	for word in said:
		replacepunc = ["!", "?", "."]
		excludeemph = ["I", "A"]
		randomnum = 50
		changeback = False
		extra = ""
		for punc in replacepunc:
			if word.find(punc) != -1:
				word = word.replace(punc, '')
				word = word + punc
		
		if word.upper() == word:
			if (word in excludeemph):
				x = 1
			else:
				word = '<emphasis level="strong">{}</emphasis>'.format(word)
	
		randomnum = random.randint(97, 105)

	
		word = '<prosody pitch="'+str(randomnum)+'%"{}>{}</prosody> '.format(extra,word)
		said2.append(word)
	text = ' '.join(said2)
	filepath = "{}{}file.txt".format(playervoicespath,ckey)
	f = open(filepath, "w+")
	f.write(text)
	f.close()
	
	command = "espeak -m -w {}{}u.wav -v{}{} -f {} -p {} -s {} -a 100 {}".format(playervoicespath, ckey, accent,voice,playervoicespath + "" + ckey+"file.txt",pitch,speed,extra)
else:
	command = "espeak -m -w {}{}u.wav -v{}{} \"{}\" -p {} -s {} -a 100 {}".format(playervoicespath, ckey, accent,voice,text,pitch,speed,extra)
print(command)
# First we make the voice file, sounds/playervoice/keyu.wav
call(command, shell=True)
print(command)
command2 = "sox "+playervoicespath+""+ckey+"u.wav \""+playervoicespath+""+ckey+".wav\" echo 1 0.5 "+echo+" .5 {}".format(extra2)
# Now we apply effects to it, like echo (there's lots of other effects too)
call(command2, shell=True)
print(command2)
#remove the old keyu.wav
#os.remove("\"{}{}u.wav\"".format(playervoicespath, ckey))
command3 = "OggEnc {}{}.wav".format(playervoicespath, ckey)
#Now we turn key.wav into key.ogg to reduce bandwidth
call(command3, shell=True)
print(command3)
#delete the wav
#os.remove(playervoicespath+""+ckey+".wav")
sys.exit()