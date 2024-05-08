#!/bin/bash
# ============================================================================
# |                   minArchinstall.sh                                      |
# | This is a shell script for install Arch Linux in simply way.             |
# | Writen by: T.Apichart                                     	             |
# | Date: Apr,16 2024                                                        |
# ============================================================================
ping -c 1 www.google.com
if [ "$?" -eq 2 ]; then
	printf "Internet Connection........\033[1;31mE.R.R.O.R\033[0m...!\n"
	exit 2
fi

#-----------------------------------------------------------------------------#
#  Waiting for the process Reflector to generate /etc/pacman.d/mirroslist     #
#-----------------------------------------------------------------------------#
WaitReflector() {
	clear
	while [ `ps -C reflector | wc -l` -gt 1 ]
	do
		printf "\033[1;34mPlease waiting for [Reflector] process has finished.\033[0m..."
		sleep 2
	done
}

#----------------------------------------------------------#
#  If there is not a CLI-dialog then installing by pacman  #
#----------------------------------------------------------#
WaitReflector
if [ ! -f /usr/bin/dialog ]; then
    pacman -Sy
    pacman --noconfirm -S dialog
fi

#SWAPSTD="2>&1"
TZFILE="/tmp/minAI_timezone.tmp"
LSDISKFILE="/tmp/minAI_disk.tmp"
CHROOTFILE="/root/minAI_chroot.sh"
INITFILE="/tmp/minAI_init.sh"
TIMEZONE="Asia/Bangkok"
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

declare CLILIST=""
OPTIONS="htop git zip unzip sysstat perf nano os-prober mtools dosfstools wget curl ntfs-3g neofetch amd-ucode intel-ucode"
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
declare -A OPCHCK
OPCHCK["htop"]="on"
OPCHCK["git"]="off"
OPCHCK["zip"]="on"
OPCHCK["unzip"]="on"
OPCHCK["sysstat"]="off"
OPCHK["perf"]="off"
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

declare XPKLIST="vlc firefox libreoffice mousepad leafpad notepadqq gimp inkscape darktable xdg-user-dirs gvfs"
declare XPACKS="vlc firefox mousepad xdg-user-dirs"
declare XFIXPK="noto-fonts"
declare -A XPKDES
XPKDES["vlc"]="Media player"
XPKDES["firefox"]="Firefox Web Browser"
XPKDES["libreoffice"]="LibreOffice - Office suit"
XPKDES["mousepad"]="MousePad text editor"
XPKDES["leafpad"]="A notepad clone for GTK+ 2.0"
XPKDES["xdg-user-dirs"]="Extra - Manage user directories"
XPKDES["notepadqq"]="Notepad++ text editor"
XPKDES["gimp"]="GNU Image Manipulation Program"
XPKDES["inkscape"]="Professional vector graphics editor"
XPKDES["darktable"]="Utility to organize and develop raw images"
XPKDES["gvfs"]="Virtual filesystem implementation for GIO"
declare -A XPKCHK
XPKCHK["vlc"]="on"
XPKCHK["firefox"]="on"
XPKCHK["libreoffice"]="off"
XPKCHK["mousepad"]="on"
XPKCHK["leafpad"]="off"
XPKCHK["notepadqq"]="off"
XPKCHK["gimp"]="off"
XPKCHK["inkscape"]="off"
XPKCHK["darktable"]="off"
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
declare DESKLIST="mate xfce lxde lxqt deepin gnome kde bspwm"
declare DESKTYPE="mate"
declare -A DESKDES
DESKDES["mate"]="MATE Desktop Environment"
DESKDES["xfce"]="XFCE4 Desktop Environment"
DESKDES["lxde"]="Lightweight X11 Desktop Environment"
DESKDES["lxqt"]="Lightweight X11 Qt Desktop Environment"
DESKDES["deepin"]="Deepin Desktop Environment"
DESKDES["gnome"]="GNome Desktop Environment"
DESKDES["kde"]="KDE Plasma Desktop Environment"
DESKDES["bspwm"]="Tiling Window Manager"
declare -A DESKPAK
DESKPAK["mate"]="$LIGHTDM mate mate-extra"
DESKPAK["xfce"]="lxdm xfce4 xfce4-goodies"
DESKPAK["lxde"]="lxde"
DESKPAK["lxqt"]="$LIGHTDM lightdm-webkit-theme-litarvan lxqt lxqt-themes breeze-icons xscreensaver"
DESKPAK["deepin"]="$LIGHTDM deepin deepin-kwin"
DESKPAK["gnome"]="gdm gnome gnome-extra gnome-tweaks"
DESKPAK["kde"]="sddm plasma kde-applications packagekit-qt5"
DESKPAK["bspwm"]="$LIGHTDM bspwm sxhkd picom polybar dmenu alacritty nitrogen"

