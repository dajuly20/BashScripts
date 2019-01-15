#!/bin/bash
# check and log if a host is reachable by ping

#CONFIGURATION

#IP of host
WATCH_IP="$1"
#path to logfile
LOGFILE="/home/julian/watchGarten.log"
#duration between pings
PAUSE=3
#how many failed pings before log
TESTS=2

#SCRIPT

#initialize
MISSED=0
touch $LOGFILE
echo `date` " Script Started. " >> $LOGFILE;
while true; do
  if ! ping -c 1 -w 1 $WATCH_IP > /dev/null; then
    ((MISSED++))
  else
    if [ $MISSED -ge $TESTS ]; then
      echo `date` '-' $WATCH_IP "is up again." >> $LOGFILE;
    fi
    MISSED=0
  fi;
  if [ $MISSED -eq $TESTS ]; then
    echo `date` "-" $WATCH_IP "is down." >> $LOGFILE;
  fi
  sleep $PAUSE;
done
