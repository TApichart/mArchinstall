#!/usr/bin/bash

if [ ! -d $1 ] ; then
	echo "[$1] is not a directory......!"
	exit 5
fi

echo "source \$VIMRUNTIME/defaults.vim
set number
syntax on
set showmatch
set ruler
set smarttab
set ts=4 sw=4
" > $1/.vimrc