declare NUMDEV=0
declare -a DSKDEV
declare -a DSKSIZ

BACKTITLE="minArchinstall version 1.0.0 :  Bash Shell Script for intalling Arch Linux in minimal style.  Support only GPT/EFI without Encryption"	
STDDIALOG="dialog --stdout --backtitle \"$BACKTITLE\""

MainMenu() {
	local mch
	local cmd
	local initdev="none"
	[ "$DEVDISK" != "none" ] && initdev="/dev/$DEVDISK"
	cmd="$STDDIALOG --cancel-button 'Quit' \
		--title 'Main Menu' --default-item \"${MAINCH}\" --menu 'Select menu:-' 16 62 9 \
		'1' 'Timezone ..................[$TIMEZONE]' \
		'2' 'Server mirror list.........[$MIRRORTH]' \
		'3' 'Hostname ..................[$HOSTNAME]' \
		'4' 'User and password .........[$SUPERUSR]' \
		'5' 'Type of Linux Kernel ......[$KERNELTP]' \
		'6' 'Optional packages .........[as your wish]' \
		'7' 'Server packages............[as your wish]' \
		'8' 'Disk partitions............[$initdev]' \
		'9' '[...Next step to Install...]' "
	mch=`eval $cmd`
	RS=$?
	if [ $RS -eq 0 ]; then
		MAINCH=$mch
	fi
}


TimeZone() {
	local mch
	local cmd
	local rs
	local cl=`cat $TZFILE | wc -l`
	cmd="$STDDIALOG \
		--title 'Your timezone' --default-item \"$TIMEZONE\" --menu 'Select timezone:-' 24 40 20"
	for i in $(seq 1 1 $cl); do
		local line
		read -r line
		cmd+=" '$line' ''"
	done < $TZFILE
	mch=`eval $cmd`
	rs=$?
	if [ $rs -eq 0 ]; then
		TIMEZONE=$mch
	fi
}


Hostname() {
	local mch
	local cmd
	local rs
	cmd="$STDDIALOG --max-input 25 \
		--title 'Define Hostname' --inputbox 'Enter hostname:-' 7 40 '$HOSTNAME'"
	mch=`eval $cmd`
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
	local rs
	cmd="$STDDIALOG \
		--title 'LINUX KERNEL' --default-item \"${KERNELTP}\" --menu 'Select type of kernel:-' 11 80 4 \
		'linux' 'Stable-Vanilla Linux kernel and modules, with patches' \
		'linux-lts' 'Long-term support(LTS)' \
		'linux-hardened' 'A security-focused Linux kernel' \
		'linux-zen' 'Result of a collaborative effort of kernel hackers' "
	mch=`eval $cmd`
	rs=$?
	if [ $rs == 0 ] ; then
		KERNELTP=$mch
	fi
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
	local rs
	cmd="$STDDIALOG --max-input 25 \
		--title 'Define user name for Super User' --inputbox 'User name as Admin user:-' 7 40 '$SUPERUSR'"
	mch=`eval $cmd`
	rs=$?
	if [ $rs -eq 0 ] ; then
		SUPERUSR=$mch
	fi
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
	cmd="$STDDIALOG --insecure --max-input 30 \
		--title 'Set password for [$SUPERUSR]' 
		--passwordbox 'Password should be at least 8 characters long with 1 uppercase, and 1 lowercase:-' 8 45 '$initpass' "
	mch=`eval $cmd`
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
	local -a pswd=( "none" "diff" )
	local idx=0
	local cmd
	local rs
	local initpass=$ROOTPASS
	cmd="$STDDIALOG --insecure --max-input 30 \
		--title \"Set root's password\" --passwordform \"Enter rot's password:-\" 10 48 3 \
		'Password : ' 1 1 '$initpass' 1 18 23 0 \
		'Retry password : ' 2 1 '$initpass' 2 18 23 0 "
	mch=`eval $cmd`
	rs=$?
	if [ $rs -eq 0 ] ; then
		for i in $mch; do
			pswd[$idx]=$i
			idx=`expr $idx + 1`
		done
		if [ "${pswd[0]}" != "${pswd[1]}" ]; then
			MsgBox "Error in passwords" "Those passwords did not match. try again..."
		else
			local ck=$(CheckPassword "${pswd[0]}")
			if [ "$ck" == "Valid password" ]; then
				ROOTPASS="${pswd[0]}"
				MsgBox "Accept Password" "$ck"
				ROOTABLE="enable"
			else
				MsgBox "Error in Password" "$ck"
				ROOTABLE="disable"
			fi
		fi
	fi
}


