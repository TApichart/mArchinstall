#!/usr/bin/bash

if [ ! -d $1 ] ; then
	echo "[$1] is not a directory......!"
	exit 5
fi

declare sUPERHOME="$1"
declare bGDIR="/usr/share/backgrounds/archlinux"
declare nCFG="$sUPERHOME/.config/nitrogen"

echo "[xin_-1]
file=$bGDIR/awesome.png
mode=4
bgcolor=#000000
" > $nCFG/bg-save.cfg

echo "[geometry]
posx=0
posy=0
sizex=516
sizey=500

[nitrogen]
view=icon
recurse=true
sort=alpha
icon_caps=false
dirs=$bGDIR;
" > $nCFG/nitrogen.cfg
