#!/bin/bash
# written by Tomas (http://www.lisenet.com)
# 17/01/2014 (dd/mm/yy)
# copyleft free software
#
LOGFILE="/var/log/clamav/clamav-$(date +'%Y-%m-%d').log"; 
EMAIL_MSG="Malware Detected. Please see the log file attached."; 
EMAIL_FROM="clamav-daily@example.com";
EMAIL_TO="cyberwoman99@gmail.com";
DIRTOSCAN="/home/purpleswag/Downloads/Downloads";

# Update ClamAV database
echo "Looking for ClamAV database updates...";
freshclam --quiet;

TODAY=$(date +%u);

if [ "$TODAY" == "6" ];then
 echo "Starting a full weekend scan.";

 # be nice to others while scanning the entire root
 nice -n5 clamscan -ri / --exclude-dir=/sys/ &>"$LOGFILE";
else
 DIRSIZE=$(du -sh "$DIRTOSCAN" 2>/dev/null | cut -f1);

 echo "Starting a daily scan of "$DIRTOSCAN" directory.
 Amount of data to be scanned is "$DIRSIZE".";

 clamscan -ri "$DIRTOSCAN" &>"$LOGFILE";
fi

# get the value of "Infected lines" 
MALWARE=$(tail "$LOGFILE"|grep Infected|cut -d" " -f3); 

# if the value is not equal to zero, send an email with the log file attached 
if [ "$MALWARE" -ne "0" ];then 
  #using heirloom-mailx below 
  echo "$EMAIL_MSG"|mail -A "$LOGFILE" -s "Malware Found; Name: Doreen Joseph; NetID: djoseph4" -r "$EMAIL_FROM" "$EMAIL_TO"; 
fi 
exit 0