RootSelect() {
	local mch
	local cmd
	local rs=0
	local initch="$ROOTABLE"
	cmd="$STDDIALOG --cancel-button 'Back' \
		--title 'Setting root user' --default-item \"$initch\" --menu 'Select menu:-' 15 65 3 \
		'disable'   'Disable - root can not login' \
		'enable'    'Enable - set password for root' "
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

		cmd="$STDDIALOG --cancel-button 'Back' \
			--title 'User account manament' --default-item \"$initch\" --menu 'Select menu:-' 15 65 3 \
			'root'   'Set password for root User........[$initrt]' \
			'user'   'Define user name for Super User...[$SUPERUSR]' \
			'passwd' 'Set password for Super User.......[$passval]' "
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
	local cmd="$STDDIALOG \
			--title 'Optional Command Line Packages' \
			--checklist 'These packages are the basics, has already included after installation:\n[ $PACKBASE1 ]\nChoose additional packages to install:' 22 80 $num"
	for ep in $OPTIONS ; do
		local pn=${OPDESC["$ep"]}
		local pc=${OPCHCK["$ep"]}
		cmd+=" '$ep' '$pn' '$pc'"
	done
	mch=`eval $cmd`
	rs=$?
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
	local cmd="$STDDIALOG \
			--title 'Server / Service Packages list' \
			--checklist 'Choose packages to install:' 22 80 $num"
	for ep in $OPTSERV ; do
		local pn=${SRVDES["$ep"]}
		local pc=${SRVCHK["$ep"]}
		cmd+=" '$ep' '$pn' '$pc'"
	done
	mch=`eval $cmd`
	rs=$?
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
	local rs
	local initch
	[ ! "$DEVDISK" == "none" ] && initch="$DEVDISK"
	cmd="$STDDIALOG \
		--title 'Select the target disk for Arch linux.' --default-item \"$initch\" --menu 'Choose Disk device :-' 12 45 4"
	for i in `seq 1 1 $NUMDEV` ; do
		cmd+=" '${DSKDEV[$i]}' '${DSKSIZ[$i]}'"
	done
	mch=`eval $cmd`
	rs=$?
	if [ $rs -eq 0 ]; then
		DEVDISK="$mch"
	fi
}


SwapType() {
	local mch
	local cmd
	local rs
	cmd="$STDDIALOG \
		--title 'How to manage swap memory?' --default-item \"$SWAPID\" --menu 'Swap as:-\nIf using swap, it is fix at 2Gb' 12 35 4"
	for i in `seq 0 1 2` ; do
		cmd+=" '$i' '${SWAPDES[$i]}'"
	done
	mch=`eval $cmd`
	rs=$?
	if [ $rs -eq 0 ]; then
		SWAPID=$mch
	fi
}


MountVolume() {
	local mch
	local cmd
	local rs
	cmd="$STDDIALOG \
		--title 'Set the partitioning format' --default-item \"$MNTTID\" --menu 'Mount Volume as:-' 12 35 4"
	for i in `seq 0 1 2` ; do
		cmd+=" '$i' '${MNTDES[$i]}'"
	done
	mch=`eval $cmd`
	rs=$?
	if [ $rs -eq 0 ]; then
		MNTTID=$mch
	fi
}


