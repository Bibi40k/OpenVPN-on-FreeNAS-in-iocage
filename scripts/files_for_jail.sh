#!/bin/bash
# This script will create/copy all necessary files for jailbox
# Destination folder is '/mnt/ZFS_NAME/iocage/jails/OpenVPN/root/...'



# We keep full original 'server.conf, client.conf, vars' file just for reference
echo
echo -ne "${PROGRESS} make a bkp of 'server.conf' file to conf dir... "
if \cp -r "${IOCAGE_PATH}/root/usr/local/share/examples/openvpn/sample-config-files/server.conf" "${DSERVER}/originals/openvpn.conf"; then
  echo -e "${OK}"
else
  echo -e "${FAIL}"
fi

echo -ne "${PROGRESS} make a bkp of 'client.conf' file to conf dir... "
if \cp -r "${IOCAGE_PATH}/root/usr/local/share/examples/openvpn/sample-config-files/client.conf" "${DCLIENTS}/originals/client.conf"; then
  echo -e "${OK}"
else
  echo -e "${FAIL}"
fi

echo -ne "${PROGRESS} make a bkp of 'easy-rsa/vars' file to conf dir... "
if \cp -r "${IOCAGE_PATH}/root/usr/local/share/easy-rsa/vars" "${DSERVER}/originals/vars"; then
  echo -e "${OK}"
else
  echo -e "${FAIL}"
fi



# We copy config files from our installer dir
# openvpn.conf, rc.conf, ipfw.rules, newsyslog.conf, syslog.conf
echo
echo -ne "${PROGRESS} copy 'ipfw.rules' file to conf dir... "
if \cp -r "${DIR}/src/server/ipfw.rules" "${DSERVER}/ipfw.rules"; then
    echo -e "${OK}"
else
  echo -e "${FAIL}"
fi

echo -ne "${PROGRESS} copy 'newsyslog.conf' file to conf dir... "
if \cp -r "${DIR}/src/server/newsyslog.conf" "${DSERVER}/newsyslog.conf"; then
    echo -e "${OK}"
else
  echo -e "${FAIL}"
fi

echo -ne "${PROGRESS} copy 'syslog.conf' file to conf dir... "
if \cp -r "${DIR}/src/server/syslog.conf" "${DSERVER}/syslog.conf"; then
    echo -e "${OK}"
else
  echo -e "${FAIL}"
fi

echo -ne "${PROGRESS} copy 'rc.conf' file to conf dir... "
if \cp -r "${DIR}/src/server/rc.conf" "${DSERVER}/rc.conf"; then
    echo -e "${OK}"
else
  echo -e "${FAIL}"
fi



# We adjust config files with proper values (we use paths relative from inside jail)
echo
echo -ne "${PROGRESS} adjust values in 'rc.conf' file... "
sed -i "" "s|{JAIL_NAME}|${JAIL_NAME}|" "${DSERVER}/rc.conf"
sed -i "" "s|{DSERVER}|${JAIL_DSERVER}|" "${DSERVER}/rc.conf"
echo -e "${OK}"



# Copy files to jail
echo
echo -ne "${PROGRESS} copy 'rc.conf|ipfw.rules|syslog.conf|newsyslog.conf' files to jail... "
if \cp -r "${DSERVER}/rc.conf" \
  "${DSERVER}/ipfw.rules" \
  "${DSERVER}/syslog.conf" \
  "${DSERVER}/newsyslog.conf" \
  "${IOCAGE_PATH}/root/etc/"; then
    echo -e "${OK}"
else
  echo -e "${FAIL}"
fi

  