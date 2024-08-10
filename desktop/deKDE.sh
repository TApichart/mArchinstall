#!/usr/bin/bash

declare DESKTYPE='kde'

if [ ! -d $1 ] ; then
	echo "[$1]  is not a directory......!"
	exit 5
fi

source /root/extSDDM.sh
