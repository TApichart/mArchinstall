#!/usr/bin/bash

declare DESKTYPE="awesome"

if [ ! -d $1 ] ; then
	echo "[$1] is not a directory......!"
	exit 5
fi

declare sUPERHOME="$1"
declare uSRCFG="$sUPERHOME/.config"
declare SUPERUSR="$(echo "$1" | cut -d'/' -f 3)"

source /root/extSDDM.sh

systemctl enable sddm
mkdir -p $uSRCFG/{awesome,nitrogen} ; cp /etc/xdg/awesome/* $uSRCFG/awesome
sed -i '/^terminal =/c\terminal = "alacritty"' $uSRCFG/awesome/rc.lua
sed -i 's/nano/vim/g' $uSRCFG/awesome/rc.lua
sed -i '/local menubar =/c\local menubar = require("menubar")\nlocal appmenu = require("appmenu")' $uSRCFG/awesome/rc.lua
sed -i 's/theme.lua")/theme.lua")\nbeautiful.font="Monospace 12"\nbeautiful.menu_height=21\nbeautiful.menu_width=280/g' $uSRCFG/awesome/rc.lua
sed -i 's/"quit"/"logout"/g;s/"restart"/"reload"/g' $uSRCFG/awesome/rc.lua
sed -i 's/terminal }/terminal },\n		{ "Applications", appmenu.Appmenu }/g' $uSRCFG/awesome/rc.lua

echo -e "\nawful.spawn.with_shell(\"~/.config/awesome/autorun.sh\")" >> $uSRCFG/awesome/rc.lua
echo "#!/usr/bin/bash

killall -9 awesome-appmenu
nitrogen --restore &
awesome-appmenu &" > $uSRCFG/awesome/autorun.sh
pushd $PWD
cd /opt
git clone https://github.com/montagdude/awesome-appmenu.git
chown -R $SUPERUSR:users /opt/awesome-appmenu
su -c 'cd /opt/awesome-appmenu ; make -s' - $SUPERUSR
pacman --noconfirm -U /opt/awesome-appmenu/*.tar.zst
popd
/root/extNitrogen.sh $sUPERHOME
chmod 700 $uSRCFG/awesome/autorun.sh

chown -R $SUPERUSR:users $sUPERHOME

su -c 'awesome-appmenu' - $SUPERUSR
