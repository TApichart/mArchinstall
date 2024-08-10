#!/usr/bin/bash

declare DESKTYPE="i3wm"

if [ ! -d $1 ] ; then
	echo "[$1] is not a directory......!"
	exit 5
fi

declare sUPERHOME="$1"
declare uSRCFG="$sUPERHOME/.config"
declare SUPERUSR="$(echo "$1" | cut -d'/' -f 3)"

source /root/extSDDM.sh

/root/extPOLYTHEMES.sh $sUPERHOME

mkdir -p $uSRCFG/{i3,picom} ; cp /etc/i3/config $uSRCFG/i3
cp /etc/xdg/picom.conf $uSRCFG/picom
cp /etc/polybar/config.ini $uSRCFG/polybar
cp /etc/i3blocks.conf $sUPERHOME/.i3blocks.conf
cp /etc/i3status.conf $sUPERHOME/.i3status.conf
chmod 600 $sUPERHOME/.i3*.conf
sed -i 's/i3-sensible-terminal/alacritty/g' $uSRCFG/i3/config
/root/extMPD.sh $sUPERHOME
sed -i '/font pango:monospace/c\set $mod Mod4\nfont pango:monospace 8' $uSRCFG/i3/config
sed -i 's/Mod1/$mod/g' $uSRCFG/i3/config
sed -i '/exec i3-config/c\exec_always ~/autorun.sh' $uSRCFG/i3/config

#### Create   autorun.sh #####
echo "#!/usr/bin/bash

picom --config ~/.config/picom/picom.conf &
feh --bg-fill /usr/local/share/backgrounds/bg_3.jpg &
~/.config/polybar/launch.sh --blocks &

[ ! -s ~/.config/mpd/pid ] && mpd
mpc clear ; mpc add / " > $sUPERHOME/autorun.sh
#### ---- autorun.sh ---- #####
chmod 700 $sUPERHOME/autorun.sh

chown -R $SUPERUSR:users $sUPERHOME
