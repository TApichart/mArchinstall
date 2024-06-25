#!/bin/bash
# =============================================================================================== #
# |                   minArchinstall.sh   Version 1.1.0                                           |
# | This is a shell script for install Arch Linux in simply way.                                  |
# | Writen by: InvisibleBox                                                                       |
# | Date: Apr,16 2024                                                                             |
# | Last Modified: May,23 2024                                                                    |
# | License : CC0 -                                                                               |
# |     CC0 (aka CC Zero) is a public dedication tool, which enables creators to give up          |
# |     their copyright and put their works into the worldwide public domain. CC0                 |
# |     enables reusers to distribute, remix, adapt, and build upon the material in any medium or |
# |     format, with no conditions.                                                               |
# =============================================================================================== #
MINAI_LOCK="/var/minAI_LOCK.lck"

if [ -f $MINAI_LOCK ] ; then
	bpid=`cat $MINAI_LOCK`
	echo "There is another process running at PID [$bpid].....!"
	exit 5
else
#	touch $MINAI_LOCK
	echo $$ > $MINAI_LOCK
fi

ping -c 1 www.google.com
if [ "$?" -eq 2 ]; then
	echo -e "Internet Connection........\e[1;31mE.R.R.O.R\e[0m...! "
	exit 2
fi

#-----------------------------------------------------------------------------#
#  Waiting for the process Reflector to generate /etc/pacman.d/mirroslist     #
#-----------------------------------------------------------------------------#
WaitReflector() {
	clear
	while [ `ps -C reflector | wc -l` -gt 1 ]
	do
		echo -e "\e[1;34mPlease waiting for [Reflector] process has finished.\e[0m..."
		sleep 2
	done
}

#------------------------------------------------------------#
#  If there is not a CLI-whiptail then installing by pacman  #
#------------------------------------------------------------#
if [ ! -f /usr/bin/whiptail ]; then
    pacman -Sy
    pacman --noconfirm -S whiptail
fi

#--------------------------------------------------#
#  git module - for installl additional            #
#--------------------------------------------------#
GITCLONE="git clone https://aur.archlinux.org"
PERLLINUX="perl-linux-desktopfiles"
OBMENU="obmenu-generator"
PKGMAKE="makepkg -s"
#--------------------------------------------------#
RESOLUTION="1920x1080"
TZFILE="/tmp/minAI_timezone.tmp"
KEYMAPFILE="/tmp/minAI_keymap.tmp"
LSDISKFILE="/tmp/minAI_disk.tmp"
CHROOTFILE="/root/minAI_chroot.sh"
INITFILE="/tmp/minAI_init.sh"
TIMEZONE="Asia/Bangkok"
KEYMAP="us"
MIRRORTH="auto"
HOSTNAME="arch"
ROOTABLE="disable"
ROOTPASS="rootArch24"
SUPERUSR="superuser"
SUPERPAS="default"
KERNELTP="linux"
DEVDISK="none"
PACKBASE="base base-devel"
PACKBASE1="vi vim terminus-font"
OPPACKS2="networkmanager netctl dialog net-tools dnsutils screenfetch"

declare MAINCH=1
declare RS=0

MNTTID=0
declare -a MNTDES=( "/" "/ /home" "/ /home /tmp /var" )

SWAPID=0
declare -a SWAPDES=( "no swap" "swapfile" "swap partition" )

declare CLILIST="htop zip unzip"
OPTIONS="htop git zip unzip sysstat perf nano os-prober mtools dosfstools wget curl ntfs-3g neofetch amd-ucode intel-ucode iptables"
declare -A OPDESC
OPDESC["htop"]="Interactive process viewer"
OPDESC["git"]="The fast distributed version control system"
OPDESC["zip"]="Compressor or creating and modifying zipfiles"
OPDESC["unzip"]="For extracting and viewing files in .zip archives"
OPDESC["sysstat"]="Tools (iostat,isag,mpstat,pidstat,sadf,sar)"
OPDESC["perf"]="Linux kernel performance auditing tool"
OPDESC["nano"]="GNU nano text editor"
OPDESC["os-prober"]="Utility to detect other OSes on a set of drives"
OPDESC["mtools"]="Utilities to access MS-DOS disks"
OPDESC["dosfstools"]="DOS filesystem utilities"
OPDESC["wget"]="Network utility to retrieve files from the Web"
OPDESC["curl"]="Tool and library for transferring data with URLs"
OPDESC["ntfs-3g"]="NTFS filesystem driver and utilities"
OPDESC["neofetch"]="CLI system information tool"
OPDESC["amd-ucode"]="Microcode for AMD processor"
OPDESC["intel-ucode"]="Microcode for Intel processor"
OPDESC["iptables"]="Network Packet Filtering (Using legacy interface)"
declare -A OPCHCK
OPCHCK["htop"]="on"
OPCHCK["git"]="off"
OPCHCK["zip"]="on"
OPCHCK["unzip"]="on"
OPCHCK["sysstat"]="off"
OPCHCK["perf"]="off"
OPCHCK["nano"]="off"
OPCHCK["os-prober"]="off"
OPCHCK["mtools"]="off"
OPCHCK["dosfstools"]="off"
OPCHCK["wget"]="off"
OPCHCK["curl"]="off"
OPCHCK["ntgs-3g"]="off"
OPCHCK["neofetch"]="off"
OPCHCK["amd-ucode"]="off"
OPCHCK["intel-ucode"]="off"
OPCHCK["iptables"]="on"

declare SERVLIST=""
OPTSERV="openssh apache mysql postgresql"
declare -A SRVDES
SRVDES["openssh"]="Secure remote login, and file transfer"
SRVDES["apache"]="A high performance Unix-based HTTP server"
SRVDES["mysql"]="MySQL Database server (mariadb)"
SRVDES["postgresql"]="Sophisticated object-relational DBMS"
declare -A SRVCHK
SRVCHK["openssh"]="off"
SRVCHK["apache"]="off"
SRVCHK["mysql"]="off"
SRVCHK["postgresql"]="off"

declare XPKLIST="vlc firefox libreoffice mousepad leafpad geany notepadqq gimp inkscape darktable freecad xdg-user-dirs gvfs"
declare XPACKS="vlc firefox mousepad xdg-user-dirs"
declare XFIXPK="noto-fonts"
declare -A XPKDES
XPKDES["vlc"]="Media player"
XPKDES["firefox"]="Firefox Web Browser"
XPKDES["libreoffice"]="LibreOffice - Office suit"
XPKDES["mousepad"]="MousePad text editor"
XPKDES["leafpad"]="A notepad clone for GTK+ 2.0"
XPKDES["geany"]="Geany - Fast and lightweidht IDE"
XPKDES["xdg-user-dirs"]="Extra - Manage user directories"
XPKDES["notepadqq"]="Notepad++ text editor"
XPKDES["gimp"]="GNU Image Manipulation Program"
XPKDES["inkscape"]="Professional vector graphics editor"
XPKDES["darktable"]="Utility to organize and develop raw images"
XPKDES["freecad"]="Feature based parametric 3D CAD modeler"
XPKDES["gvfs"]="Virtual filesystem implementation for GIO"
declare -A XPKCHK
XPKCHK["vlc"]="on"
XPKCHK["firefox"]="on"
XPKCHK["libreoffice"]="off"
XPKCHK["mousepad"]="on"
XPKCHK["leafpad"]="off"
XPKCHK["geany"]="off"
XPKCHK["notepadqq"]="off"
XPKCHK["gimp"]="off"
XPKCHK["inkscape"]="off"
XPKCHK["darktable"]="off"
XPKCHK["freecad"]="off"
XPKCHK["xdg-user-dirs"]="on"
XPKCHK["gvfs"]="off"

