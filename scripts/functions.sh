#!/bin/bash



function NotAvailable {

	# Use this for future features

	echo
	echo -e "${INFO} Not yet implemended, we return to main menu in a second."
	echo
	sleep 2
	StartUpScreen

}



function CheckIocageJail {

    # Check if we already have an Iocage Jail named like the one we configure

	if [[ ! $(iocage list | grep $JAIL_NAME) ]]; then
        MSG="${INFO} There is no Iocage Jail named $JAIL_NAME."
        JAIL_EXIST="false"
    else
        MSG="${INFO} Iocage Jail named $JAIL_NAME exists."
        JAIL_EXIST="true"
    fi

}



function CheckIocageState {

    # Check if we already have an Iocage Jail named like the one we configure

	if [[ $(iocage get --state $JAIL_NAME | grep up ) ]]; then
		JAIL_STATE="up"
	else
		JAIL_STATE="down"
	fi

}



function CheckOVPNServer {

    # Check if OpenVPN server is up and running; showing last X lines from log.
	iocage exec "${JAIL_NAME}" service openvpn restart
	echo
	echo -e "OpenVPN server log file: ${COLOR_BLUE}'/var/log/openvpn.log'${COLOR_N}"
	echo -e "${COLOR_BLUE}$(iocage exec "${JAIL_NAME}" tail -n 50 /var/log/openvpn.log)${COLOR_N}"
	sleep 5

}



function OpenVPNFullChecks {

    # Check if OpenVPN server status; showing last X lines from log; show content of all customized files.

	source $DIR/scripts/dirs_for_jail.sh # dirs path for Jailbox

	echo -e "${INFO} display content of 'openvpn.conf' file:"
	cat ${IOCAGE_PATH}/root/${JAIL_DSERVER}/openvpn.conf

	echo -e "${INFO} display content of 'rc.conf' file:"
	cat ${IOCAGE_PATH}/root/etc/rc.conf

	CheckOVPNServer

}



function BackUpAndEmail {

	# BackUp entire config dir and send it to e-mail

	source $DIR/scripts/dirs_for_jail.sh # dirs path for Jailbox

	TIME=$(date +%Y%d%m%H%M)

	cd ${DIR}

	echo
	echo -ne "${PROGRESS} checking if Backup dir exists... "
	if [[ ! -d "${BKP_PATH}" ]] ; then
		echo -ne "${PROGRESS} i didn't find one so i'm creating it... "
		mkdir "${BKP_PATH}" "${IOCAGE_PATH}/root/root/backup"
	fi
	echo -e ${OK}

	echo
	echo -ne "${PROGRESS} creating Backup... "
	tar -czvf ${BKP_PATH}/bkp-openvpn-configs-${TIME}.tar.gz ${DCONFIG}
	echo -e ${OK}

	echo
	# Remove old 'backup' dir and copy the new one in jail
	rm -rf "${IOCAGE_PATH}/root/root/backup"
	# Copy bkp file to Jail so we can use mpack
	echo -ne "${PROGRESS} copy backup dir to jail... "
	if \cp -r "${BKP_PATH}" "${IOCAGE_PATH}/root/root/backup"; then
    	echo -e "${OK}"
	else
		echo -e "${FAIL}"
	fi

	echo -e "${PROGRESS} sending backup file from Charlie Root<root@localhost.my.domain> to ${EMAIL}"
	iocage exec "${JAIL_NAME}" mpack -s "OpenVPN bkp-openvpn-configs-${TIME}" "${JAIL_DBACKUP}/bkp-openvpn-configs-${TIME}.tar.gz" ${EMAIL}
	echo

}



