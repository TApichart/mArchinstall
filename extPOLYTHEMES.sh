#!/usr/bin/bash

if [ ! -d $1 ] ; then
	echo "[$1] is not a directory......!"
	exit 5
fi

declare sUPERHOME="$1"
declare uSRCFG="$sUPERHOME/.config"
declare SUPERUSR="$(echo "$1" | cut -d'/' -f 3)"

# Polybar-Themes
pushd $PWD
cd /opt
git clone https://aur.archlinux.org/networkmanager-dmenu-git.git
git clone https://github.com/adi1090x/polybar-themes.git
popd
chown -R $SUPERUSR:users /opt/{networkmanager-dmenu-git,polybar-themes}
su -c 'cd /opt/networkmanager-dmenu-git ; makepkg -s' - $SUPERUSR
pacman --noconfirm -U /opt/networkmanager-dmenu-git/*.tar.zst
mv $uSRCFG/polybar $uSRCFG/polybar.0
mkdir -p /usr/local/share/{fonts,backgrounds} $uSRCFG/{polybar,mpd/playlists}
cp -fr /opt/polybar-themes/fonts/* /usr/local/share/fonts
cp -fr /opt/polybar-themes/wallpapers/* /usr/local/share/backgrounds
cp -rf /opt/polybar-themes/simple/* $uSRCFG/polybar
cp -rf /opt/polybar-themes/bitmap/hack/* $uSRCFG/polybar/hack
cp -rf /opt/polybar-themes/bitmap/shades/* $uSRCFG/polybar/shades
cp -rf /opt/polybar-themes/bitmap/shapes/* $uSRCFG/polybar/shapes

/root/extMPD.sh $sUPERHOME
