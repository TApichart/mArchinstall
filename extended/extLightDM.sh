#!/usr/bin/bash

declare LIGHTCONF="/etc/lightdm/lightdm.conf"
declare LIGHTGREETER="/etc/lightdm/lightdm-gtk-greeter.conf"

if [ "$DESKTYPE" == "lxqt" ] ; then
	sed -i '/#greeter-session=/c\greeter-session=lightdm-webkit2-greeter' $LIGHTCONF
	sed -i 's/= antergos/= litarvan/g' /etc/lightdm/lightdm-webkit2-greeter.conf
else
	sed -i '/#greeter-session=/c\greeter-session=lightdm-gtk-greeter' $LIGHTCONF
fi
sed -i '/#background=/c\background=/usr/share/backgrounds/archlinux/geowaves.png' $LIGHTGREETER

systemctl enable lightdm
