#show disk usage on logn
echo ""
echo ""
echo `date`
echo ""
echo `uptime`
echo ""
echo "--------------------------"
echo "Available Space: (df -h)"
df -h
echo ""
echo "--------------------------"
echo "Mounted Devices: (lsblk)" 
lsblk
echo ""
echo "--------------------------"
echo "Networking Status: (ifconfig)"
ifconfig
echo "--------------------------"
echo "currently logged in: (who)"
who
echo "--------------------------"
echo "Aktive TMux sitzungen"
echo ""
tmux ls
echo ""
echo "TODO: "
echo "--------------------------"
cat -n ~/.TODO
echo "--------------------------"
echo ""
echo "What Distro is this?"
echo "---------------------------"
cat /etc/os-release
echo "--------------------------"
source ~/.bashrc
#occ maintenance:mode