DiskPartition() {
	local mch
	local cmd
	local rs=0
	local initch='swap'
	while [ $rs -eq 0 ]; do
		cmd="$STDDIALOG --cancel-button 'Back' \
			--title 'Disk partitions' --default-item '$initch' --menu 'Warning...!\nAll data in the target disk will be erased :-' 15 60 8 \
			'swap'  'Swap space and paging...[${SWAPDES[$SWAPID]}]' \
			'dev'   'Disk device to install..[$DEVDISK]' \
			'mount' 'Mount volume ...........[ ${MNTDES[$MNTTID]} ]' "
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


GenMountScript() {
	local endboot="501MiB"
	local nxpart
	local devdisk="/dev/$DEVDISK"
	printf "parted -s $devdisk mklabel gpt\n" >> $INITFILE
	printf "parted -s $devdisk mkpart primary fat32 1MiB $endboot\n" >> $INITFILE
	printf "parted -s $devdisk set 1 esp on\n" >> $INITFILE
	printf "mkfs.fat -F32 ${devdisk}1\n" >> $INITFILE
	if [ $SWAPID -eq 2 ]; then
		# ---- create swap partition ----
		printf "parted -s $devdisk mkpart primary linux-swap $endboot 3GiB\n" >> $INITFILE
		printf "mkswap ${devdisk}2\n" >> $INITFILE
		nxpart="3GiB"
		case $MNTTID in
			0 ) printf "parted -s $devdisk mkpart primary ext4 $nxpart 100%%\n" >> $INITFILE
				printf "mkfs.ext4 -F ${devdisk}3\n" >> $INITFILE
				printf "mount ${devdisk}3 /mnt\n" >> $INITFILE
				printf "mkdir -p /mnt/boot/EFI\n" >> $INITFILE
				printf "mount ${devdisk}1 /mnt/boot/EFI\n" >> $INITFILE
				;;
			1 ) printf "parted -s $devdisk mkpart primary ext4 $nxpart 20GiB\n" >> $INITFILE
				printf "parted -s $devdisk mkpart primary ext4 20GiB 100%%\n" >> $INITFILE
				printf "mkfs.ext4 -F ${devdisk}3\n" >> $INITFILE
				printf "mkfs.ext4 -F ${devdisk}4\n" >> $INITFILE
				printf "mount ${devdisk}3 /mnt\n" >> $INITFILE
				printf "mkdir -p /mnt/boot/EFI /mnt/home\n" >> $INITFILE
				printf "mount ${devdisk}1 /mnt/boot/EFI\n" >> $INITFILE
				printf "mount ${devdisk}4 /mnt/home\n" >> $INITFILE
				;;
			2 ) printf "parted -s $devdisk mkpart primary ext4 $nxpart 20GiB\n" >> $INITFILE
				printf "parted -s $devdisk mkpart primary ext4 20GiB 25GiB\n" >> $INITFILE
				printf "parted -s $devdisk mkpart primary ext4 25GiB 30GiB\n" >> $INITFILE
				printf "parted -s $devdisk mkpart primary ext4 30GiB 100%%\n" >> $INITFILE
				printf "mkfs.ext4 -F ${devdisk}3\n" >> $INITFILE
				printf "mkfs.ext4 -F ${devdisk}4\n" >> $INITFILE
				printf "mkfs.ext4 -F ${devdisk}5\n" >> $INITFILE
				printf "mkfs.ext4 -F ${devdisk}6\n" >> $INITFILE
				printf "mount ${devdisk}3 /mnt\n" >> $INITFILE
				printf "mkdir -p /mnt/boot/EFI /mnt/{home,var,tmp}\n" >> $INITFILE
				printf "mount ${devdisk}1 /mnt/boot/EFI\n" >> $INITFILE
				printf "mount ${devdisk}4 /mnt/var\n" >> $INITFILE
				printf "mount ${devdisk}5 /mnt/tmp\n" >> $INITFILE
				printf "mount ${devdisk}6 /mnt/home\n" >> $INITFILE
				;;
		esac
		printf "swapon ${devdisk}2\n" >> $INITFILE
	else
		nxpart=$endboot
		case $MNTTID in
			0 ) printf "parted -s $devdisk mkpart primary ext4 $nxpart 100%%\n" >> $INITFILE
				printf "mkfs.ext4 -F ${devdisk}2\n" >> $INITFILE
				printf "mount ${devdisk}2 /mnt\n" >> $INITFILE
				printf "mkdir -p /mnt/boot/EFI\n" >> $INITFILE
				printf "mount ${devdisk}1 /mnt/boot/EFI\n" >> $INITFILE
				;;
			1 ) printf "parted -s $devdisk mkpart primary ext4 $nxpart 20GiB\n" >> $INITFILE
				printf "parted -s $devdisk mkpart primary ext4 20GiB 100%%\n" >> $INITFILE
				printf "mkfs.ext4 -F ${devdisk}2\n" >> $INITFILE
				printf "mkfs.ext4 -F ${devdisk}3\n" >> $INITFILE
				printf "mount ${devdisk}2 /mnt\n" >> $INITFILE
				printf "mkdir -p /mnt/boot/EFI /mnt/home\n" >> $INITFILE
				printf "mount ${devdisk}1 /mnt/boot/EFI\n" >> $INITFILE
				printf "mount ${devdisk}3 /mnt/home\n" >> $INITFILE
				;;
			2 ) printf "parted -s $devdisk mkpart primary ext4 $nxpart 20GiB\n" >> $INITFILE
				printf "parted -s $devdisk mkpart primary ext4 20GiB 25GiB\n" >> $INITFILE
				printf "parted -s $devdisk mkpart primary ext4 25GiB 30GiB\n" >> $INITFILE
				printf "parted -s $devdisk mkpart primary ext4 30GiB 100%%\n" >> $INITFILE
				printf "mkfs.ext4 -F ${devdisk}2\n" >> $INITFILE
				printf "mkfs.ext4 -F ${devdisk}3\n" >> $INITFILE
				printf "mkfs.ext4 -F ${devdisk}4\n" >> $INITFILE
				printf "mkfs.ext4 -F ${devdisk}5\n" >> $INITFILE
				printf "mount ${devdisk}2 /mnt\n" >> $INITFILE
				printf "mkdir -p /mnt/boot/EFI /mnt/{home,var,tmp}\n" >> $INITFILE
				printf "mount ${devdisk}1 /mnt/boot/EFI\n" >> $INITFILE
				printf "mount ${devdisk}3 /mnt/var\n" >> $INITFILE
				printf "mount ${devdisk}4 /mnt/tmp\n" >> $INITFILE
				printf "mount ${devdisk}5 /mnt/home\n" >> $INITFILE
				;;
		esac
		# ---- make /swapfile ----
		if [ $SWAPID -eq 1 ]; then
			printf "dd if=/dev/zero of=/mnt/swapfile bs=1M count=2560\n" >> $INITFILE
			printf "chmod 600 /mnt/swapfile\n" >> $INITFILE
			printf "mkswap /mnt/swapfile\n" >> $INITFILE
		fi
	fi
}


