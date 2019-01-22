#!/bin/bash
function ask_yes_or_no() {
    read -p "$1 ([y]es or [N]o): "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo "yes" ;;
        *)     echo "no" ;;
    esac
}

echo "Diff for .bash_profile: (If empty no difference)"
git diff ../.bash_profile .bash_profile
echo 
echo 
echo "Diff for .bashrc: (If empty no difference)"
git diff ../.bashrc .bashrc
echo 

if [[ "yes" == $(ask_yes_or_no "REMOVE ~/.bashrc and ~/.bash_profile and replace by link to files in this repo?") ]]
         then

	rm ~/.bashrc
	ln .bashrc ~/.bashrc

	rm ~/.bash_profile
	ln .bash_profile ~/.bash_profile
	fi
