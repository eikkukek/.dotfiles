#
# ~/.bash_profile
#
#
source ~/.bashrc

if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
	exec sway
fi
