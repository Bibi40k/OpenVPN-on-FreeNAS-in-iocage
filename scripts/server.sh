#!/bin/bash
# This script will copy & configure OpenVPN server in Iocage box



# We copy necessary tools to generate configs & certs
echo
echo -ne "${PROGRESS} copy 'easy-rsa' dir to conf dir... "
if \cp -r "${IOCAGE_PATH}/root/usr/local/share/easy-rsa" "${DSERVER}/easy-rsa"; then
    echo -e "${OK}"
else
  echo -e "${FAIL}"
fi



# First, we put files in place 'openvpn.conf' and 'vars'
echo -ne "${PROGRESS} copy 'openvpn.conf' file to conf dir... "
if \cp -r "${DIR}/src/server/openvpn.conf" "${DSERVER}/openvpn.conf"; then
    echo -e "${OK}"
else
  echo -e "${FAIL}"
fi
# cat ${DSERVER}/openvpn.conf



echo -ne "${PROGRESS} copy 'vars' file to conf dir... "
if \cp -r "${DIR}/src/server/vars" "${DSERVER}/vars"; then
    echo -e "${OK}"
else
  echo -e "${FAIL}"
fi
# cat ${DSERVER}/vars



# Then, we adjust values (we use paths relative from inside jail)
echo
echo -ne "${PROGRESS} adjust values in 'openvpn.conf' file... "
sed -i "" "s|{IP_RANGE}|${AUTO_IP_RANGE}|" "${DSERVER}/openvpn.conf"
sed -i "" "s|{DKEYS}|${JAIL_DKEYS}|" "${DSERVER}/openvpn.conf"
sed -i "" "s|{DSERVER}|${JAIL_DSERVER}|" "${DSERVER}/openvpn.conf"
echo -e "${OK}"
# cat ${DSERVER}/openvpn.conf



# We adjust values in 'vars'
echo -ne "${PROGRESS} adjust values in 'vars' file... "
sed -i "" "s/{COUNTRY}/${COUNTRY}/" "${DSERVER}/vars"
sed -i "" "s/{PROVINCE}/${PROVINCE}/" "${DSERVER}/vars"
sed -i "" "s/{CITY}/${CITY}/" "${DSERVER}/vars"
sed -i "" "s/{ORG}/${ORG}/" "${DSERVER}/vars"
sed -i "" "s/{EMAIL}/${EMAIL}/" "${DSERVER}/vars"
sed -i "" "s/{OU}/${OU}/" "${DSERVER}/vars"
sed -i "" "s/{CN}/${CN}/" "${DSERVER}/vars"
echo -e "${OK}"