GenDesktopScript() {
	printf "\npacman --noconfirm -S xorg network-manager-applet archlinux-wallpaper\n">> $CHROOTFILE
	printf "[ \$? -ne 0 ] && PauseError 'Install [xorg...] incomplete'\n" >> $CHROOTFILE
	printf "pacman --noconfirm -S ${DESKPAK[$DESKTYPE]}\n" >> $CHROOTFILE
	printf "[ \$? -ne 0 ] && PauseError 'Install [$DESKTYPE...] incomplete'\n" >> $CHROOTFILE
	if [ "$DESKTYPE" == "mate" ]; then
		printf "sed -i '/#greeter-session=/c\\greeter-session=lightdm-gtk-greeter' /etc/lightdm/lightdm.conf\n" >> $CHROOTFILE
		printf "systemctl enable lightdm\n" >> $CHROOTFILE
	elif [ "$DESKTYPE" == "xfce" ]; then
		printf "sed -i '/# session=/c\\session=startxfce4' /etc/lxdm/lxdm.conf\n" >> $CHROOTFILE
		printf "systemctl enable lxdm\n" >> $CHROOTFILE
	elif [ "$DESKTYPE" == "deepin" ]; then
		printf "sed -i '/#greeter-session=/c\\greeter-session=lightdm-gtk-greeter' /etc/lightdm/lightdm.conf\n" >> $CHROOTFILE
		printf "systemctl enable lightdm\n" >> $CHROOTFILE
		printf "pacman --noconfirm -S deepin-{terminal,calculator,clipboard,community-wallpapers}\n" >> $CHROOTFILE
		printf "[ \$? -ne 0 ] && PauseError 'Install [deepin] incomplete.'\n" >> $CHROOTFILE
	elif [ "$DESKTYPE" == "lxde" ]; then
		printf "systemctl enable lxdm\n" >> $CHROOTFILE
	elif [ "$DESKTYPE" == "lxqt" ]; then
		printf "sed -i '/#greeter-session=/c\\greeter-session=lightdm-webkit2-greeter' /etc/lightdm/lightdm.conf\n" >> $CHROOTFILE
		printf "sed -i 's/= antergos/= litarvan/g' /etc/lightdm/lightdm-webkit2-greeter.conf\n" >> $CHROOTFILE
		printf "sed -i 's/icon_theme=oxygen/icon_theme=Adwaita/g' /usr/share/lxqt/lxqt.conf\n" >> $CHROOTFILE
		printf "sed -i '/icon_theme=/c\\icon_theme=breeze-dark' /home/$SUPERUSR/.config/lxqt/lxqt.conf\n" >> $CHROOTFILE
		printf "systemctl enable lightdm\n" >> $CHROOTFILE
	elif [ "$DESKTYPE" == "gnome" ]; then
		printf "sed -i 's/#Wayland/Wayland/g' /etc/gdm/custom.conf\n" >> $CHROOTFILE
		printf "systemctl enable gdm\n" >> $CHROOTFILE
	elif [ "$DESKTYPE" == "kde" ]; then
		printf "systemctl enable sddm\n" >> $CHROOTFILE
	elif [ "$DESKTYPE" == "bspwm" ] ; then
		printf "mkdir -p /home/$SUPERUSR/.config/{bspwm,sxhkd,polybar,picom}\n" >> $CHROOTFILE
		printf "cp /usr/share/doc/bspwm/examples/bspwmrc /home/$SUPERUSR/.config/bspwm\n" >> $CHROOTFILE
		printf "cp /usr/share/doc/bspwm/examples/sxhkdrc /home/$SUPERUSR/.config/sxhkd\n" >> $CHROOTFILE
		printf "cp /etc/xdg/picom.conf /home/$SUPERUSR/.config/picom\n" >> $CHROOTFILE
		printf "cp /etc/polybar/config.ini /home/$SUPERUSR/.config/polybar\n" >> $CHROOTFILE
		printf "chmod +x /home/$SUPERUSR/.config/bwpwmrc\n" >> $CHROOTFILE
		printf "echo 'sxhkd &\n" >> $CHROOTFILE
		printf "picom --config ~/.config/picom/picom.conf &\n" >> $CHROOTFILE
		printf "nitrogen --restore &\n" >> $CHROOTFILE
		printf "polybar &' >> /home/$SUPERUSR/.config/bspwm/bspwmrc\n" >> $CHROOTFILE
		printf "sed -i 's/urxvt/alacritty/g' /home/$SUPERUSR/.config/sxhkd/sxhkdrc\n" >> $CHROOTFILE
		printf "echo 'super + e\n" >> $CHROOTFILE
		printf "	thunar' >> /home/$SUPERUSR/.config/sxhkd/sxhkdrc\n" >> $CHROOTFILE
		printf "chown -R $SUPERUSR:users /home/$SUPERUSR/.config\n" >> $CHROOTFILE
		printf "systemctl enable lightdm\n" >> $CHROOTFILE
	fi

	printf "pacman --noconfirm -S ${VDOPACK[$VDOID]}\n" >> $CHROOTFILE
	printf "[ \$? -ne 0 ] && PauseError 'Install [${VDOPACK[$VDOID]}] incomplete.'\n" >> $CHROOTFILE
	if [ $AUDID != "none" ]; then
		printf "pacman --noconfirm -S $AUDPACK\n" >> $CHROOTFILE
	fi
	printf "pacman --noconfirm -S noto-fonts $XPACKS\n" >> $CHROOTFILE
	printf "[ \$? -ne 0 ] && PauseError 'Additional packages for GUI incomplete.'\n" >> $CHROOTFILE
}


