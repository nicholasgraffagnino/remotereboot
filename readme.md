Remote Reboot
=============
### for Linux/Mac

Reboot your PC while away from home.

Ever had the need to reboot your computer while away? Remote Reboot is a bash script that periodically checks a web page for a value of 0 or 1 to determine if it should reboot the local computer.

When you want the computer to reboot, just upload a new web page with the contents: 1
For all other cases, upload a web page with the contents: 0

Remote Reboot will read from any url you configure. So, feel free to get creative. You can use a hosted file on Dropbox, Github, Google Drive, your web site, etc.

In between checks of the web page, Remote Reboot goes to sleep. From Monday to Friday during business hours, it will check the web page every hour. Outside of business hours, it will check every 2 hours. On weekends, it will check every 8 hours. Customize these sleep intervals as you like.

Install
---

1. Download [remotereboot.sh](https://raw.githubusercontent.com/primaryobjects/remotereboot/master/remotereboot.sh) and place it in a folder, such as ~/Documents/remotereboot.

2. Edit the file and fill in values for the following variables at the top:

 ```sh
 # User-defined variables.
 url="https://dl.dropboxusercontent.com/u/...YOUR_FILE_HERE...txt"
 logglyUrl=""
 ```

3. Save the file and run it with:
 ```sh
 cd ~/Documents/remotereboot
 sudo bash remotereboot.sh &
 ```

The script will sleep until the desired number of seconds has elapsed. It will then download the web page and check for a value of "1". If found, it will reboot the computer.

If a value is provided for logglyUrl, it will send an HTTP POST to log the action before rebooting.

Running at Startup
---

You can automatically run the script at boot time by editing /etc/rc.local and adding an entry to run the script. It's a good idea to include logging of the output, so you know it's working. Don't forget the ampersand at the end of the command, as this allows it to run in its own thread, as a background service.

1. Edit /etc/rc.local and add the following lines towards the top of the file:
 ```sh
 # Log rc.local to tmp/rc.local.log
 exec 2> /tmp/rc.local.log      # send stderr from rc.local to a log file
 exec 1>&2                      # send stdout to the same log file
 set -x
 
 bash "/home/username/Documents/remotereboot/remotereboot.sh" &
 ```

License
----

MIT

Author
----
Kory Becker
http://www.primaryobjects.com/kory-becker
