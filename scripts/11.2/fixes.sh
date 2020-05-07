#!/bin/bash

# FIX Package missmatch on 11.2 (due to EOL)
if [[ "${OS_VERSION}" == "11.2" && "${RELEASE}" != "11.3-RELEASE" || $(iocage list -rh | grep 11.3) == "" ]]; then
	echo -e "${INFO} ${COLOR_RED}${AUTO_USER}${COLOR_N}, to avoid package missmatch due to 11.2-RELEASE end-of-life"
	echo -e "${INFO} I update/fix for you ${COLOR_RED}ONLY${COLOR_N} Iocage Jail version to 11.3-RELEASE, do you agree ?"

	read -p "[y/n]: " answer
		case $answer in
			y)
				RELEASE="11.3-RELEASE"
				echo
				echo -ne "${INFO} Checking if we already have fetched ${RELEASE}... "
				iocage list -rh | grep 11.3 || iocage fetch -r ${RELEASE}
				sed -i "" "s|RELEASE=.*|RELEASE=\"${RELEASE}\"|" ${FVARS}
				echo
			;;
			n|*)
				echo
				echo -e "${INFO} No problem for me, but you'll get an error on installing OpenVPN server package"
				echo -e "${INFO} and you should fix this manually anyway."
				echo
				sleep 5
			;;
		esac
fi

