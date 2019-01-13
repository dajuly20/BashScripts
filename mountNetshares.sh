#!/bin/bash

#Pi2
HOSTNAME="ControlPi2"
sudo umount /home/julian/homeOnControlPi2
./pingable.sh $HOSTNAME
if [ $? -eq 0 ]
then
echo "Ja"
mkdir /home/julian/homeOnControlPi2
sudo mount -t cifs //$HOSTNAME/julhome/ /home/julian/homeOnControlPi2 -o user=julian,uid=$(id -u),gid=$(id -g)
else
echo "Nein"
fi



#Pi3
HOSTNAME="ControlPi3"
sudo umount /home/julian/homeOnControlPi3

./pingable.sh $HOSTNAME
if [ $? -eq 0 ]
then
echo "Ja"
mkdir /home/julian/homeOnControlPi3
sudo mount -t cifs //$HOSTNAME/julhome/ /home/julian/homeOnControlPi3 -o user=julian,uid=$(id -u),gid=$(id -g)
else
echo "Nein"
fi



#mkdir /home/julian/homeOnControlPi3
#sudo mount -t cifs //controlpi3/julhome/ /home/julian/homeOnControlPi3 -o user=julian,uid=$(id -u),gid=$(id -g)