function UpdateJail {

	# Update everything
	
	CheckIocageJail # Check if exists
	if [ $JAIL_EXIST == "true" ]; then
		echo
		echo -e "${PROGRESS} updating ${JAIL_NAME} jail... "
		echo
		iocage exec "${JAIL_NAME}" env ASSUME_ALWAYS_YES=YES pkg bootstrap
		iocage exec "${JAIL_NAME}" pkg upgrade
		iocage exec "${JAIL_NAME}" pkg update
		echo -e "${OK}"
	else
		echo -e "${INFO} ${JAIL_NAME} jail does not exist."
	fi

}



function RestartJail {

	# Restart Jail
	
	CheckIocageJail # Check if exists
	if [ $JAIL_EXIST == "true" ]; then
		echo
		echo -e "${PROGRESS} restarting ${JAIL_NAME} jail... "
		echo
		iocage restart "${JAIL_NAME}"
	else
		echo -e "${INFO} ${JAIL_NAME} jail does not exist."
	fi

}



function ErrorHandling {

	echo
	echo
	echo -e "${COLOR_RED}Something went wrong, exiting.${COLOR_N}"
	echo -e "${INFO} Display error(s) in a sec."
	echo
	echo -e "Log file: ${COLOR_BLUE}$FLOG${COLOR_N}"
	echo -e "${COLOR_RED}$(cat $FLOG)${COLOR_N}"
	echo


	# CheckIocageJail
	# if [ $JAIL_EXIST == "true" ]; then
	# 	echo
	# 	echo -e "${FAIL} Deleting $JAIL_NAME Jail because of failed installation."
	# 	iocage destroy -f -R $JAIL_NAME
	# 	echo
	# fi

}



function RunCleaner {
	
	# Remove Iocage Jail if exists and keep config file
	
	CheckIocageJail

	if [ $JAIL_EXIST == "true" ]; then
		echo
		echo -e "${WARNING} $JAIL_NAME jail and following files and dirs will be removed, please confirm:"
		echo
		echo -e "${COLOR_RED}$(find ${DCONFIG} ! -name 'ovpn-install.cfg' ! -name 'openvpn-configs' -print)${COLOR_N}"
		echo
		read -p "[y/n]: " answer
			case $answer in
				y)
					echo
					echo -e "${PROGRESS} removing $JAIL_NAME jail... "
					iocage destroy -f -R $JAIL_NAME
					echo
					echo -ne "${PROGRESS} removing files and dirs... "
					find ${DCONFIG} ! -name 'ovpn-install.cfg' ! -name 'openvpn-configs' -delete
					echo -e "${OK} we return to main menu."
					echo
					sleep 2
					StartUpScreen
				;;
				n|*)
					echo
					echo -e "${INFO} Nothing removed, we return to main menu."
					sleep 2
					StartUpScreen
				;;
			esac
	else
		echo
		echo -e "${INFO} There is no $JAIL_NAME Jail to delete."
		echo
		echo -e "${WARNING} Following files and dirs will be removed, please confirm:"
		echo
		echo -e "${COLOR_RED}$(find ${DCONFIG} ! -name 'ovpn-install.cfg' ! -name 'openvpn-configs' -print)${COLOR_N}"
		echo
		read -p "[y/n]: " answer
			case $answer in
				y)
					echo -ne "${PROGRESS} removing files and dirs... "
					find ${DCONFIG} ! -name 'ovpn-install.cfg' ! -name 'openvpn-configs' -delete
					echo -e "${OK} we return to main menu."
					sleep 2
					StartUpScreen
				;;
				n|*)
					echo -e "${INFO} Nothing removed, we return to main menu."
					sleep 2
					StartUpScreen
				;;
			esac
	fi

}



# Loading OpenVPN jail install script; updated as they appear
echo -ne "${INFO} Getting OpenVPN install script for ${COLOR_BLUE}FreeNAS ${OS_VERSION}${COLOR_N}... "
source $DIR/scripts/${OS_VERSION}/install_openvpn.sh
echo -e ${OK}



