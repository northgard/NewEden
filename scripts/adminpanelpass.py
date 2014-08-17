#!/usr/bin/env python2
import _mysql, sys
passwordhash = sys.argv[1]
key = _mysql.escape_string(sys.argv[2].lower())
gamepath = "C:/Users/Administrator/Desktop/bs12"

db=_mysql.connect("localhost","root","root","eden")
db.query("""SELECT * FROM `admin` WHERE `ckey`='{}'""".format(key))
result = db.store_result()
admintext = open('{}/config/admins.txt'.format(gamepath), 'r')
adminlist = admintext.read().split("\n")
admindict = {}
for admin in adminlist:
	templist = admin.split(" - ")
	templist[0] = templist[0].lower()
	templist[1] = templist[1].lower().replace(" ", "")
	admindict[templist[0]] = templist[1]
if(key in admindict):
	rank = admindict[key]
else:
	rank = "Player"
if(result.num_rows() == 0):
	db.query("""INSERT INTO admin(ckey,rank,password) VALUES('{}','{}','{}');""".format(key,rank,passwordhash))
else:
	db.query("""UPDATE admin SET password='{}' WHERE ckey='{}'""".format(passwordhash,key))


