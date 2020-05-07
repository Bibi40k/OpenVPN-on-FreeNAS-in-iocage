#!/bin/bash



# Default vars. '4SCREEN vars should stay before regular not to be overwritten'
JAIL_NAME_4SCREEN=${COLOR_GREEN}${JAIL_NAME:-${COLOR_BLUE}"OpenVPN"}${COLOR_N}
JAIL_NAME=${JAIL_NAME:-"OpenVPN"}
INTERFACE=${INTERFACE:-"vnet0"}
JAIL_IP_4SCREEN=${COLOR_GREEN}${JAIL_IP:-${COLOR_BLUE}$AUTO_JAIL_IP}${COLOR_N}
JAIL_IP=${JAIL_IP:-$AUTO_JAIL_IP}
EXT_PORT_4SCREEN=${COLOR_GREEN}${EXT_PORT:-${COLOR_BLUE}"1194"}${COLOR_N}
EXT_PORT=${EXT_PORT:-"1194"}
CLIENTS_4SCREEN=${COLOR_GREEN}${CLIENTS[@]:-${COLOR_BLUE}$AUTO_USER}${COLOR_N}
CLIENTS=(${CLIENTS[@]:-$AUTO_USER})
BKP_PATH_4SCREEN=${BKP_PATH:-${COLOR_BLUE}$DBACKUP}${COLOR_N}
BKP_PATH=${BKP_PATH:-$DBACKUP}
FIND_BKP_FILE=$(ls -dt ${BKP_PATH}/bkp* | head -1 | xargs -n 1 basename 2>/dev/null)
BKP_FILE_4SCREEN=${COLOR_GREEN}${FIND_BKP_FILE:-${COLOR_RED}"no-backup-yet"}${COLOR_N}
BKP_FILE=${FIND_BKP_FILE:-"no-backup-yet"}
RELEASE_4SCREEN=${COLOR_GREEN}${RELEASE:-${COLOR_BLUE}$AUTO_RELEASE}${COLOR_N}
RELEASE=${RELEASE:-$AUTO_RELEASE}



# Easy RSA vars - Simple shell based CA utility
COUNTRY_4SCREEN=${COLOR_GREEN}${COUNTRY:-${COLOR_BLUE}"US"}${COLOR_N}
COUNTRY=${COUNTRY:-"US"}
PROVINCE_4SCREEN=${COLOR_GREEN}${PROVINCE:-${COLOR_BLUE}"California"}${COLOR_N}
PROVINCE=${PROVINCE:-"California"}
CITY_4SCREEN=${COLOR_GREEN}${CITY:-${COLOR_BLUE}"San Francisco"}${COLOR_N}
CITY=${COLOR_GREEN}${CITY:-${COLOR_BLUE}"San Francisco"}${COLOR_N}
ORG_4SCREEN=${COLOR_GREEN}${ORG:-${COLOR_BLUE}"Copyleft Certificate Co"}${COLOR_N}
ORG=${ORG:-"Copyleft Certificate Co"}
EMAIL_4SCREEN=${COLOR_GREEN}${EMAIL:-${COLOR_BLUE}"me@example.net"}${COLOR_N}
EMAIL=${EMAIL:-"me@example.net"}
OU_4SCREEN=${COLOR_GREEN}${OU:-${COLOR_BLUE}"My Organizational Unit"}${COLOR_N}
OU=${OU:-"My Organizational Unit"}
CN_4SCREEN=${COLOR_GREEN}${CN:-${COLOR_BLUE}"OpenVPN FreeNAS CA"}${COLOR_N}
CN=${CN:-"OpenVPN FreeNAS CA"}



# Params for jail creation
VNET="on"
VNET_DEFAULT_INTERFACE="none"
DHCP="off"
BPF="yes"
BOOT="on"
ALLOW_RAW_SOCKETS="1"
ALLOW_TUN="1"


# Loading defaults for specific versions; updated as they appear
echo -ne "${INFO} Getting defaults for ${COLOR_BLUE}FreeNAS ${OS_VERSION}${COLOR_N}... "
source $DIR/scripts/${OS_VERSION}/defaults.sh
echo -e ${OK}

