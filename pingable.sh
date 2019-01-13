#!/bin/bash
INSTALLED=`which fping`
[ -z "INSTALLED" ] && echo "fping not installed!"
[ -z $1 ] && echo "IP not specified!" && exit 1

IP=$1
fping -c1 -t300 $IP 2>/dev/null 1>/dev/null
if [ "$?" = 0 ]
then
  echo "Found Host $1"
  exit 0
else
  echo "Host $1 not found"
  exit 1
fi