GenRootScript() {
	printf "#!/bin/bash\n\n\n" > $CHROOTFILE
	printf "PauseError() {\n" >> $CHROOTFILE
	printf "	local pkey\n" >> $CHROOTFILE
	printf "	echo '#*--------------------------------------------*'\n" >> $CHROOTFILE
	printf "	echo \"#  Warning : \$1  #\"\n" >> $CHROOTFILE
	printf "	echo '#*--------------------------------------------*'\n" >> $CHROOTFILE
	printf "	read -p 'Do you want to continue?...<Y/n>:' pkey\n" >> $CHROOTFILE
	printf "	if [ \"$pkey\" == 'N' ] || [ \"$pkey\" =='n' ] ; then\n" >> $CHROOTFILE
	printf "		exit 2\n" >> $CHROOTFILE
	printf "	fi\n" >> $CHROOTFILE
	printf "}\n\n" >> $CHROOTFILE
	printf "echo 'en_US.UTF-8 UTF-8' > /etc/local.gen\n" >> $CHROOTFILE
	printf "echo 'en_US ISO-8859-1' >> /etc/local.gen\n" >> $CHROOTFILE
	printf "locale-gen\n" >> $CHROOTFILE
	printf "echo 'LANG=en_US.UTF-8'\n" >> $CHROOTFILE
	printf "echo '$HOSTNAME' > /etc/hostname\n" >> $CHROOTFILE
	printf "echo '127.0.0.1 localhost' >> /etc/hosts\n" >> $CHROOTFILE
	printf "echo '::1 localhost' >> /etc/hosts\n" >> $CHROOTFILE
	printf "echo '127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}' >> /etc/hosts\n" >> $CHROOTFILE
	printf "pacman --noconfirm -S ${OPPACKS2} ${CLILIST} ${SERVLIST}\n" >> $CHROOTFILE
	printf "[ \$? -ne 0 ] && PauseError 'linux_cli packages incomplete.'\n" >> $CHROOTFILE
	printf "systemctl enable NetworkManager\n" >> $CHROOTFILE
	printf "mkinitcpio -P\n" >> $CHROOTFILE
	printf "echo 'root:${ROOTPASS}' | chpasswd\n" >> $CHROOTFILE
	printf "useradd -m -g users -G wheel,storage,power,audio,video ${SUPERUSR}\n" >> $CHROOTFILE
	printf "echo '${SUPERUSR}:${SUPERPAS}' | chpasswd\n" >> $CHROOTFILE
	printf "sed -i 's/# %%wheel ALL=(ALL) ALL/%%wheel ALL=(ALL) ALL/g' /etc/sudoers\n" >> $CHROOTFILE
	printf "sed -i 's/# %%wheel ALL=(ALL:ALL) ALL/%%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers\n" >> $CHROOTFILE
	printf "echo 'source \$VIMRUNTIME/defaults.vim' > /home/${SUPERUSR}/.vimrc\n" >> $CHROOTFILE
	printf "echo 'set number' >> /home/${SUPERUSR}/.vimrc\n" >> $CHROOTFILE
	printf "chown ${SUPERUSR}:users /home/${SUPERUSR}/.vimrc\n" >> $CHROOTFILE
	printf "chmod 600 /home/${SUPERUSR}/.vimrc\n" >> $CHROOTFILE
	if [ "${OPCHCK["neofetch"]}" == "on" ] ; then
		printf "echo 'neofetch' >> /home/${SUPERUSR}/.bash_profile\n" >> $CHROOTFILE
	else
		printf "echo 'screenfetch' >> /home/${SUPERUSR}/.bash_profile\n" >> $CHROOTFILE
	fi
	printf "pacman --noconfirm -S grub efibootmgr\n" >> $CHROOTFILE
	printf "[ \$? -ne 0 ] && PauseError 'Install [grub efibootmgr] incomplete.'\n" >> $CHROOTFILE
	printf "grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=GRUB\n" >> $CHROOTFILE
	printf "[ \$? -ne 0 ] && PauseError 'grub-install incomplete.'\n" >> $CHROOTFILE
	printf "grub-mkconfig -o /boot/grub/grub.cfg\n" >> $CHROOTFILE
	printf "[ \$? -ne 0 ] && PauseError 'grub-mkconfig incomplete.'\n" >> $CHROOTFILE
	[ $ROOTABLE == "disable" ] && printf "usermod -s /usr/bin/nologin root\n" >> $CHROOTFILE
}


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

	printf "#!/bin/bash\n\n\n" > $INITFILE
	printf "PauseError() {\n" >> $INITFILE
	printf "	local pkey\n" >> $INITFILE
	printf "	echo '#*--------------------------------------------*'\n" >> $INITFILE
	printf "	echo \"#  Error : \$1  #\"\n" >> $INITFILE
	printf "	echo '#*--------------------------------------------*'\n" >> $INITFILE
	printf "	read -p 'Press any key...' pkey\n" >> $INITFILE
	printf "}\n\n" >> $INITFILE
	printf "timedatectl set-timezone %s\n" "$TIMEZONE" >> $INITFILE
	printf "timedatectl set-ntp true\n" >> $INITFILE
	printf "hwclock --systohc\n" >> $INITFILE
	printf "pacman -Sy\n" >> $INITFILE
	GenMountScript
	printf "pacstrap -K /mnt $PACKBASE ${kernel} $PACKBASE1\n" >> $INITFILE
	printf "[ \$? -ne 0 ] && PauseError 'pacstrap -K /mnt incomplete.'\n" >> $INITFILE
	printf "genfstab -U /mnt >> /mnt/etc/fstab\n" >> $INITFILE
	if [ $SWAPID -eq 1 ]; then
		printf "echo '/swapfile none swap defaults 0 0' >> /mnt/etc/fstab\n" >> $INITFILE
	fi
	printf "cp /etc/hosts /mnt/etc/hosts\n" >> $INITFILE
	printf "echo \"FONT=ter-v20n\" > /mnt/etc/vconsole.conf\n" >> $INITFILE
	printf "ln -sf /usr/share/zoneinfo/$TIMEZONE /mnt/etc/localtime\n" >> $INITFILE
	printf "cp $CHROOTFILE /mnt${CHROOTFILE}\n" >> $INITFILE
	printf "chmod 700 /mnt${CHROOTFILE}\n" >> $INITFILE
	printf "sed -i '/#Color/c\\Color' /mnt/etc/pacman.conf\n" >> $INITFILE
	printf "sed -i '/#ParallelDownloads/c\\ParallelDownloads = 2' /mnt/etc/pacman.conf\n" >> $INITFILE
	printf "arch-chroot /mnt $CHROOTFILE\n" >> $INITFILE
	printf "#rm /mnt$CHROOTFILE\n" >> $INITFILE
	printf "umount -R /mnt\n" >> $INITFILE
	GenRootScript
	if [ $SWAPID -eq 2 ]; then
		# ---- swapoff ----
		printf "swapoff /dev/${DEVDISK}2\n" >> $INITFILE
	fi
}