declare VDOID=1
declare -a VDOPACK
VDOPACK[1]="xf86-video-vmware"
VDOPACK[2]="xf86-video-ati"
VDOPACK[3]="xf86-video-amdgpu"
VDOPACK[4]="xf86-video-nouveau"
VDOPACK[5]="nvidia nvidia-utils nvidia-settings"
VDOPACK[6]="xf86-video-intel"
declare -a VDODES
VDODES[1]="vmVGA - Virutal Machine VGA"
VDODES[2]="RadeonHD - Radeon earlier HD7xxx"
VDODES[3]="AmdGPU - New Radeon/AMD"
VDODES[4]="Nvidia Legacy - GeForce 8/9, ION and 100-300 series"
VDODES[5]="nvidiaGPU - GeForce 630-900, 10-20, New age"
VDODES[6]="Intel Graphic HD"

declare AUDID="none"
AUDPACK="pulseaudio pulseaudio-alsa pulsemixer pavucontrol"

LIGHTDM="lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings"
declare DESKLIST="mate xfce cinnamon lxde lxqt deepin gnome kde bspwm bspwm_th openbox i3wm"
declare DESKTYPE="mate"
declare -A DESKDES
DESKDES["mate"]="MATE Desktop Environment"
DESKDES["xfce"]="XFCE4 Desktop Environment"
DESKDES["cinnamon"]="Forked from the GNOME desktop"
DESKDES["lxde"]="Lightweight X11 Desktop Environment"
DESKDES["lxqt"]="Lightweight X11 Qt Desktop Environment"
DESKDES["deepin"]="Deepin Desktop Environment"
DESKDES["gnome"]="GNome Desktop Environment"
DESKDES["kde"]="KDE Plasma Desktop Environment"
DESKDES["bspwm"]="Tiling Window Manager ( BSPWM )"
DESKDES["bspwm_th"]="BSPWM and Polybar-Themes"
DESKDES["openbox"]="Highly configurable and lightweight X11 window manager"
DESKDES["i3wm"]="Dynamic tiling window manager"
declare -A DESKPAK
DESKPAK["mate"]="$LIGHTDM mate mate-extra"
DESKPAK["xfce"]="lxdm xfce4 xfce4-goodies"
DESKPAK["cinnamon"]="$LIGHTDM cinnamon metacity gnome-shell gnome-terminal"
DESKPAK["lxde"]="lxde"
DESKPAK["lxqt"]="$LIGHTDM lightdm-webkit-theme-litarvan lxqt lxqt-themes breeze-icons xscreensaver"
DESKPAK["deepin"]="$LIGHTDM deepin deepin-kwin"
DESKPAK["gnome"]="gdm gnome gnome-extra gnome-tweaks"
DESKPAK["kde"]="sddm plasma kde-applications packagekit-qt5"
DESKPAK["bspwm"]="$LIGHTDM bspwm sxhkd picom polybar dmenu mate-terminal nitrogen thunar"
DESKPAK["bspwm_th"]="xfce4-settings rofi calc python-pywal git mpd mpc"
DESKPAK["openbox"]="$LIGHTDM openbox obconf lxappearance-obconf tint2 xterm gmrun mate-terminal picom nitrogen pcmanfm thunar glib-perl perl-data-dump perl-gtk3 git geany"
DESKPAK["i3wm"]="sddm i3 dmenu polybar picom terminator feh alacritty thunar xfce4-settings rofi calc python-pywal git mpd mpc"

declare NUMDEV=0
declare -a DSKDEV
declare -a DSKSIZ

BACKTITLE="minArchinstall version 1.1.0 :  Bash Shell Script for installing Arch Linux in minimal style.  Support only GPT/EFI without Encryption"	
STDDIALOG="whiptail --backtitle \"$BACKTITLE\""
SWAPSTD="3>&1 1>&2 2>&3"


MainMenu() {
	local mch
	local cmd
	local initdev="none"
	[ "$DEVDISK" != "none" ] && initdev="/dev/$DEVDISK"
	cmd="$STDDIALOG --cancel-button 'Quit'
		--title 'Main Menu' --default-item \"${MAINCH}\" --menu 'Select menu:-' 18 62 10
        '0' 'Keyboard Map...............[$KEYMAP]'
		'1' 'Timezone ..................[$TIMEZONE]'
		'2' 'Server mirror list.........[$MIRRORTH]'
		'3' 'Hostname ..................[$HOSTNAME]'
		'4' 'User and password .........[$SUPERUSR]'
		'5' 'Type of Linux Kernel ......[$KERNELTP]'
		'6' 'Optional packages .........[as your wish]'
		'7' 'Server packages............[as your wish]'
		'8' 'Disk partitions............[$initdev]'
		'9' '[...Next step to Install...]' ${SWAPSTD}"
	mch=`eval $cmd`
	RS=$?
	[ $RS -eq 0 ] && MAINCH=$mch
}


TimeZone() {
	local mch
	local cmd
	local cl=`cat $TZFILE | wc -l`
	local line
	cmd="$STDDIALOG \
		--title 'Your timezone' --default-item \"$TIMEZONE\" --menu 'Select timezone:-' 24 43 16"
	for i in $(seq 1 1 $cl); do
		read -r line
		cmd+=" '$line' ''"
	done < $TZFILE
	cmd+=" ${SWAPSTD}"
	mch=`eval $cmd`
	[ $? -eq 0 ] && TIMEZONE=$mch
}


