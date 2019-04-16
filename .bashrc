# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups



  BLACK="\[\033[0;30m\]"
  DARK_GREY="\[\033[1;30m\]"
  RED="\[\033[0;31m\]"
  LIGHT_RED="\[\033[1;31m\]"
  GREEN="\[\033[0;32m\]"
  LIGHT_GREEN="\[\033[1;32m\]"
  BROWN="\[\033[0;33m\]"
  YELLOW="\[\033[1;33m\]"
  BLUE="\[\033[0;34m\]"
  LIGHT_BLUE="\[\033[1;34m\]"
  DARK_PURPLE="\[\033[0;35m\]"
  LIGHT_PURPLE="\[\033[1;35m\]"
  DARK_CYAN="\[\033[0;36m\]"
  LIGHT_CYAN="\[\033[1;36m\]"
  LIGHT_GREY="\[\033[0;37m\]"
  WHITE="\[\033[1;37m\]"
  COLOR_NONE="\[\e[0m\]"

#Searches for string in directory (findStr . "bla") 
function findStr () {
if [ -z $1 ]; then
echo "usage: ${FUNCNAME[0]} ./dir \"Needle\""
return 1
fi
grep -rnw $1 -e $2
}


 function is_svn_repository {
	svn info > /dev/null 2> /dev/null 
	ERR=$?
	if [ $ERR -ne 0 ];then
	    return 1
	else
	    return 0
	fi
  }

function umountAllSmb {
	for D in `mount -lt cifs | sed 's/.*on \(\/.\+\) type.*/\1/'`; do 
	echo -n "UNMOUNTING $D..."; sudo umount $D; echo " [DONE]"; done;
}


function pingable {
	
INSTD=`which fping`
	[ -z "$INSTD" ] && echo "Install fping (apt-get install fping)!"
	[ -z $1 ] && echo "IP not specified!" 

	IP=$1
	fping -c1 -t300 $IP 2>/dev/null 1>/dev/null
	if [ "$?" = 0 ]
	then
		echo "Found Host $1"
	 	return 0
	else
		echo "Host $1 not found"
		return 1

	fi
}

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
        pingable $HOSTNAME
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

function mtnetshares {

#unmounts all shares
umountAllSmb
# Mounts shares only if host is avaliable
mtnetshare ControlPi2 julhome
mtnetshare ControlPi3 julhome
mtnetshare ControlPi3fixed julhome

}


