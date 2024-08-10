#!/usr/bin/bash

declare DESKTYPE="openbox"
declare PERLLINUX="perl-linux-desktopfiles"
declare OBMENU="obmenu-generator"

if [ ! -d $1 ] ; then
	echo "[$1] is not a directory......!"
	exit 5
fi

declare sUPERHOME="$1"
declare uSRCFG="$sUPERHOME/.config"
declare SUPERUSR="$(echo "$1" | cut -d'/' -f 3)"

aPPEND1="    {beg => ['Shutdown-Menu', 'open-menu-symbolic']}, \n        {item => ['poweroff -i', 'Shutdown', 'system-shutdown-symbolic']}, \n        {item => ['reboot', 'Restart', 'view-refresh-symbolic']}, \n        {exit => ['Exit-OpenBox', 'application-exit']}, \n    {end => undef}, \n]"

tINT2RC="mate-terminal.desktop \nlauncher_item_app = geany.desktop \nlauncher_item_app = thunar.desktop \nlauncher_item_app = nitrogen.desktop \nlauncher_item_app = obconf.desktop"

source /root/extLightDM.sh

mkdir -p $uSRCFG/{tint2,openbox,$OBMENU,picom,nitrogen}
cp -R /etc/xdg/{tint2,openbox} $uSRCFG

echo "pgrep -x tint2 > /dev/null || tint2 &
nitrogen --restore &
pgrep -x picom > /dev/null || picom --config ~/.config/picom/picom.conf &" >> $uSRCFG/openbox/autostart

pushd $PWD
cd /opt
git clone https://aur.archlinux.org/$PERLLINUX.git
git clone https://aur.archlinux.org/$OBMENU.git
popd

chown -R $SUPERUSR:users /opt/$PERLLINUX /opt/$OBMENU
su -c "cd /opt/$PERLLINUX ; makepkg -s" - $SUPERUSR
pacman --noconfirm -U /opt/$PERLLINUX/*.tar.zst
su -c "cd /opt/$OBMENU ; makepkg -s" - $SUPERUSR
pacman --noconfirm -U /opt/$OBMENU/*.tar.zst
sed -i 's/xterm/mate-terminal/g;/xscreensaver-command/d;/application-exit/d' /etc/xdg/$OBMENU/schema.pl
sed -i "s/^]/${aPPEND1}/" /etc/xdg/$OBMENU/schema.pl
sed -i '/iceweasel.desktop/d;/chromium/d' $uSRCFG/tint2/tint2rc
sed -i "s/google-chrome.desktop/${tINT2RC}/g" $uSRCFG/tint2/tint2rc
cp /etc/xdg/picom.conf $uSRCFG/picom
cp /etc/xdg/$OBMENU/* $uSRCFG/$OBMENU

echo "<?xml version='1.0' encoding='utf-8'?>
<openbox_menu xmlns='http://openbox.org/' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='http://openbox.org/'>
	<menu id='root-menu' label='obmenu-generator' execute='/usr/bin/obmenu-generator -i' />
</openbox_menu>" > $uSRCFG/openbox/menu.xml

/root/extNitrogen.sh $sUPERHOME

chown -R $SUPERUSR:users $sUPERHOME
