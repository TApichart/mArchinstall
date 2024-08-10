#!/usr/bin/bash

if [ "$1" == 'not define' ] ; then
	exit 0
fi

echo "Section \"Monitor\"
	Identifier \"Virtual-1\"
	Option \"PreferredMode\" \"$1\"
	Option \"Primary\" \"1\"
EndSection
" > /etc/X11/xorg.conf.d/01-monitor.conf