ConfirmInstall() {
	local mch
	local cmd
	local rs
	cmd="$STDDIALOG \
		--yes-label 'Manual'
		--no-label 'Run now'
		--title 'Install Arch linux' \
		--yesno 'Run the script by your hand manually...?' 8 48 "
	mch=`eval $cmd`
	rs=$?
	if [ $rs -eq 0 ] ; then
		MsgBox 'Install Arch Linux' "You can press Ctl+Alt+Fn to switch another console, then run $INITFILE."
	else
		$INITFILE
		MsgBox "Arch Linux Installation" "Install Arch Linux Completely......."
	fi
}


ArchCLI() {
	local mch
	local cmd
	local rs=0
	cmd="$STDDIALOG \
		--title 'Arch Linux Installation' \
		--yesno 'Warning...!\nAll data in /dev/$DEVDISK will be erased, then install...' 7 40 "
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
	cmd="$STDDIALOG \
		--title 'VGA Configuration' --default-item '$VDOID' --menu 'Video setting:-' 15 80 8"
	for i in `seq 1 1 6` ; do
		cmd+=" '$i' '${VDODES[$i]}'"
	done
	mch=`eval $cmd`
	rs=$?
	[ $rs -eq 0 ] && VDOID=$mch
}


SetAudio() {
	local mch
	local cmd
	local rs=0
	cmd="$STDDIALOG \
		--title 'Sound/Audio Setting' --default-item '$AUDID' --menu 'Sound setting:-' 9 60 2 \
		'none'        'Disable/No sound' \
		'pulseaudio'  'A featureful, general-purpose sound server' "
	mch=`eval $cmd`
	rs=$?
	[ $rs -eq 0 ] && AUDID="$mch"
}


