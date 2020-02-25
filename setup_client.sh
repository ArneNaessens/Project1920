#!/bin/bash

function command_exists() {
	command -v "$@" >/dev/null 2>&1
}


echo "Installing required items"

sudo apt-get install git



mainmenu_selection=$(whiptail --title "Main Menu" --menu --notags \
	"" 20 78 12 -- \
	"rtl_sdr" "Install RTL SDR support" \
	"rtl_433" "Install required packages" \
	3>&1 1>&2 2>&3)

case $mainmenu_selection in
"docker")
	
    echo "Installing RTL SDR packages"
    cd ~
    sudo apt-get install git git-core cmake libusb-1.0-0-dev build-essential
    git clone git://git.osmocom.org/rtl-sdr.git
    cd rtl-sdr/ && mkdir build && cd build/
    cmake ../ -DINSTALL_UDEV_RULES=ON
    sudo make
    sudo make install
    sudo ldconfig
    cd ~
    sudo cp ./rtl-sdr/rtl-sdr.rules /etc/udev/rules.d/
    "blacklist dvb_usb_rtl28xxu
    blacklist rtl2832
    blacklist rtl2830" >> /etc/modprobe.d/no-rtl.conf

	if (whiptail --title "Restart Required" --yesno "It is recommended that you restart you device now. Select yes to do so now" 20 78); then
		sudo reboot
	fi
;;

"commands")
	docker_selection=$(
		whiptail --title "Docker commands" --menu --notags \
			"Shortcut to common docker commands" 20 78 12 -- \
			"start" "Start all containers" \
			"restart" "Restart all containers" \
			"stop" "Stop all containers" \
			"pull" "Update all containers" \
			3>&1 1>&2 2>&3
	)

	case $docker_selection in
		"start") ./scripts/start.sh ;;
		"stop") ./scripts/stop.sh ;;
		"restart") ./scripts/restart.sh ;;
		"pull") ./scripts/update.sh ;;
	esac
;;

"installreq")
	cd dockerfiles/
	docker-compose up -d
;;

*) ;;
esac