function StartUpScreen {

echo "----------------------------------------------------------------------------------"
echo
echo "This script will help you install/update OpenVPN server in Iocage Jail."
echo
echo -e "Active settings for installation:"
echo -e "OpenVPN jail name: [ $JAIL_NAME_4SCREEN ]"
echo -e "OpenVPN jail IP: [ $JAIL_IP_4SCREEN ]"
echo -e "FreeNAS version: [ ${COLOR_BLUE}$FULL_OS_VERSION${COLOR_N} ]"
echo -e "Iocage version: [ $RELEASE_4SCREEN ]"
echo -e "OpenVPN profile(s) to be created: [ $CLIENTS_4SCREEN ]"
echo -e "OpenVPN external port: [ $EXT_PORT_4SCREEN ]"
echo
echo -e "Active autodetected vars:"
echo -e "Gateway IP: [ ${COLOR_BLUE}$AUTO_GW_IP${COLOR_N} ]"
echo -e "External IP: [ ${COLOR_BLUE}$AUTO_EXT_IP${COLOR_N} ]"
echo
echo -e "Active settings for certificates and keys:"
echo -e "Country: [ $COUNTRY_4SCREEN ]"
echo -e "Province: [ $PROVINCE_4SCREEN ]"
echo -e "City: [ $CITY_4SCREEN ]"
echo -e "Organization: [ $ORG_4SCREEN ]"
echo -e "E-mail: [ $EMAIL_4SCREEN ]"
echo -e "Organizational unit: [ $OU_4SCREEN ]"
echo -e "Canonical name: [ $CN_4SCREEN ]"
echo
echo -e "Config dir: [ ${COLOR_BLUE}$DCONFIG${COLOR_N} ]"
echo -e "BackUp dir: [ ${COLOR_BLUE}$BKP_PATH_4SCREEN${COLOR_N} ]"
echo -e "Last BackUp: [ $BKP_FILE_4SCREEN ]"
echo
echo "----------------------------------------------------------------------------------"
echo
echo "1. Install"
echo "2. The Updater - updates jail and it's packages"
echo "3. Add new/edit OpenVPN profile(s) and send them to e-mail box"
echo "4. Regenerate server's keys, certs and recreate profile(s)"
echo "5. The Cleaner - keeps .cfg file and removes jail and related files"
echo "6. The Keeper - backup & sends config to email"
echo "7. The Watcher - shows server configs & last 50 lines of the log"
echo "8. Edit settings"
echo "9. Exit"
echo
read -p ": " option

	case $option in
		1)
			CheckIocageJail
			if [ $JAIL_EXIST == "true" ]; then
				echo
				echo -e "${INFO} $JAIL_NAME jail already exists, consider running other options instead. Continue anyway?"
				read -p "[y/n]: " answer
					case $answer in
						y)
							InstallOpenVPN
						;;
						n|*)
							StartUpScreen
						;;
					esac
			else
				InstallOpenVPN
			fi
		;;
		2)
			# Update OpenVPN server app & Iocage Jail packages
			UpdateJail
			echo
		;;
		3)
			# Add new/edit OpenVPN profile(s) and send them to e-mail box
			NotAvailable
		;;
		4)
			# Regenerate server's keys, certs and recreate profile(s)
			NotAvailable
		;;
		5)
			# Run cleaner
			RunCleaner
			StartUpScreen
		;;
		6)
			# BackUp all config files and send them to e-mail box
			BackUpAndEmail
			source $DIR/scripts/defaults.sh # reload after edit
			StartUpScreen
		;;
		7)
			# OpenVPN server full checks
			echo
			OpenVPNFullChecks
			echo
		;;
		8)
			# Edit settings
			nano ${FVARS}
			source ${FVARS} # reload after edit
			source $DIR/scripts/defaults.sh # reload after edit
			StartUpScreen
		;;
		9)
			# Exit
			exit 0
		;;
		*)
			echo "Please choose an existing option from menu"
			echo
			exit 0
		;;
	esac

}