Hostname() {
	local mch
	local cmd
	local rs
    tput cvvis
	cmd="$STDDIALOG \
		--title 'Define Hostname' --inputbox 'Enter hostname:-' 7 40 '$HOSTNAME' ${SWAPSTD}"
	mch=`eval $cmd`
    tput civis
	rs=$?
	if [ $rs -eq 0 ] ; then
		local len=${#mch}
		if [ $len -lt 4 ]; then
			MsgBox "Error Hostname" "Please re-enter hostname at least 4 letters...!"
		else
			HOSTNAME=$mch
		fi
	fi
}


LinuxKernel() {
	local mch
	local cmd
	cmd="$STDDIALOG
		--title 'LINUX KERNEL' --default-item \"${KERNELTP}\" --menu 'Select type of kernel:-' 11 80 4
		'linux' 'Stable-Vanilla Linux kernel and modules, with patches'
		'linux-lts' 'Long-term support(LTS)'
		'linux-hardened' 'A security-focused Linux kernel'
		'linux-zen' 'Result of a collaborative effort of kernel hackers' ${SWAPSTD}"
	mch=`eval $cmd`
	[ $? -eq 0 ] && KERNELTP=$mch
}


MsgBox() {
	local cmd="$STDDIALOG --title '$1' --msgbox '$2' 7 70 "
	eval $cmd
}


CheckPassword() {
	local pswd=$1
	local len="${#pswd}"
	local msg
	if [ $len -ge 8 ]; then
		echo "$pswd" | grep -q [0-9]
		if [ $? -eq 0 ]; then
			echo "$pswd" | grep -q [A-Z]
			if [ $? -eq 0 ]; then
				echo "$pswd" | grep -q [a-z]
				if [ $? -eq 0 ] ; then
					msg="Valid password"
				else
					msg="Please include Lowercase letter[a..z], Weak Password...!"
				fi
			else
				msg="Please include Capital letter[A..Z], Weak Password...!"
			fi
		else
			msg="Please include number[0..9] in password, Weak Password...!"
		fi
	else
		msg="Password should be at least 8 characters, Weak Password...!"
	fi
	echo "$msg"
}


SuperUserName() {
	local mch
	local cmd
    tput cvvis
	cmd="$STDDIALOG
		--title 'Define user name for Super User' --inputbox 'User name as Admin user:-' 7 40 '$SUPERUSR' ${SWAPSTD}"
	mch=`eval $cmd`
    tput civis
	[ $? -eq 0 ] && SUPERUSR=$mch
}


SuperPassword() {
	local mch
	local cmd
	local rs
	local initpass
	if [ "$SUPERPAS" == "default" ]; then
		initpass="$SUPERUSR"
	else
		initpass="$SUPERPAS"
	fi
    tput cvvis
	cmd="$STDDIALOG
		--title 'Set password for [$SUPERUSR]' 
		--passwordbox 'Password should be at least 8 characters long with 1 uppercase, and 1 lowercase:-' 8 45 '$initpass' ${SWAPSTD}"
	mch=`eval $cmd`
    tput civis
	rs=$?
	if [ $rs -eq 0 ] ; then
		local ck=$(CheckPassword "$mch")
		if [ "$ck" == "Valid password" ]; then
			SUPERPAS=$mch
			MsgBox "Accept Password" "$ck"
		else
			MsgBox "Error in Password" "$ck"
		fi
	fi
}


RootPassword() {
	local mch
	local idx=0
	local cmd
	local rs
	local initpass=$ROOTPASS
    tput cvvis
	cmd="$STDDIALOG
		--title \"Set root's password\" --passwordbox \"Enter password:-\" 11 48 '$initpass' ${SWAPSTD}"
	mch=`eval $cmd`
    tput civis
	rs=$?
	if [ $rs -eq 0 ] ; then
		local ck=$(CheckPassword "$mch")
		if [ "$ck" == "Valid password" ]; then
			ROOTPASS="$mch"
			MsgBox "Accept Password" "$ck"
			ROOTABLE="enable"
		else
			MsgBox "Error in Password" "$ck"
			ROOTABLE="disable"
		fi
	fi
}


RootSelect() {
	local mch
	local cmd
	local rs=0
	local initch="$ROOTABLE"
	cmd="$STDDIALOG --cancel-button 'Back'
		--title 'Setting root user' --default-item \"$initch\" --menu 'Select menu:-' 11 65 3
		'disable'   'Disable - root can not login'
		'enable'    'Enable - set password for root' ${SWAPSTD}"
	mch=`eval $cmd`
	rs=$?
	if [ $rs -eq 0 ] ; then
		if [ "$mch" == "enable" ]; then
			RootPassword
		else
			ROOTABLE="disable"
		fi
	fi
}


RepeatAsterisk() {
	local cl=${#1}
	local asterisk=""
	for i in `seq 1 1 $cl`; do
		asterisk+='*'
	done
	echo "$asterisk"
}


UserAccout() {
	local mch
	local cmd
	local rs=0
	local initch="root"
	local initrt
	local passval
	until [ $rs -ne 0 ]; do
		if [ "$ROOTABLE" == "enable" ]; then
			initrt=$(RepeatAsterisk "$ROOTPASS")
		else
			initrt="disable"
		fi
		if [ "$SUPERPAS" == "default" ]; then
			passval="default"
		else
			passval=$(RepeatAsterisk "$SUPERPAS")
		fi

		cmd="$STDDIALOG --cancel-button 'Back'
			--title 'User account manament' --default-item \"$initch\" --menu 'Select menu:-' 11 65 3
			'root'   'Set password for root User........[$initrt]'
			'user'   'Define user name for Super User...[$SUPERUSR]'
			'passwd' 'Set password for Super User.......[$passval]' ${SWAPSTD}"
		mch=`eval $cmd`
		rs=$?
		if [ $rs -eq 0 ] ; then
			initch=$mch
			case $mch in
				'root' ) RootSelect
					;;
				'user' ) SuperUserName
					;;
				'passwd' ) SuperPassword
					;;
			esac
		fi
	done
}


OptionalCLI(){
	local -A mch
	local num=`echo "$OPTIONS" | wc -w`
	local cmd="$STDDIALOG
			--title 'Optional Command Line Packages'
			--checklist 'These packages are the basics, has already included after installation:\n[ $PACKBASE1 ]\nChoose additional packages to install:' 24 80 $num"
	for ep in $OPTIONS ; do
		local pn=${OPDESC["$ep"]}
		local pc=${OPCHCK["$ep"]}
		cmd+=" '$ep' '$pn' '$pc'"
	done
	cmd+=" ${SWAPSTD}"
	mch=`eval $cmd`
	rs=$?
    mch=`echo $mch | sed 's/"//g'`
	if [ $rs -eq 0 ]; then
		for ep in $OPTIONS ; do
			OPCHCK["$ep"]='off'
		done
		CLILIST="$mch"
		for ep in $mch ; do
			OPCHCK["$ep"]='on'
		done
	fi
}


ServerPackages(){
	local -A mch
	local num=`echo "$OPTSERV" | wc -w`
	local cmd="$STDDIALOG
			--title 'Server / Service Packages list'
			--checklist 'Choose packages to install:' 22 80 $num"
	for ep in $OPTSERV ; do
		local pn=${SRVDES["$ep"]}
		local pc=${SRVCHK["$ep"]}
		cmd+=" '$ep' '$pn' '$pc'"
	done
	cmd+=" ${SWAPSTD}"
	mch=`eval $cmd`
	rs=$?
    mch=`echo $mch | sed 's/"//g'`
	if [ $rs -eq 0 ]; then
		for ep in $OPTSERV ; do
			SRVCHK["$ep"]='off'
		done
		SERVLIST="$mch"
		for ep in $mch ; do
			SRVCHK["$ep"]='on'
		done
	fi
}


SelectDevDisk() {
	local mch
	local cmd
	local initch
	[ ! "$DEVDISK" == "none" ] && initch="$DEVDISK"
	cmd="$STDDIALOG
		--title 'Select the target disk for Arch linux.'
		--default-item \"$initch\" --menu 'Choose Disk device :-' 12 45 4"
	for i in `seq 1 1 $NUMDEV` ; do
		cmd+=" '${DSKDEV[$i]}' '${DSKSIZ[$i]}'"
	done
	cmd+=" ${SWAPSTD}"
	mch=`eval $cmd`
	[ $? -eq 0 ] &&	DEVDISK="$mch"
}


SwapType() {
	local mch
	local cmd
	cmd="$STDDIALOG
		--title 'How to manage swap memory?' 
		--default-item \"$SWAPID\" 
		--menu 'Swap as:-\nIf using swap, it is fix at 2Gb' 12 35 4"
	for i in `seq 0 1 2` ; do
		cmd+=" '$i' '${SWAPDES[$i]}'"
	done
	cmd+=" ${SWAPSTD}"
	mch=`eval $cmd`
	[ $? -eq 0 ] &&	SWAPID=$mch
}


MountVolume() {
	local mch
	local cmd
	cmd="$STDDIALOG
		--title 'Set the partitioning format' 
		--default-item \"$MNTTID\" --menu 'Mount Volume as:-' 12 35 4"
	for i in `seq 0 1 2` ; do
		cmd+=" '$i' '${MNTDES[$i]}'"
	done
	cmd+=" ${SWAPSTD}"
	mch=`eval $cmd`
	[ $rs -eq 0 ] && MNTTID=$mch
}