function parse_svn_dirty (){
	local status=$(svn status)
	local ADD=`echo -n "${status}" 2> /dev/null | grep "A\s" &> /dev/null; echo "$?"`
	local DELETE=`echo -n "${status}" 2> /dev/null | grep "D\s" &> /dev/null; echo "$?"`
	local MODIFIED=`echo -n "${status}" 2> /dev/null | grep "M\s" &> /dev/null; echo "$?"`
	local REPLACED=`echo -n "${status}" 2> /dev/null | grep "R\s" &> /dev/null; echo "$?"`
	local CHANGED=`echo -n "${status}" 2> /dev/null | grep "C\s" &> /dev/null; echo "$?"`
	local EXTERNAL=`echo -n "${status}" 2> /dev/null | grep "X\s" &> /dev/null; echo "$?"`
	local MISSING=`echo -n "${status}" 2> /dev/null | grep "I\s" &> /dev/null; echo "$?"`
	local NOTVERSIONED=`echo -n "${status}" 2> /dev/null | grep "?\s" &> /dev/null; echo "$?"`
	local IGNORED=`echo -n "${status}" 2> /dev/null | grep "!\s" &> /dev/null; echo "$?"`
	local whatever=`echo -n "${status}" 2> /dev/null | grep "~\s" &> /dev/null; echo "$?"`
	bits=''
	if [ "${ADD}" == "0" ]; then
		bits="A${bits}"
	fi
	if [ "${DELETE}" == "0" ]; then
		bits="D${bits}"
	fi
	if [ "${MODIFIED}" == "0" ]; then
		bits="M${bits}"
	fi
	if [ "${REPLACED}" == "0" ]; then
		bits="R${bits}"
	fi
	if [ "${CHANGED}" == "0" ]; then
		bits="C${bits}"
	fi
	if [ "${EXTERNAL}" == "0" ]; then
		bits="I${bits}"
	fi
	if [ "${MISSING}" == "0" ]; then
		bits="I${bits}"
	fi
	if [ "${NOTVERSIONED}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${IGNORED}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ "${whatever}" == "0" ]; then
		bits="~${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${RED}${bits}${COLOR_NONE}"
	else
		echo ""
	fi
}

parse_svn() {
    SVN_PROMT=""
    if is_svn_repository ; then
        local SVN_REV=$(svn info | awk '/Revision:/ {print $2}')
        local STAT=`parse_svn_dirty`
        SVN_PROMT="${LIGHT_CYAN}SVN[${SVN_REV}${COLOR_NONE}${STAT}${LIGHT_CYAN}]${COLOR_NONE}"
    fi
}
 function is_git_repository {
  git branch > /dev/null 2>&1
}
# get current branch in git repo
function parse_git_branch() {
GIT_PROMT=""
        if is_git_repository ; then
	   BRANCH=`LANG=en git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	   if [ ! "${BRANCH}" == "" ]
	   then		
		local STAT=`parse_git_dirty`
		GIT_PROMT="${LIGHT_CYAN}GIT[${BRANCH}${COLOR_NONE}${STAT}${LIGHT_CYAN}]${COLOR_NONE}"
	   fi
	fi
}

# get current status of git repo
function parse_git_dirty (){
	status=`LANG=en git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${RED}${bits}${COLOR_NONE}"
	else
		echo ""
	fi
}
# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_error_symbol () {
  if test $1 -eq 0 ; then
      ERROR_SYMBOL=""
  else
      ERROR_SYMBOL="${RED}X${COLOR_NONE}"
  fi
}

function set_user () {
  USER_PROMT="\u"
  if [ $(id -u) -eq 0 ];
  then
  USER_PROMT="${LIGHT_RED}\u${COLOR_NONE}"
  else
  USER_PROMT="${LIGHT_GREEN}\u${COLOR_NONE}"
  fi
}

function set_host () {
HOST_PROMT="@\h"
    if [ $(hostname) = "julian-laptop" ];
    then
      HOST_PROMT="${GREEN}@\h${COLOR_NONE}"
    elif [ $(hostname) = "owncloud" ];
    then
      HOST_PROMT="${LIGHT_BLUE}@\h${COLOR_NONE}"
    elif [ $(hostname) = "raspberry" ];
    then
      HOST_PROMT="${YELLOW}@\h${COLOR_NONE}"
    fi
}

function set_path () {
  PATH_PROMT="${LIGHT_PURPLE}\w${COLOR_NONE}"
}

# Set the full bash prompt.
function set_bash_prompt () {
  # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the 
  # return value of the last command.
  set_error_symbol $?
  parse_git_branch
  parse_svn
  set_user
  set_host
  set_path
  # Set the bash prompt variable.
  PS1="${ERROR_SYMBOL}${USER_PROMT}${HOST_PROMT}${GIT_PROMT}${SVN_PROMT}${PATH_PROMT}${BROWN}\\$\[\e[m\] "
}




function proxy_on() {
    export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"

    if (( $# > 0 )); then
        valid=$(echo $@ | sed -n 's/\([0-9]\{1,3\}.\)\{4\}:\([0-9]\+\)/&/p')
        if [[ $valid != $@ ]]; then
            >&2 echo "Invalid address"
            return 1
        fi

        export http_proxy="http://$1/"
        export https_proxy=$http_proxy
        export ftp_proxy=$http_proxy
        export rsync_proxy=$http_proxy
        echo "Proxy environment variable set."
        return 0
    fi

    echo -n "username: "; read username
    if [[ $username != "" ]]; then
        echo -n "password: "
        read -es password
        local pre="$username:$password@"
    fi

    echo -n "server: "; read server
    echo -n "port: "; read port
    export http_proxy="http://$pre$server:$port/"
    export https_proxy=$http_proxy
    export ftp_proxy=$http_proxy
    export rsync_proxy=$http_proxy
    export HTTP_PROXY=$http_proxy
    export HTTPS_PROXY=$http_proxy
    export FTP_PROXY=$http_proxy
    export RSYNC_PROXY=$http_proxy
}

function proxy_off(){
    unset http_proxy
    unset https_proxy
    unset ftp_proxy
    unset rsync_proxy
    echo -e "Proxy environment variable removed."
}



# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt





# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1       ;;
             *.rar)       rar x $1     ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1        ;;
             *.tbz2)      tar xjf $1      ;;
             *.tgz)       tar xzf $1       ;;
             *.zip)       unzip $1     ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

