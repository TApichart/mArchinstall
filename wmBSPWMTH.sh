#!/usr/bin/bash

declare DESKTYPE="bspwm"

if [ ! -d $1 ] ; then
	echo "[$1] is not a directory......!"
	exit 5
fi

declare sUPERHOME="$1"
declare uSRCFG=$sUPERHOME/.config
declare SUPERUSR="$(echo "$1" | cut -d'/' -f 3)"

/root/wmBSPWM.sh $sUPERHOME

sed -i '/pgrep -x polybar/c\~/.config/polybar/launch.sh --forest' $uSRCFG/bspwm/bspwmrc

# ====  Insert Media player to BSPWM cofig  ==== #
echo '# ======== Media Player ========
[ ! -s ~/.config/mpd/pid ] && mpd
mpc clear ; mpc add /
' >> $uSRCFG/bspwm/bspwmrc

/root/extPOLYTHEMES.sh $sUPERHOME

chown -R $SUPERUSR:users $sUPERHOME
