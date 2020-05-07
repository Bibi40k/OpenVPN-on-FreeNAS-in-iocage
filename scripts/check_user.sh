#!/bin/bash



function CheckUser {

	# Make sure the script is ran as root
	if [[ ! "$(id -u)" == "0" ]]; then
        echo
		echo -e "${FAIL} This script needs to be ran as root."
        echo -e "${INFO} Hi ${USER}, please execute 'sudo -i' first and become root."
        echo
		exit 0
	fi

}

