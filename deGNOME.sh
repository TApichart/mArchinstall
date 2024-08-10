#!/usr/bin/bash

declare DESKTYPE="gnome"

if [ ! -d $1 ] ; then
	echo "[$1] is not a directory......!"
	exit 5
fi

#sed -i 's/#Wayland/Wayland/g' /etc/gdm/custom.conf

systemctl enable gdm
