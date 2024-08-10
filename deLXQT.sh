#!/usr/bin/bash

declare DESKTYPE="lxqt"

if [ ! -d $1 ] ; then
	echo "[$1] is not a directory......!"
	exit 5
fi

declare sUPERHOME="$1"

source /root/extLightDM.sh
sed -i 's/icon_theme=oxygen/icon_theme=Adwaita/g' /usr/share/lxqt/lxqt.conf
#sed -i '/icon_theme=/c\icon_theme=breeze-dark' /usr/share/lxqt/lxqt.conf
