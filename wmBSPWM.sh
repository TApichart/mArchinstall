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

mkdir -p $uSRCFG/{bspwm,sxhkd,polybar,picom,nitrogen}
cp /usr/share/doc/bspwm/examples/bspwmrc $uSRCFG/bspwm
cp /usr/share/doc/bspwm/examples/sxhkdrc $uSRCFG/sxhkd
cp /etc/xdg/picom.conf $uSRCFG/picom
cp /etc/polybar/config.ini $uSRCFG/polybar
chmod +x $uSRCFG/bspwmrc

echo 'pgrep -x picom > /dev/null || picom --config ~/.config/picom/picom.conf &
nitrogen --restore &

# ========== Polybar or Polybar-Themes ========== #
pgrep -x polybar > /dev/null || polybar &' >> $uSRCFG/bspwm/bspwmrc

sed -i 's/bspc rule/#bspc rule/g' $uSRCFG/bspwm/bspwmrc
sed -i 's/urxvt/mate-terminal --hide-menubar/g' $uSRCFG/sxhkd/sxhkdrc

echo 'super + e
	thunar' >> $uSRCFG/sxhkd/sxhkdrc

/root/extNitrogen.sh $sUPERHOME

chown -R $SUPERUSR:users $sUPERHOME