DiskPartition() {
	local mch
	local cmd
	local rs=0
	local initch='swap'
	while [ $rs -eq 0 ]; do
		cmd="$STDDIALOG --cancel-button 'Back'
			--title 'Disk partitions' --default-item '$initch' --menu 'Warning...!\nAll data in the target disk will be erased :-' 15 60 8
			'swap'  'Swap space and paging...[${SWAPDES[$SWAPID]}]'
			'dev'   'Disk device to install..[$DEVDISK]'
			'mount' 'Mount volume ...........[ ${MNTDES[$MNTTID]} ]' ${SWAPSTD}"
		mch=`eval $cmd`
		rs=$?
		if [ $rs -eq 0 ]; then
			case "$mch" in
				'swap' ) SwapType
					;;
				'dev' ) SelectDevDisk
					;;
				'mount' ) MountVolume
					;;
			esac
			initch=$mch
		fi
	done
}


declare ROOTPARTLABEL="\n# ===== Root Partition [ / ] ===== #"
declare HOMEPARTLABEL="\n# ===== Home Partition [ /home ] ===== #"
declare TMPPARTLABEL="\n# ===== Temporary Partition [ /tmp ] ===== #"
declare VARPARTLABEL="\n# ===== Var Partition [ /var ] ===== #"
declare MOUNTLABEL="\n# ===== Mount Root Partition as /mnt ===== #"
declare FORMATLABEL="\n# ===== FORMAT PATITIONs ===== #"

PartRootWhole() {
	local devdisk="$1"
	local -i nroot="$2"
	local nxpart="$3"
	echo -e "$ROOTPARTLABEL"
	echo "parted -s $devdisk mkpart primary ext4 $nxpart 100%"
	echo -e "$FORMATLABEL"
	echo "mkfs.ext4 -F ${devdisk}${nroot}"
	echo -e "$MOUNTLABEL"
	echo "mount ${devdisk}${nroot} /mnt"
	echo "mkdir -p /mnt/boot/EFI"
	echo "mount ${devdisk}1 /mnt/boot/EFI"
}


PartRootHome() {
	local devdisk="$1"
	local -i nroot="$2"
	local nxpart="$3"
	local -i nhome=nroot+1
	echo -e "$ROOTPARTLABEL"
	echo "parted -s $devdisk mkpart primary ext4 $nxpart 20GiB"
	echo -e "$HOMEPARTLABEL"
	echo "parted -s $devdisk mkpart primary ext4 20GiB 100%"
	echo -e "$FORMATLABEL"
	echo "mkfs.ext4 -F ${devdisk}${nroot}"
	echo "mkfs.ext4 -F ${devdisk}${nhome}"
	echo -e "$MOUNTLABEL"
	echo "mount ${devdisk}${nroot} /mnt"
	echo "mkdir -p /mnt/boot/EFI /mnt/home"
	echo "mount ${devdisk}1 /mnt/boot/EFI"
	echo "mount ${devdisk}${nhome} /mnt/home"
}


PartRootVarTmp() {
	local devdisk="$1"
	local -i nroot="$2"
	local nxpart="$3"
	local -i nvar=nroot+1
	local -i ntmp=nvar+1
	local -i nhome=ntmp+1
	echo -e "$ROOTPARTLABEL"
	echo "parted -s $devdisk mkpart primary ext4 $nxpart 20GiB"
	echo -e "$HOMEPARTLABEL"
	echo "parted -s $devdisk mkpart primary ext4 20GiB 25GiB"
	echo -e "$TMPPARTLABEL"
	echo "parted -s $devdisk mkpart primary ext4 25GiB 30GiB"
	echo -e "$VARPARTLABEL"
	echo "parted -s $devdisk mkpart primary ext4 30GiB 100%"
	echo -e "$FORMATLABEL"
	echo "mkfs.ext4 -F ${devdisk}${nroot}"
	echo "mkfs.ext4 -F ${devdisk}${nvar}"
	echo "mkfs.ext4 -F ${devdisk}${ntmp}"
	echo "mkfs.ext4 -F ${devdisk}${nhome}"
	echo -e "$MOUNTLABEL"
	echo "mount ${devdisk}${nroot} /mnt"
	echo "mkdir -p /mnt/boot/EFI /mnt/{home,var,tmp}"
	echo "mount ${devdisk}1 /mnt/boot/EFI"
	echo "mount ${devdisk}${nvar} /mnt/var"
	echo "mount ${devdisk}${ntmp} /mnt/tmp"
	echo "mount ${devdisk}${nhome} /mnt/home"
}


GenMountScript() {
	local endboot="501MiB"
	local nxpart
	local nroot
	local devdisk="/dev/$DEVDISK"
	local eFIPART="\n# ===== EFI Boot Partition ===== #
parted -s $devdisk mklabel gpt
parted -s $devdisk mkpart primary fat32 1MiB $endboot
parted -s $devdisk set 1 esp on
mkfs.fat -F32 ${devdisk}1"
	echo -e "$eFIPART" >> $INITFILE
	if [ $SWAPID -eq 2 ]; then	# == Select Swap Partition ==
		nxpart="2.5GiB"
		nroot=3
		# ---- create swap partition ----
		local sWAPPART="\n# ===== Swap Partition ===== #
parted -s $devdisk mkpart primary linux-swap $endboot $nxpart
mkswap ${devdisk}2
swapon ${devdisk}2"
		echo -e "$sWAPPART" >> $INITFILE
	else		# ===== NoSwap and Swapfile =====
		nxpart=$endboot
		nroot=2
	fi
	case $MNTTID in
		0 ) 
			echo "$(PartRootWhole $devdisk $nroot $nxpart)" >> $INITFILE
			;;	# ===== Partition type [ / ] =====
		1 )
			echo "$(PartRootHome $devdisk $nroot $nxpart)" >> $INITFILE
			;;	# ===== Partition type [ / , /home ] =====
		2 ) 
			echo "$(PartRootVarTmp $devdisk $nroot $nxpart)" >> $INITFILE
			;;	# ===== Partition type [ / , /home , /var , /tmp ] =====
	esac

	# ---- make /swapfile ----
	if [ $SWAPID -eq 1 ]; then
		echo "dd if=/dev/zero of=/mnt/swapfile bs=1M count=2048" >> $INITFILE
		echo "chmod 600 /mnt/swapfile" >> $INITFILE
		echo "mkswap /mnt/swapfile" >> $INITFILE
	fi
}


