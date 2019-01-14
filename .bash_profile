#show disk usage on logn
echo ""
echo ""
echo `date`
echo ""
echo `uptime`
echo ""
echo "Available Space: (df -h)"
df -h
echo ""
echo "Mounted Devices: (lsblk)" 
lsblk
echo ""
echo "Networking Status: (ifconfig)"
ifconfig
echo "currently logged in: (who)"
who
echo ""
echo "Owncloud Maintenance mode status:"
source ~/.bashrc
#occ maintenance:mode

