/client/proc/setPassword()
	set category = "Admin"
	set name = "Adminpanel Password"
	var/passwordplain = input("Type a password for your admin panel on the site. It is stored as an md5 hash, with no plaintext anywhere.",
                    "Password",
                    "")

	var/password = md5(passwordplain)
	ext_python("adminpanelpass.py", "\"[password]\" \"[usr.ckey]\"")
	usr << "[usr.ckey], your password has been set. You may now login at <a href=\"http://newedenstation.com/admin/\">http://newedenstation.com/admin/</a>"