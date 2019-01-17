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
	SERVER=$1
	GATEWAY=$2
	USER=$3
	DOMAIN=$4
	
	echo -n "Password for $USER:"
	read -s  PASS
	echo
 	if [[ "yes" == $(ask_yes_or_no "Start Fullscreen?") ]]
       	 then
		if [[ "yes" == $(ask_yes_or_no "On all Monitors?") ]]
		then
		FLAGSIZE="/multimon"
		else
		FLAGSIZE="/f"
		fi
	  fi
	
	echo "Connection to srv $SERVER with gateway $GATEWAY user $USER @ $DOMAIN "
	echo "PRESS CTRL + ALT + ENTER to exit fullscreen!"

	xfreerdp /v:$SERVER /g:$GATEWAY /u:$USER /d:$DOMAIN /p:$PASS $FLAGSIZE
}


SERVER="px-365-ts01.intern.px-365.de"
GATEWAY="rg.px-365.de"
USER="julian.wiche"
DOMAIN="intern"
connectRdp  $SERVER $GATEWAY $USER $DOMAIN
