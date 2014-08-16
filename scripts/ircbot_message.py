#!/usr/bin/env python2
import socket
import time
import threading
import urlparse
import urllib
import random
import HTMLParser
import json
import re
adminhelps = []
identified = False
identify = time.time() + 1.2
class AdminHelp():
	def __init__(self, key, pointer):
		self.id = random.randint(100000, 999999)
		self.key = key
		self.pointer = pointer
		sendMessage("#admin", "ID of help from "+ self.key +" is: "+ str(self.id) +".")
	
	def getKey(self):
		return self.key
		
	def getID(self):
		return self.id
	def getPointer(self):
		return self.pointer
class IRCThread(threading.Thread):
	def __init__(self, ip, port):
		threading.Thread.__init__(self)
		self.ip = ip
		self.port = port
		print "[+] New thread started for IRC"
		irc.connect((ip, port))

		irc.send("PASS %s\r\n" % (password))

		irc.send("USER "+ botnick +" "+ botnick +" "+ botnick +" :edenbot\r\n")

		irc.send("NICK "+ botnick +"\r\n")
	def run(self):
		global identify
		global identified
		while 1:
			text=irc.recv(2040)
			print text
			
			# Prevent Timeout
			
			text2 = text.split('\n')
			
			ParseIRC(text2)
		

class ClientThread(threading.Thread):

	def __init__(self):
		print "[+] New thread started for UDP"
		self.serversocket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
		#bind the socket to a public host,
		# and a well-known port
		self.serversocket.bind(("127.0.0.1", 8019))
		threading.Thread.__init__(self)
	def run(self):	
		while 1:
			try:
				data, addr = self.serversocket.recvfrom( 1024 ) # buffer size is 1024 bytes
				print data, addr
			except:
				print "except"
		
threads = []
## Settings
### IRC
server = "127.0.0.1"
port = 6667
channel = "#Eden"
botnick = "EdenBot"
password = ""


irc = socket.socket(socket.AF_INET, socket.SOCK_STREAM) #defines the socket

connection = None

print "Establishing connection to [%s]" % (server)
# Connect


opped = False

identify = time.time() + 5

admincommands ={"var":{"USAGE: @key/@ID var nameofvar = some value", "EXAMPLE: @jaggerestep var hallucinations 5000"},
"proc":{"USAGE: (ADVANCED) @key/@ID proc nameofproc argument1;;argument2;;etc", "EXAMPLE: @jaggerestep proc damage_organs 100;;75 (Does 100 brute and 75 burn damage.)"},
"getvar":{"USAGE: @key/@ID getvar varname", "EXAMPLE: @jaggerestep getvar x (PMs you the value of the \"x\" variable."},
"attacklog":{"USAGE: @key/@ID attacklog", "PMs you the attack log of the player. Same thing as using \"getvar attack_log\""}
}

def sendMessage(channel, message):
	message = re.sub('<[^<]+?>', '', message)
	print "PRIVMSG "+channel+" "+message+" \r\n"
	irc.send("PRIVMSG "+channel+" "+message+" \r\n")