alias rm='set -f; myrm' #set -f turns off wildcard expansion need to do it outside of           
                        #the function so that we get the "raw" string.
myrm() {
    ARGV="$*"
    set +f #opposite of set -f
    if echo "$ARGV" | grep -e '-rf /*' \
                           -e 'add more here'
    then
        echo "omg du Depp was machst du!!!"
        return 1
    else
        /bin/rm $@
    fi
}



# Directory navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias grep='grep --color=tty'
alias fgrep='fgrep --color=tty'
alias egrep='egrep --color=tty'
#alias make='colormake'
alias ll='ls -la'
alias llm='ll --block-size=M'
alias llg='ll --block-size=G'
alias cp='cp -v'
alias mspaint='pinta'
alias paint='pinta'
alias google-chrome='chromium'
alias ddstatus='watch -n5 "sudo kill -USR1 $(pgrep ^dd)"'
alias firefoxY='~/bashTools/openProxy9001.sh'

alias suspend='systemctl suspend'
alias ruhezustand='systemctl suspend'
alias calc="gnome-calculator"

bind 'set completion-ignore-case on'


netinfo ()
{
echo "--------------- Network Information ---------------"
/sbin/ifconfig | awk /'inet addr/ {print $2}'
/sbin/ifconfig | awk /'Bcast/ {print $3}'
/sbin/ifconfig | awk /'inet addr/ {print $4}'
/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
myip=`lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' `
echo "${myip}"
echo "---------------------------------------------------"
}

remind ()
{
echo "---tar:---"
echo "Erstellen von Ordner: tar cfz name.tar.gz ordner"
echo "Erstellen von file: tar cf name.tar *.txt"
echo "Entpacken: tar xfz name.tar.gz "
echo "---Mounten:---"
echo "Mount Iso: sudo mount -o /home/dominic/meiniso /mnt/temp"
echo "Iso erstellen: mkisofs -o /tmp/cd.iso /tmp/directory/"
echo "HS-Laufwerk: \\\studsrv09.stud.ad.fh-pforzheim.de\poeschko"
echo "Device Name: lsblk -p"
}

function srch() {
    grep --color=tty -Ri $1 * | grep --color=tty -v "\.svn" | grep --color=tty -v "\.log"
}

#dirsize - finds directory sizes and lists them for the current directory
dirsize ()
{
du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
egrep '^ *[0-9.]*M' /tmp/list
egrep '^ *[0-9.]*G' /tmp/list
rm -rf /tmp/list
}

#copy and go to dir
cpg (){
  if [ -d "$2" ];then
    cp $1 $2 && cd $2
  else
    cp $1 $2
  fi
}

#move and go to dir
mvg (){
  if [ -d "$2" ];then
    mv $1 $2 && cd $2
  else
    mv $1 $2
  fi
}
#mkdir and change
function mkcd () {
  mkdir -p "$1"
    cd "$1"
}

#coloring man pages
man() {
        env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
    }


# Set new programs and path variable
alias cubemx='java -cp /opt/STM32CubeMX/ com.st.microxplorer.maingui.IOConfigurator'

PATH=$PATH:/opt/eagle-7.5.0/bin
export PATH
PATH=$PATH:/opt/matlab/bin
export ANDROID_HOME=~/Android/Sdk
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export PATH


alias occ='sudo -u www-data php /usr/share/owncloud/occ'

function largestPakets () {
dpkg-query -Wf 'Size\t\n' | sort -n
}