Xadditional() {
	local rs=0
	local -A mch
	local num=`echo "$XPKLIST" | wc -w`
	local cmd="$STDDIALOG \
			--title 'Optional X Desktop Packages' \
			--checklist 'Application Packages:\n[ $PACKBASE1 ]\nChoose additional packages to install:' 22 80 $num"
	for ep in $XPKLIST ; do
		local pn=${XPKDES["$ep"]}
		local pc=${XPKCHK["$ep"]}
		cmd+=" '$ep' '$pn' '$pc'"
	done
	mch=`eval $cmd`
	rs=$?
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
	local initch='swap'
	cmd="$STDDIALOG --no-cancel \
		--title 'Desktop Environment / Window Manager' --default-item '$DESKTYPE' --menu 'Select the desktop:-' 15 80 6"
	for ep in $DESKLIST ; do
		cmd+=" '$ep' '${DESKDES[$ep]}'"
	done
	mch=`eval $cmd`
	rs=$?
	[ $rs -eq 0 ] && DESKTYPE=$mch
}


ArchGUI() {
	local mch
	local cmd
	local rs=0
	local initch='swap'
	while [ $rs -eq 0 ]; do
		cmd="$STDDIALOG --ok-label 'Change' --cancel-button 'Install' \
			--title 'Graphical desktop environment' --default-item '$initch' --menu 'Configuration setting:-' 11 80 5 \
			'V' 'Video Display.........[${VDODES[$VDOID]}]' \
			'S' 'Sound Audio...........[$AUDID]' \
			'A' 'Additional packages...[as your wish]' \
			'D' 'Desktop Environment...[$DESKTYPE]' "
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
	cmd="$STDDIALOG --cancel-button 'Back' \
		--title 'Arch Linux Installation' --default-item 'cli' --menu 'Warning...!\nAll data in /dev/$DEVDISK will be erased :-' 10 50 3 \
		'cli'  'Command Line Interface / No Graphical' \
		'gui'  'Graphical User Interface' "
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

#================================================
#|          Preparing initail data              |
#================================================
[ ! -f $TZFILE ] && timedatectl list-timezones > $TZFILE

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
until [ $RS != 0 ]; do		# if rs==1 then QUIT
	MainMenu
	if  [ $RS == 0 ]; then
		case $MAINCH in
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


#---------------------------------------------------------
#|                                                       |
#|           Remove temporary files                      |
#|                                                       |
#---------------------------------------------------------
[ -f $TZFILE ] && rm $TZFILE
[ -f $LSDISKFILE ] && rm $LSDISKFILE
[ -f $CHROOTFILE ] && rm $CHROOTFILE
[ -f $INITFILE ] && rm $INITFILE

exit 0
