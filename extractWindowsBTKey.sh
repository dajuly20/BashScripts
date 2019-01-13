#!/bin/bash
cd /media/julian/Boot/Windows/System32/config/
echo ""
echo ""
echo "https://unix.stackexchange.com/questions/255509/bluetooth-pairing-on-dual-boot-of-windows-linux-mint-ubuntu-stop-having-to-p/255510#255510"
echo ""
rrr='hex \ControlSet001\Services\BTHPORT\Parameters\Keys\1c4d70286873\0cfcae1008a1'
ggg="ggg"
echo "Path $rrr is  $execPath"
echo "Find key for BT Device, then copy into /var/lib/bluetooth/[bth portmacaddresses]/[deviceMac]/info in section key... remove , and speaces"
echo ""
chntpw -e SYSTEM <<< $rrr
