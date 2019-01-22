#!/bin/bash
function ask_yes_or_no() {
    read -p "$1 ([y]es or [N]o): "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo "yes" ;;
        *)     echo "no" ;;
    esac
}

function connectRdp() {
#	SERVER="px-365-ts01.intern.px-365.de"#
#	GATEWAY="rg.px-365.de"
#	USER="julian.wiche"
#	DOMAIN="intern"
#	FLAGSIZE=""
	LNXUSER=`whoami`
	SERVER=$1
	GATEWAY=$2
	USER=$3
	DOMAIN=$4
        DRIVENAME="RDP-SHARED-HOME-$LNXUSER,/home/$LNXUSER"
	echo $DRIVENAME
	echo -n "Password for $USER:"
	read -s  PASS
	echo
 	if [[ "yes" == $(ask_yes_or_no "Start Fullscreen?") ]]
       	 then
		if [[ "yes" == $(ask_yes_or_no "On all Monitors?") ]]
		then
		FLAGSIZE="/multimon"
		else
		xfreerdp /monitor-list
		read -p "Monitors? (e.g. 0,1,2)" MONITORS	
		FLAGSIZE="/f /monitors:$MONITORS /multimon"
		fi
	  fi
	
	echo "Connection to srv $SERVER with gateway $GATEWAY user $USER @ $DOMAIN $FLAGSIZE "
	echo "PRESS CTRL + ALT + ENTER to exit fullscreen!"

	xfreerdp +clipboard /v:$SERVER /g:$GATEWAY /u:$USER /d:$DOMAIN /p:$PASS $FLAGSIZE /sound /drive:auto,* /drive:$DRIVENAME &
}


SERVER="px-365-ts01.intern.px-365.de"
GATEWAY="rg.px-365.de"
USER="julian.wiche"
DOMAIN="intern"
connectRdp  $SERVER $GATEWAY $USER $DOMAIN
