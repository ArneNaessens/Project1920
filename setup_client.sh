#!/bin/bash

function command_exists() {
	command -v "$@" >/dev/null 2>&1
}


echo "Installing required items"
if command_exists git; then
		echo "Required items installed"
	else
		echo "Installing git"
		sudo apt-get install git git-core
fi
if command_exists cmake; then
		echo "Required items installed"
	else
		echo "Installing cmake"
		sudo apt-get install cmake
fi


mainmenu_selection=$(whiptail --title "Main Menu" --menu --notags \
	"" 20 78 12 -- \
	"rtl_sdr" "Install RTL SDR support" \
	"rtl_433" "Install rtl 433 package" \
	"setting" "MQTT credentials" \
	"start" "Start service" \
	3>&1 1>&2 2>&3)

case $mainmenu_selection in
"rtl_sdr")
	
    echo "Installing RTL SDR packages"
    cd ~ || return
	sudo apt-get install cmake libusb-1.0-0-dev build-essential
    git clone git://git.osmocom.org/rtl-sdr.git
    cd rtl-sdr/ 
	mkdir build 
	cd build/ 
    cmake ../
    sudo make
    sudo make install
    sudo ldconfig

	if (whiptail --title "Restart Required" --yesno "It is recommended that you restart you device now. Select yes to do so now" 20 78); then
		sudo reboot
	fi
;;

"rtl_433")

	echo "Installing rtl_433 package"
	sudo apt-get install libtool libusb-1.0.0-dev librtlsdr-dev
	rtl-sdr doxygen
	git clone https://github.com/merbanan/rtl_433.git
	cd rtl_433/
	mkdir build
	cd build 
	cmake ../
	make
	sudo make install
	sudo yum install -y supervisor
;;

"setting")
	server=$(whiptail --inputbox "Input MQTT server remote ip address" 8 78 localhost --title "Remote Server" 3>&1 1>&2 2>&3)
	username=$(whiptail --inputbox "Username for MQTT server" 8 78 admin --title "Username" 3>&1 1>&2 2>&3)
	password=$(whiptail --passwordbox "please enter your secret password for MQTT server" 8 78 --title "password" 3>&1 1>&2 2>&3)

	sudo mkdir /var/log/rtl_433
;;

"start")
	sudo systemctl start stweather.service
;;

*) ;;
esac