def ParseIRC(txt):
	for text in txt:
		type = "general"
		if text == '':
			return
		if text.find(':You are already identified') != -1:
			global identified 
			identified = True
		if text.find('PRIVMSG ') != -1:
			msg = text[text.find(":", 5) + 1:]
			nick = text[1:text.find("!")]
			hostname = text[text.find("@")+1:text.find(" PRIVMSG")]
			channel = text[text.find("PRIVMSG ") + 8:text[2:].find(":") + 1]
			if channel == "#admin":
				if msg[:3] == "!pm" or msg[:3] == "/pm":
					name = msg[4:msg.find(" ", 5)]
					commanddict = {"command":"pm", "message":"<font color=\"blue\">IRC PM From "+ nick +": "+ msg[msg.find(" ", 5) + 1:] +"</font>", "name":name}
					sendCommand(commanddict)
				elif msg[:5] == "!help" or msg[:5] == "/help":
					cmd = msg[7:]
					if cmd == None or cmd == "":
						sendMessage(nick, "HELP:")
						for adm in admincommands:
							helplist = admincommands[adm]
							sendMessage(nick, "COMMAND: " + adm)
							for line in helplist:
								sendMessage(nick, line)
							sendMessage(nick, "*******************")
					else:
						if cmd in admincommands:
							sendMessage(nick, "COMMAND: " + cmd)
							for line in admincommads[cmd]:
								sendMessage(nick, line)
							sendMessage(nick, "*******************")
				elif msg[0] == "@":
					thehelp = None
					pointer = ""
					if msg[1:7].isdigit():
						for adm in adminhelps:
							if adm.getID() == int(msg[1:7]):
								thehelp = adm
						if thehelp != None:
							pointer = thehelp.getPointer()
					else:
						pointer = msg[1:msg.find(" ")]
						
					if pointer != "":
						thecommand = msg[msg.find(" ") + 1:-1]
					
						if thecommand != "":
							commandlist = thecommand.split(" ")
							print commandlist
							if commandlist[0] == "revive":
								commanddict = {"command":"proc", "procname":"revive","pointer":pointer}
								sendCommand(commanddict)
							if commandlist[0] == "var":
								varname = commandlist[1]
								i=2
								value = ""
								while i < len(commandlist):
									if commandlist[i] == "=":
										i = i + 1
										continue
									value = value + commandlist[i] + " "
									i = i + 1
								value = value[:-1]
								commanddict = {"command":"var", "varname":varname,"pointer":pointer,"value":value}
								print commanddict
								sendCommand(commanddict)
							if commandlist[0] == "proc":
								procname = commandlist[1]
								i=2
								value = ""
								while i < len(commandlist):
									value = value + commandlist[i] + " "
									i = i + 1
								value = value[:-1]
								commanddict = {"command":"proc", "procname":procname,"pointer":pointer,"args":value}
								print commanddict
								sendCommand(commanddict)
							if(commandlist[0] == "getvar"):
								varname = commandlist[1]
								commanddict = {"command":"getvar", "varname":varname,"pointer":pointer,"nick":nick}
								print commanddict
								sendCommand(commanddict)
							if(commandlist[0] == "attacklog" or commandlist[0] == "attack") or commandlist[0] == "attack_log":
								commanddict = {"command":"getvar", "varname":"attack_log","pointer":pointer,"nick":nick}
								print commanddict
								sendCommand(commanddict)
				else:
					if nick != "EdenBot":
						commanddict = {"command":"msay", "name":"MSAY ("+nick+")","message":msg}
						print commanddict
						sendCommand(commanddict)
			if channel == "EdenBot":
				channel = nick
			if channel == "#ooc" and nick != "EdenBot":
				commanddict = {"command":"ooc", "message":msg, "name":nick}
				sendCommand(commanddict)
			if nick == "jagger" and msg[0:6] == "repeat":
				#sendMessage(channel, msg[7:])
				sendMessage(channel, msg[7:])
		if text.find('NOTICE EdenBot :Password accepted') != -1:
			opped = True
		if text.find('PING :') != -1:
			if text.split('PING ') and len(text.split('PING ')) > 0:
				print 'PONG ' + text.split('PING ') [1] + '\r\n'
				irc.send('PONG ' + text.split('PING ') [1] + '\r\n')

ircthread = IRCThread("127.0.0.1", 6667)
ircthread.start()
h = HTMLParser.HTMLParser()
def processCommand(command):
	print command["command"][0]
	if command["command"][0] == "ooc":
		sendMessage("#ooc", h.unescape(command["message"][0]))
	if command["command"][0] == "ahelp":
		command["key"][0] = command["key"][0][:-1]
		sendMessage("#admin", h.unescape(command["message"][0]))
		adminhobj = AdminHelp(command["key"][0], command["pointer"][0])
		adminhelps.append(adminhobj)
	if command["command"][0] == "privmsg":
		message = h.unescape(command["message"][0])
		if command["nick"][0] == "#admin" and message[:9] == "ADMIN LOG":
			command["nick"][0] = "#adminlog"
		sendMessage(command["nick"][0], message)
	if command["command"][0] == "getvar":
		message = command["message"][0]
		if message.find("{") != -1 and message.find("}") != -1 and message.find(":") != -1:
			message = json.loads(message)
		else:
			message = {command["varname"]:message}
		print(message)
		for msg in message:
			sendMessage(command["nick"][0], str(msg) + " = " + str(message[msg]))
		
def sendCommand(command):
	params = urllib.urlencode(command)

	f = open("scripts/commands.txt", "a")
	f.write(params + "\n")
	f.close
while True:
	time.sleep(0.5)
	
	if time.time() >= identify:
		if identified == False:
			irc.send('OPER admin aA28KsiA82ociB\r\n')
			irc.send('PRIVMSG NickServ REGISTER 12asf8fwa83fasd jagger.estep@gmail.com \r\n')
			irc.send('PRIVMSG NickServ IDENTIFY 12asf8fwa83fasd \r\n')
			irc.send('JOIN #ooc,#Eden,#admin,#adminlog,#attacklog \r\n')

		f = open('scripts/irccommands.txt', "r+")
		for line in f:
			
			parsed = urlparse.parse_qs(line)
			print parsed
			processCommand(parsed)
		f.seek(0)
		f.truncate()
		f.close()