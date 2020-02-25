#!/bin/bash

function command_exists() {
	command -v "$@" >/dev/null 2>&1
}

mainmenu_selection=$(whiptail --title "Main Menu" --menu --notags \
	"" 20 78 12 -- \
	"docker" "Install Docker" \
	"installreq" "Install required packages" \
	"commands" "Docker commands" \
	3>&1 1>&2 2>&3)
case $mainmenu_selection in
"docker")
	if command_exists docker; then
		echo "docker already installed"
	else
		echo "Install Docker"
		curl -fsSL https://get.docker.com | sh
		sudo usermod -aG docker $USER
	fi

	if command_exists docker-compose; then
		echo "docker-compose already installed"
	else
		echo "Install docker-compose"
		sudo apt install -y docker-compose
	fi

	if (whiptail --title "Restart Required" --yesno "It is recommended that you restart you device now. Select yes to do so now" 20 78); then
		sudo reboot
	fi
;;

"installreq")
	cd dockerfiles/
	docker-compose up -d
;;

*) ;;
esac
