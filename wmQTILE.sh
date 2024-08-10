#!/usr/bin/bash

declare DESKTYPE="bspwm"

if [ ! -d $1 ] ; then
	echo "[$1] is not a directory......!"
	exit 5
fi

declare sUPERHOME="$1"
declare uSRCFG="$sUPERHOME/.config"
declare SUPERUSR="$(echo "$1" | cut -d'/' -f 3)"

source /root/extLightDM.sh

mkdir -p $uSRCFG/{nitrogen,picom} 
cp /etc/xdg/picom.conf $uSRCFG/picom/
echo "killall -9 picom
nitrogen --restore &
picom --config ~/.config/picom/picom.conf &" > $sUPERHOME/.xprofile

/root/extNitrogen.sh $sUPERHOME

chown -R $SUPERUSR:users $sUPERHOME
