#!/bin/bash

for D in `mount -lt cifs | sed 's/.*on \(\/.\+\) type.*/\1/'`; do 
echo -n "UNMOUNTING $D..."; sudo umount $D; echo " [DONE]"; done;


# e.g. mtnetshare Server2 yourNetShare
# makes folders for shares under ~/smbShares/HOST/share
function mtnetshare {
HOSTNAME=$1
SHARENAME=$2
RP=`realpath ~`
FOLDER="$RP/smbShares/$HOSTNAME/$SHARENAME"
USER=`whoami`
USERID=`id -u`
GID=`id -g`
./pingable.sh $HOSTNAME
if [ $? -eq 0 ]
then
	echo "Ja"
	echo "$FOLDER"
	mkdir -p "$FOLDER"
	sudo mount -t cifs //$HOSTNAME/$SHARENAME/ $FOLDER -o user=$USER,uid=$USERID,gid=$GID
else
	echo "Nein"
fi

}



mtnetshare ControlPi2 julhome

#Pi2
#HOSTNAME="ControlPi2"
#sudo umount /home/julian/homeOnControlPi2
#./pingable.sh $HOSTNAME
#if [ $? -eq 0 ]
#then
#echo "Ja"
#mkdir /home/julian/homeOnControlPi2
#sudo mount -t cifs //$HOSTNAME/julhome/ /home/julian/homeOnControlPi2 -o user=julian,uid=$(id -u),gid=$(id -g)
#else
#echo "Nein"
#fi



#Pi3
#HOSTNAME="ControlPi3Fixed"
#sudo umount /home/julian/homeOnControlPi3#
#
#./pingable.sh $HOSTNAME
#if [ $? -eq 0 ]
#then
#echo "Ja"
#mkdir /home/julian/homeOnControlPi3
#sudo mount -t cifs //$HOSTNAME/julhome/ /home/julian/homeOnControlPi3 -o user=julian,uid=$(id -u),gid=$(id -g)
#else
#echo "Nein"
#fi



#mkdir /home/julian/homeOnControlPi3
#sudo mount -t cifs //controlpi3/julhome/ /home/julian/homeOnControlPi3 -o user=julian,uid=$(id -u),gid=$(id -g)

