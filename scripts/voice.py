#!/usr/bin/env python2

'''
WINDOWS ONLY!
You need espeak: http://sourceforge.net/projects/espeak/files/espeak/espeak-1.47/espeak-1.47.11-win.zip/download
SOund eXchange (sox): http://sourceforge.net/projects/sox/files/sox/14.4.1/sox-14.4.1a-win32.zip/download
and WinVorbis for OggEnc: http://winvorbis.stationplaylist.com/WinVorbisSetup.exe

'''
import sys, os, re, string
from subprocess import call

accent = sys.argv[1]
voice = sys.argv[2]
pitch = sys.argv[3]
echo = sys.argv[4]
speed = sys.argv[5]
text = sys.argv[6]
ckey = sys.argv[7]

playervoicespath = "C:/Users/Administrator/Desktop/updated/sound/playervoices/"


text = string.replace(text, "39", "'")

command = "espeak -w {}{}u.wav -v{}{} \"{}\" -p {} -s {} -a 100".format(playervoicespath, ckey, accent,voice,text,pitch,speed)

# First we make the voice file, sounds/playervoice/keyu.wav
call(command, shell=True)
print(command)
command2 = "sox "+playervoicespath+""+ckey+"u.wav \""+playervoicespath+""+ckey+".wav\" echo 1 0.5 "+echo+" .5"
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
