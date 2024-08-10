#!/usr/bin/bash

declare DESKTYPE='xfce'

if [ ! -d $1 ] ; then
	echo "[$1] is not a directory......!"
	exit 5
fi

sed -i  '/# session=/c\session=startxfce4' /etc/lxdm/lxdm.conf
systemctl enable lxdm
