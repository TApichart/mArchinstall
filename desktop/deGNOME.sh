#!/usr/bin/bash

declare DESKTYPE="gnome"

if [ ! -d $1 ] ; then
	echo "[$1] is not a directory......!"
	exit 5
fi

# source /root/extGDM.sh
source /root/extLightDM.sh