#=================== GenDesktopScript() ===================#
GenDesktopScript() {
	local mONITOR1="Section \\\"Monitor\\\"
	Identifier \\\"Virtual-1\\\"
	Option \\\"PreferredMode\\\" \\\"$RESOLUTION\\\"
	Option \\\"Primary\\\" \\\"1\\\"
EndSection"
	local sUPERHOME="/home/$SUPERUSR"
	local uSRCFG="$sUPERHOME/.config"
	local bGDIR="/usr/share/backgrounds/archlinux"
	local bGSAVED="[xin_-1]
file=$bGDIR/awesome.png
mode=4
bgcolor=#000000 "
	local nITROGEN="[geometry]
posx=0
posy=0
sizex=516
sizey=500

[nitrogen]
view=icon
recurse=true
sort=alpha
icon_caps=false
dirs=$bGDIR; "
	local lIGHTBG="sed -i '/#background=/c\\background=/usr/share/backgrounds/archlinux/geowaves.png' /etc/lightdm/lightdm-gtk-greeter.conf"

	local bSPWMSCRT="mkdir -p $uSRCFG/{bspwm,sxhkd,polybar,picom,nitrogen}
cp /usr/share/doc/bspwm/examples/bspwmrc $uSRCFG/bspwm
cp /usr/share/doc/bspwm/examples/sxhkdrc $uSRCFG/sxhkd
cp /etc/xdg/picom.conf $uSRCFG/picom
cp /etc/polybar/config.ini $uSRCFG/polybar
chmod +x $uSRCFG/bspwmrc
echo 'pgrep -x picom > /dev/null || picom --config ~/.config/picom/picom.conf &
nitrogen --restore &

# ========== Polybar or Polybar-Themes ========== #
pgrep -x polybar > /dev/null || polybar &' >> $uSRCFG/bspwm/bspwmrc

sed -i 's/bspc rule/#bspc rule/g' $uSRCFG/bspwm/bspwmrc
sed -i 's/urxvt/mate-terminal --hide-menubar/g' $uSRCFG/sxhkd/sxhkdrc
echo 'super + e
	thunar' >> $uSRCFG/sxhkd/sxhkdrc
echo \"$bGSAVED\" > $uSRCFG/nitrogen/bg-saved.cfg
echo \"$nITROGEN\" > $uSRCFG/nitrogen/nitrogen.cfg
$lIGHTBG
systemctl enable lightdm"

	local mpdCFG="# See: /usr/share/doc/mpd/mpdconf.example\n
pid_file \\\"~/.config/mpd/pid\\\"
db_file \\\"~/.config/mpd/mpd.db\\\"
state_file \\\"~/.config/mpd/state\\\"
playlist_directory \\\"~/.config/mpd/playlists\\\"
music_directory \\\"~/Music\\\"
auto_update \\\"yes\\\"

audio_output {
	type	\\\"pulse\\\"
	name	\\\"pulse audio\\\"
}

audio_output {
	type	\\\"fifo\\\"
	name	\\\"my_fifo\\\"
	path	\\\"/tmp/mpd.fifo\\\"
	format	\\\"44100:16:2\\\"
}

bind_to_address  \\\"127.0.0.1\\\"
port \\\"6600\\\""

	local plusTHEMES="\n# Polybar-Themes
pushd \$PWD
cd /opt
$GITCLONE/networkmanager-dmenu-git.git
git clone https://github.com/adi1090x/polybar-themes.git
popd
chown -R $SUPERUSR:users /opt/{networkmanager-dmenu-git,polybar-themes}
su -c 'cd /opt/networkmanager-dmenu-git ; $PKGMAKE' - $SUPERUSR
pacman --noconfirm -U /opt/networkmanager-dmenu-git/*.tar.zst
mv $uSRCFG/polybar $uSRCFG/polybar.0
mkdir -p /usr/local/share/{fonts,backgrounds} $uSRCFG/{polybar,mpd/playlists}
cp -fr /opt/polybar-themes/fonts/* /usr/local/share/fonts
cp -fr /opt/polybar-themes/wallpapers/* /usr/local/share/backgrounds
cp -rf /opt/polybar-themes/simple/* $uSRCFG/polybar
cp -rf /opt/polybar-themes/bitmap/hack/* $uSRCFG/polybar/hack
cp -rf /opt/polybar-themes/bitmap/shades/* $uSRCFG/polybar/shades
cp -rf /opt/polybar-themes/bitmap/shapes/* $uSRCFG/polybar/shapes"

	# =============== Static install packages :- xorg, network-manater-applet archlinux-wallpaper ============== #
	echo -e "\npacman --noconfirm -S xorg network-manager-applet archlinux-wallpaper" >> $CHROOTFILE

	echo "[ \$? -ne 0 ] && PauseError 'Install [xorg...] incomplete'" >> $CHROOTFILE
	if [ "$DESKTYPE" == "bspwm_th" ] ; then
		echo "pacman --noconfirm -S ${DESKPAK['bspwm']}" >> $CHROOTFILE
	fi
	echo "pacman --noconfirm -S ${DESKPAK[$DESKTYPE]}" >> $CHROOTFILE
	echo "[ \$? -ne 0 ] && PauseError 'Install [$DESKTYPE...] incomplete'" >> $CHROOTFILE

	case $DESKTYPE in
		"mate" )
			echo "sed -i '/#greeter-session=/c\\greeter-session=lightdm-gtk-greeter' /etc/lightdm/lightdm.conf\n" >> $CHROOTFILE
			echo "$lIGHTBG" >> $CHROOTFILE
			echo "systemctl enable lightdm" >> $CHROOTFILE
			;;		# Mate Desktop
		"xfce" )
			echo "sed -i '/# session=/c\\session=startxfce4' /etc/lxdm/lxdm.conf" >> $CHROOTFILE
			echo "systemctl enable lxdm" >> $CHROOTFILE
			;;		# XFCE4 Desktop
		"deepin" )
			echo "sed -i '/#greeter-session=/c\\greeter-session=lightdm-gtk-greeter' /etc/lightdm/lightdm.conf" >> $CHROOTFILE
			echo "$lIGHTBG" >> $CHROOTFILE
			echo "systemctl enable lightdm" >> $CHROOTFILE
			echo "pacman --noconfirm -S deepin-{terminal,calculator,clipboard,community-wallpapers}" >> $CHROOTFILE
			echo "[ \$? -ne 0 ] && PauseError 'Install [deepin] incomplete.'" >> $CHROOTFILE
			;;		# Deepin Desktop
		"lxde" )
			echo "systemctl enable lxdm" >> $CHROOTFILE
			;;		# LXDE Desktop
		"lxqt" )
			echo "sed -i '/#greeter-session=/c\\greeter-session=lightdm-webkit2-greeter' /etc/lightdm/lightdm.confn" >> $CHROOTFILE
			echo "$lIGHTBG" >> $CHROOTFILE
			echo "sed -i 's/= antergos/= litarvan/g' /etc/lightdm/lightdm-webkit2-greeter.conf" >> $CHROOTFILE
			echo "sed -i 's/icon_theme=oxygen/icon_theme=Adwaita/g' /usr/share/lxqt/lxqt.conf" >> $CHROOTFILE
			echo "sed -i '/icon_theme=/c\\icon_theme=breeze-dark' $uSRCFG/lxqt/lxqt.conf" >> $CHROOTFILE
			echo "systemctl enable lightdm" >> $CHROOTFILE
			;;		# LXqt Desktop
		"gnome" )
			echo "sed -i 's/#Wayland/Wayland/g' /etc/gdm/custom.conf" >> $CHROOTFILE
			echo "systemctl enable gdm" >> $CHROOTFILE
			;;		# GNOME Desktop
		"kde" )
			echo "systemctl enable sddm" >> $CHROOTFILE
			;;		# KDE Desktop
		"bspwm" )
			echo "$bSPWMSCRT" >> $CHROOTFILE
			echo "chown -R $SUPERUSR:users $sUPERHOME" >> $CHROOTFILE
			;;		# BSPWM Window Manager
		"bspwm_th" )
			echo "$bSPWMSCRT" >> $CHROOTFILE
			echo "sed -i '/pgrep -x polybar/c\\~/.config/polybar/launch.sh --forest' $uSRCFG/bspwm/bspwmrc
# ==== Insert Media player to BSPWM cofig ==== #
echo \"# ======== Media Player ========
[ ! -s ~/.config/mpd/pid ] && mpd
mpc clear ; mpc add /
\" >> $uSRCFG/bspwm/bspwmrc" >> $CHROOTFILE
			echo -e "$plusTHEMES" >> $CHROOTFILE
			echo "echo -e \"${mpdCFG}\" > $uSRCFG/mpd/mpd.conf" >> $CHROOTFILE
			echo "chown $SUPERUSR:users $uSRCFG/mpd/mpd.conf" >> $CHROOTFILE
			echo "chown -R $SUPERUSR:users $sUPERHOME" >> $CHROOTFILE
			;;		# BSPWM Window Manager and Polybar-Themes
		"cinnamon" )
			echo "$lIGHTBG" >> $CHROOTFILE
			echo "systemctl enable lightdm" >> $CHROOTFILE
			;;		# Cinnamon Desktop
		"openbox" )
			local aPPEND1="    {beg => ['Shutdown-Menu', 'open-menu-symbolic']}, \\n\\
		{item => ['poweroff -i', 'Shutdown', 'system-shutdown-symbolic']}, \\n\\
		{item => ['reboot', 'Restart', 'view-refresh-symbolic']}, \\n\\
		{exit => ['Exit-OpenBox', 'application-exit']}, \\n\\
		{end => undef}, \\n\\
]"
			local aPPEND2="<?xml version='1.0' encoding='utf-8'?>
<openbox_menu xmlns='http://openbox.org/' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='http://openbox.org/'>
	<menu id='root-menu' label='obmenu-generator' execute='/usr/bin/obmenu-generator -i' />
</openbox_menu>"
			local oPENAUTO="pgrep -x tint2 > /dev/null || tint2 &
nitrogen --restore &
pgrep -x picom > /dev/null || picom --config ~/.config/picom/picom.conf &"
			local tINT2RC="mate-terminal.desktop \\n\\
launcher_item_app = geany.desktop \\n\\
launcher_item_app = thunar.desktop \\n\\
launcher_item_app = nitrogen.desktop \\n\\
launcher_item_app = obconf.desktop"
			local oPENSCRT="mkdir -p $uSRCFG/{tint2,openbox,$OBMENU,picom,nitrogen}
cp -R /etc/xdg/{tint2,openbox} $uSRCFG
echo \"$oPENAUTO\" >> $uSRCFG/openbox/autostart
pushd \$PWD
cd /opt
$GITCLONE/$PERLLINUX.git
$GITCLONE/$OBMENU.git
popd
chown -R $SUPERUSR:users /opt/$PERLLINUX /opt/$OBMENU
su -c 'cd /opt/$PERLLINUX ; $PKGMAKE' - $SUPERUSR
pacman --noconfirm -U /opt/$PERLLINUX/*.tar.zst
su -c 'cd /opt/$OBMENU ; $PKGMAKE' - $SUPERUSR
pacman --noconfirm -U /opt/$OBMENU/*.tar.zst
sed -i 's/xterm/mate-terminal/g;/xscreensaver-command/d;/application-exit/d' /etc/xdg/$OBMENU/schema.pl
sed -i \"s/^]/$aPPEND1/\" /etc/xdg/$OBMENU/schema.pl
sed -i '/iceweasel.desktop/d;/chromium/d' $uSRCFG/tint2/tint2rc
sed -i \"s/google-chrome.desktop/${tINT2RC}/g\" $uSRCFG/tint2/tint2rc
cp /etc/xdg/picom.conf $uSRCFG/picom
cp /etc/xdg/$OBMENU/* $uSRCFG/$OBMENU
echo \"$aPPEND2\" > $uSRCFG/openbox/menu.xml
echo \"$bGSAVED\" > $uSRCFG/nitrogen/bg-saved.cfg
echo \"$nITROGEN\" > $uSRCFG/nitrogen/nitrogen.cfg
chown -R $SUPERUSR:users $sUPERHOME
$lIGHTBG
systemctl enable lightdm"
			echo "$oPENSCRT" >> $CHROOTFILE
			;;		# OpenBox Window Manager
		"i3wm" )
			echo "systemctl enable sddm" >> $CHROOTFILE
			echo -e "$plusTHEMES" >> $CHROOTFILE
			echo "mkdir -p $uSRCFG/i3 ; cp /etc/i3/config $uSRCFG/i3
cp /etc/xdg/picom.conf $uSRCFG/picom
cp /etc/polybar/config.ini $uSRCFG/polybar
cp /etc/i3blocks.conf $sUPERHOME/.i3blocks.conf
cp /etc/i3status.conf $sUPERHOME/.i3status.conf
chmod 600 $sUPERHOME/.i3*.conf
sed -i 's/i3-sensible-terminal/alacritty/g' $uSRCFG/i3/config
echo -e \"${mpdCFG}\" > $uSRCFG/mpd/mpd.conf
sed -i '/font pango:monospace/c\\set \$mod Mod4\\nfont pango:monospace 8' $uSRCFG/i3/config
sed -i 's/Mod1/\$mod/g' $uSRCFG/i3/config
sed -i '/exec i3-config/c\\exec_always ~/autorun.sh' $uSRCFG/i3/config
#### Create   autorun.sh #####
echo '#!/usr/bin/bash

picom --config $uSRCFG/picom/picom.conf &
feh --bg-fill /usr/local/share/backgrounds/bg_3.jpg &
$uSRCFG/polybar/launch.sh --blocks &

[ ! -s ~/.config/mpd/pid ] && mpd
mpc clear ; mpc add / ' > $sUPERHOME/autorun.sh
#### ---- autorun.sh ---- #####
chown -R $SUPERUSR:users $sUPERHOME
chmod 700 $sUPERHOME/autorun.sh" >> $CHROOTFILE
			;;		# i3-wm Window Manager
	esac

	# ========= The tail scipts :- for Installl of Desktop / Window Manager ============== #
	[ "$RESOLUTION" != 'not define' ] && echo "echo \"$mONITOR1\" > /etc/X11/xorg.conf.d/01-monitor.conf" >> $CHROOTFILE
	echo "pacman --noconfirm -S ${VDOPACK[$VDOID]}" >> $CHROOTFILE
	echo "[ \$? -ne 0 ] && PauseError 'Install [${VDOPACK[$VDOID]}] incomplete.'" >> $CHROOTFILE
	if [ $AUDID != "none" ]; then
		echo "pacman --noconfirm -S $AUDPACK" >> $CHROOTFILE
	fi
	echo "pacman --noconfirm -S noto-fonts $XPACKS" >> $CHROOTFILE
	echo "[ \$? -ne 0 ] && PauseError 'Additional packages for GUI incomplete.'" >> $CHROOTFILE
}
#=================== GenDesktopScript() ===================#


#=================== GenRootScript() ===================#
GenRootScript() {
	local rOOTSCRIPT1="#!/usr/bin/bash\n
PauseError() {
	local pkey
	echo '#*--------------------------------------------*'
	echo \"#  Warning : \$1  #\"
	echo '#*--------------------------------------------*'
	read -p 'Do you want to continuew?....<Y/n>:' pkey
	pkey=\${pkey^^}
	if [ \"\$pkey\" == 'N' ]; then
		exit 2
	fi
}

echo 'en_US.UTF-8 UTF-8' > /etc/local.gen
echo 'en_US ISO-8859-1' >> /etc/local.gen
locale-gen
echo 'LANG=en_US.UTF-8'
echo '$HOSTNAME' > /etc/hostname
echo '127.0.0.1 localhost' >> /etc/hosts
echo '::1 localhost' >> /etc/hosts
echo '127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}' >> /etc/hosts
pacman --noconfirm -S ${OPPACKS2} ${CLILIST} ${SERVLIST}
[ \$? -ne 0 ] && PauseError 'linux_cli packages incomplete.'
systemctl enable NetworkManager
mkinitcpio -P
echo 'root:${ROOTPASS}' | chpasswd
useradd -m -g users -G wheel,storage,power,audio,video ${SUPERUSR}
echo '${SUPERUSR}:${SUPERPAS}' | chpasswd
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers
echo \"source \\\$VIMRUNTIME/defaults.vim 
set number
syntax on
set showmatch
set ruler
set smarttab
set ts=4 sw=4\" > /home/${SUPERUSR}/.vimrc
chown ${SUPERUSR}:users /home/${SUPERUSR}/.vimrc
chmod 600 /home/${SUPERUSR}/.vimrc"

	echo -e "$rOOTSCRIPT1" > $CHROOTFILE
	[ ${SRVCHK["openssh"]} == "on" ] && echo "systemctl enable sshd" >> $CHROOTFILE
	if [ "${OPCHCK["neofetch"]}" == "on" ] ; then
		echo "echo 'neofetch' >> /home/${SUPERUSR}/.bash_profile" >> $CHROOTFILE
	else
		echo "echo 'screenfetch' >> /home/${SUPERUSR}/.bash_profile" >> $CHROOTFILE
	fi

	local rOOTSCRIPT2="pacman --noconfirm -S grub efibootmgr
[ \$? -ne 0 ] && PauseError 'Install [grub efibootmgr] incomplete.'
grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=GRUB
[ \$? -ne 0 ] && PauseError 'grub-install incomplete.'
grub-mkconfig -o /boot/grub/grub.cfg
[ \$? -ne 0 ] && PauseError 'grub-mkconfig incomplete.'"

	echo "$rOOTSCRIPT2" >> $CHROOTFILE
	[ $ROOTABLE == "disable" ] && echo "usermod -s /usr/bin/nologin root" >> $CHROOTFILE
	if [ "${OPCHCK['iptables']}" == "on" ] ; then
		local aCCEPTsshd=""
		[ "${SRVCHK['openssh']}" == 'on' ] && aCCEPTsshd="-A TCP -p tcp --dport 22 -j ACCEPT"
		echo "echo \"# Empty iptables rule file
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]
:TCP - [0:0]
:UDP - [0:0]
-A INPUT -m conntrack --ctstate RELATE,ESTABLISHED -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m conntrack --ctstate NEW -j UDP
-A INPUT -p icmp -m icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT
-A INPUT -p udp -m conntrack --ctstate NEW -j UDP
-A INPUT -p tcp --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j TCP
-A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
-A INPUT -p tcp -j REJECT --reject-with tcp-reset
-A INPUT -j REJECT --reject-with icmp-proto-unreachable
# === If you need more services to listening on network, Add the lines below:- ===
#-A TCP -p tcp --dport 22 -j ACCEPT
#-A INPUT -p tcp -m tcp --syn -m conntrack --ctstate NEW --dport 22 -j ACCEPT
#-A TCP -p tcp --dport 443 -j ACCEPT
# ================================================================================
${aCCEPTsshd}
COMMIT
\" > /etc/iptables/iptables.rules
systemctl enable iptables" >> $CHROOTFILE
	fi
}
#=================== GenRootScript() ===================#


#=================== PrepareScript() ===================#
PrepareScript() {
	WaitReflector
	local kernel="$KERNELTP"
	if [ ! -f $INITFILE ]; then
		touch $INITFILE
		chmod 700 $INITFILE
	else
		MsgBox "!.....Error.....!" "Unable to install... Becuase it has [$INITFILE] already...!"
		exit 2
	fi
	sed -i '/#Color/c\Color' /etc/pacman.conf
	sed -i '/#ParallelDownloads/c\ParallelDownloads = 2' /etc/pacman.conf

	kernel+=" ${KERNELTP}-headers linux-firmware"

	local iNIT1="#!/usr/bin/bash\n\n
PauseError() {
	local pkey
	echo '#*--------------------------------------------*'
	echo \"#  Error : \$1  #\"
	echo '#*--------------------------------------------*'
	read -p 'Press any key...' pkey
}

timedatectl set-timezone $TIMEZONE
timedatectl set-ntp true
hwclock --systohc
pacman -Sy"

	local iNIT2="pacstrap -K /mnt $PACKBASE ${kernel} $PACKBASE1
[ \$? -ne 0 ] && PauseError 'pacstrap -K /mnt incomplete.'
genfstab -U /mnt >> /mnt/etc/fstab"

	local iNIT3="cp /etc/hosts /mnt/etc/hosts
echo 'FONT=ter-v20n' > /mnt/etc/vconsole.conf
ln -sf /usr/share/zoneinfo/$TIMEZONE /mnt/etc/localtime
cp $CHROOTFILE /mnt${CHROOTFILE}
chmod 700 /mnt${CHROOTFILE}
cp /etc/pacman.conf /mnt/etc/pacman.conf
arch-chroot /mnt $CHROOTFILE
umount -R /mnt"

	echo -e "$iNIT1" > $INITFILE
	GenMountScript
	echo -e "\n# =====  PACSTRAP - Begining of Arch Installation ===== #" >> $INITFILE
	echo "$iNIT2" >> $INITFILE
	if [ $SWAPID -eq 1 ]; then
		echo "echo '/swapfile none swap defaults 0 0' >> /mnt/etc/fstab" >> $INITFILE
	fi

	echo -e "\n# ===== Prepare some configuration ===== #" >> $INITFILE
	echo "$iNIT3" >> $INITFILE
	GenRootScript
	if [ $SWAPID -eq 2 ]; then
		# ---- swapoff ----
		echo "swapoff /dev/${DEVDISK}2" >> $INITFILE
	fi
}
#=================== PrepareScript() ===================#


ConfirmInstall() {
	local cmd
	cmd="$STDDIALOG
		--yes-button 'Run now'
		--no-button 'Manual'
		--title 'Install Arch linux'
		--yesno 'Run the script by your hand manually...?' 8 48 ${SWAPSTD}"
	`eval $cmd`
	if [ $? -eq 1 ] ; then
		MsgBox 'Install Arch Linux' "You can press Ctl+Alt+Fn to switch another console, then run $INITFILE."
	else
		$INITFILE
		[ $? -eq 0 ] && MsgBox "Arch Linux Installation" "Install Arch Linux Completely......." && RS=1    # RS=1 is EXIT from Main menu
	fi

	[ -f $CHROOTFILE ] && rm $CHROOTFILE
	[ -f $INITFILE ] && rm $INITFILE
}


ArchCLI() {
	local mch
	local cmd
	local rs=0
	cmd="$STDDIALOG
		--title 'Arch Linux Installation'
		--yesno 'Warning...!\nAll data in /dev/$DEVDISK will be erased, then install...' 8 45 ${SWAPSTD}"
	mch=`eval $cmd`
	rs=$?
	if [ $rs -eq 0 ]; then
		PrepareScript
		ConfirmInstall
	fi
}


SetVGA() {
	local mch
	local cmd
	local rs=0
	cmd="$STDDIALOG
		--title 'VGA Configuration' --default-item '$VDOID' --menu 'Video setting:-' 16 80 8"
	for i in `seq 1 1 6` ; do
		cmd+=" '$i' '${VDODES[$i]}'"
	done
	cmd+=" ${SWAPSTD}"
	mch=`eval $cmd`
	rs=$?
	[ $rs -eq 0 ] && VDOID=$mch
}


SetAudio() {
	local mch
	local cmd
	local rs=0
	cmd="$STDDIALOG
		--title 'Sound/Audio Setting' --default-item '$AUDID' --menu 'Sound setting:-' 10 60 2
		'none'        'Disable/No sound'
		'pulseaudio'  'A featureful, general-purpose sound server' ${SWAPSTD}"
	mch=`eval $cmd`
	rs=$?
	[ $rs -eq 0 ] && AUDID="$mch"
}


Xadditional() {
	local rs=0
	local mch
	local num=`echo "$XPKLIST" | wc -w`
	local cmd="$STDDIALOG
			--title 'Optional X Desktop Packages'
			--checklist 'Application Packages:\n[ $PACKBASE1 ]\nChoose additional packages to install:' 22 80 $num"
	for ep in $XPKLIST ; do
		local pn=${XPKDES["$ep"]}
		local pc=${XPKCHK["$ep"]}
		cmd+=" '$ep' '$pn' '$pc'"
	done
	cmd+=" ${SWAPSTD}"
	mch=`eval $cmd`
	rs=$?
    mch=`echo $mch | sed 's/"//g'`
	if [ $rs -eq 0 ]; then
		for ep in $XPKLIST ; do
			XPKCHK["$ep"]='off'
		done
		XPACKS="$mch"
		for ep in $mch ; do
			XPKCHK["$ep"]='on'
		done
	fi
}


ArchDesktop() {
	local mch
	local num=`echo "$DESKLIST" | wc -w`
	local cmd
	local rs=0
	local initch='mate'
	cmd="$STDDIALOG --nocancel
		--title 'Desktop Environment / Window Manager' --default-item '$DESKTYPE' --menu 'Select the desktop:-' 20 80 12"
	for ep in $DESKLIST ; do
		cmd+=" '$ep' '${DESKDES[$ep]}'"
	done
	cmd+=" ${SWAPSTD}"
	mch=`eval $cmd`
	rs=$?
	[ $rs -eq 0 ] && DESKTYPE=$mch
}


Monitor_Resolution() {
	local mch
	local num=`echo "$DESKLIST" | wc -w`
	local cmd
	local initch='mate'
	cmd="$STDDIALOG --nocancel
		--title 'Default resolution for Monitor' --default-item '$RESOLUTION' --menu 'Select the resolution:-' 18 80 10
			'not define' ''
			'3840x2160'	 ''
			'2560x1080'  ''
			'1920x1440'  ''
			'1920x1080'  ''
			'1600x1200'  ''
			'1400x1050'  ''
			'1280x1024'  ''
			'1280x960'   ''
			'1024x768'   '' ${SWAPSTD}"
	mch=`eval $cmd`
	[ $? -eq 0 ] && RESOLUTION=$mch
}


ArchGUI() {
	local mch
	local cmd
	local rs=0
	local initch='V'
	while [ $rs -eq 0 ]; do
		cmd="$STDDIALOG --ok-button 'Setting' --cancel-button 'Install'
			--title 'Graphical desktop environment' --default-item '$initch' --menu 'Configuration setting:-' 13 80 5
			'V' 'Video Display.........[${VDODES[$VDOID]}]'
			'S' 'Sound Audio...........[$AUDID]'
			'A' 'Additional packages...[as your wish]'
			'D' 'Desktop Environment...[$DESKTYPE]' ${SWAPSTD}
			'M' 'Monitor resolution....[$RESOLUTION]'"
		mch=`eval $cmd`
		rs=$?
		if [ $rs -eq 0 ]; then
			case "$mch" in
				'V' ) SetVGA
					;;
				'S' ) SetAudio
					;;
				'A' ) Xadditional
					;;
				'D' ) ArchDesktop
					;;
				'M' ) Monitor_Resolution
					;;
			esac
			initch=$mch
		elif [ $rs -eq 1 ]; then
			PrepareScript
			GenDesktopScript
			ConfirmInstall			
		fi
	done
}


InstallArch() {
	local mch
	local cmd
	local rs=0
	cmd="$STDDIALOG --cancel-button 'Back'
		--title 'Arch Linux Installation' --default-item 'cli' --menu 'Warning...!  All data in /dev/$DEVDISK will be erased :-' 10 69 2
		'cli'  'Command Line Interface / No Graphical'
		'gui'  'Graphical User Interface' ${SWAPSTD}"
	mch=`eval $cmd`
	rs=$?
	if [ $rs -eq 0 ]; then
		case "$mch" in
			'cli' ) ArchCLI
				;;
			'gui' ) ArchGUI
				;;
		esac
	fi
}


KeyboardMap() {
    local mch
    local cmd
    local rs=0
	local cl=`cat $KEYMAPFILE | wc -l`
	cmd="$STDDIALOG \
		--title 'Your KeyMap' --default-item \"$KEYMAP\" --menu 'Select keymap:-' 24 43 16"
	for i in $(seq 1 1 $cl); do
		local line
		read -r line
		cmd+=" '$line' ''"
	done < $KEYMAPFILE
	cmd+=" ${SWAPSTD}"
	mch=`eval $cmd`
	rs=$?
	if [ $rs -eq 0 ]; then
		KEYMAP=$mch
        loadkeys $mch
	fi
}


#================================================
#|          Preparing initial data              |
#================================================
[ ! -f $TZFILE ] && timedatectl list-timezones > $TZFILE
[ ! -f $KEYMAPFILE ] && localectl list-keymaps > $KEYMAPFILE

if [ ! -f $LSDISKFILE ]; then
	lsblk -l | grep disk > $LSDISKFILE
	NUMDEV=`cat $LSDISKFILE | wc -l`
	for i in $(seq 1 1 $NUMDEV); do
		read -r line
		DSKDEV[$i]=`echo $line | awk '{print $1}'`
		DSKSIZ[$i]=`echo $line | awk '{print $4}'`
	done < $LSDISKFILE
fi

#------------------------------------------------
#=               Start main menu                =
#------------------------------------------------
tput civis
declare VGATYPE=`lspci -k | grep -i ' vga '`
declare CPUTYPE=`lscpu | grep -i 'Model name'`

echo "$VGATYPE" | grep -i ' nvidia '
if [ $? -eq 0 ] ; then
	VDOID=5		# Detec NvidiaGPU
else
	echo "$VGATYPE" | grep -i ' radeon '
	if [ $? -eq 0 ] ; then
		VDOID=2		# Dectect RadeonHD
	else
		echo "$VGATYPE" | grep -i ' amd '
		[ $? -eq 0 ] &&	VDOID=3		# Detect AMDGPU
	fi
fi

echo "$CPUTYPE" | grep -i ' intel '
if [ $? -eq 0 ] ; then
	OPCHCK["intel-ucode"]="on"		# Detect INTEL CPU
	CLILIST+=" intel-ucode"
else 
	echo "$CPUTYPE" | grep -i ' amd '
	if [ $? -eq 0 ] ; then
		OPCHCK["amd-ucode"]="on"		# Detect AMD CPU
		CLILIST+=" amd-ucode"
	fi
fi

until [ $RS != 0 ]; do		# if rs==1 then QUIT
	MainMenu
	if  [ $RS == 0 ]; then
		case $MAINCH in
            0 ) KeyboardMap
                ;;
			1 ) TimeZone
				;;
			2 ) MsgBox "Information" "The Installation will use Mirror servers from Reflector (Python)......"
				;;
			3 ) Hostname
				;;
			4 ) UserAccout
				;;
			5 ) LinuxKernel
				;;
			6 ) OptionalCLI
				;;
			7 ) ServerPackages
				;;
			8 ) DiskPartition
				;;
			9 ) 
				if [ ! $DEVDISK == "none" ]; then
					InstallArch
				else
					MsgBox "!......Error......!" "Please select the target disk...!"
				fi
				;;
		esac
	fi
done
tput cvvis


#---------------------------------------------------------
#|                                                       |
#|           Remove temporary files                      |
#|                                                       |
#---------------------------------------------------------
[ -f $TZFILE ] && rm $TZFILE
[ -f $KEYMAPFILE ] && rm $KEYMAPFILE
[ -f $LSDISKFILE ] && rm $LSDISKFILE
[ -f $CHROOTFILE ] && rm $CHROOTFILE
[ -f $INITFILE ] && rm $INITFILE
[ -f $MINAI_LOCK ] && rm $MINAI_LOCK

exit 0
