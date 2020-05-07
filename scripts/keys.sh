#!/bin/bash
# This script will generate all keys for OpenVPN server and clients



# Generate Keys if don't exists
if [ ! -d "${DSERVER}/easy-rsa/pki" ]; then
  echo
  echo -ne "${PROGRESS} copy Easy RSA vars file to conf dir... "
  if \cp -r "${DSERVER}/vars" "${DSERVER}/easy-rsa/vars"; then
    echo -e "${OK}"
  else
    echo -e "${FAIL}"
  fi

  echo
  echo -ne "${PROGRESS} generating PKI... "
  
  echo
  cd ${DSERVER}/easy-rsa && ./easyrsa.real init-pki
else
  echo
  echo -e "${PROGRESS} PKI found, use existing one... ${OK}"
fi



# Build Certificate Authority if don't exists
if [ ! -f "${DSERVER}/easy-rsa/pki/ca.crt" ] && [ ! -f "${DSERVER}/easy-rsa/pki/private/ca.key" ]; then
  echo
  echo -e "${PROGRESS} building Certificate Authority... "
	echo
	echo -e "${WARNING} Define ${COLOR_RED}PASS PHRASE${COLOR_N} ( ${COLOR_RED}minimum 4 characters${COLOR_N} )"
	echo -e "${INFO} Pass phrase is used to authorize your further actions."
  ${DSERVER}/easy-rsa/easyrsa.real build-ca
  echo -e "${OK} ${DSERVER}/easy-rsa/pki/ca.crt"
  echo -e "${OK} ${DSERVER}/easy-rsa/pki/private/ca.key"
else
  echo
  echo -e "${PROGRESS} Certificate Authority found, use existing one... ${OK}"
fi



# Build Server Certificates if don't exists
if [ ! -f "${DSERVER}/easy-rsa/pki/reqs/openvpn-server.req" ] && [ ! -f "${DSERVER}/easy-rsa/pki/private/openvpn-server.key" ]; then
  echo
  echo -e "${PROGRESS} Building Server Certificates... "
	echo -e "${WARNING} Use ${COLOR_RED}PASS PHRASE${COLOR_N} to authorize ( ${COLOR_RED}you define it on first step${COLOR_N} )"
  cd ${DSERVER}/easy-rsa && ./easyrsa.real build-server-full openvpn-server nopass
  echo -e "${OK} ${DSERVER}/easy-rsa/pki/reqs/openvpn-server.req"
  echo -e "${OK} ${DSERVER}/easy-rsa/pki/private/openvpn-server.key"
else
  echo
  echo -e "${PROGRESS} Server Certificates found, use existing one... ${OK}"
fi



# Generate Diffie Hellman Parameters if don't exists
if [ ! -f "${DSERVER}/easy-rsa/pki/dh.pem" ]; then
  echo
  echo -e "${PROGRESS} Generating Diffie Hellman Parameters... "
  cd ${DSERVER}/easy-rsa && ./easyrsa.real gen-dh
  echo -e "${OK} ${DSERVER}/easy-rsa/pki/dh.pem"
else
  echo
  echo -e "${PROGRESS} Diffie Hellman Parameters found, use existing one... ${OK}"
fi



# Generate the TA key
if [ ! -f "${DSERVER}/easy-rsa/ta.key" ]; then
  echo
  echo -e "${PROGRESS} Generating TA key... "
  cd ${DSERVER}/easy-rsa && openvpn --genkey --secret ta.key
  echo -e "${OK} ${DSERVER}/easy-rsa/ta.key"
else
  echo
  echo -e "${PROGRESS} TA key found, use existing one... ${OK}"
fi



# Build Client(s) Certificate if don't exists
# Passphrase must be 4 to 1023 characters
for CLIENT in "${CLIENTS[@]}"; do
  if [ ! -f "${DSERVER}/easy-rsa/pki/reqs/$CLIENT.req" ]; then
    echo
    echo -e "${PROGRESS} Building Client Certificate for ${COLOR_GREEN}$CLIENT${COLOR_N}... "
	  echo -e "${WARNING} Use ${COLOR_RED}PASS PHRASE${COLOR_N} to authorize ( ${COLOR_RED}you define it on first step${COLOR_N} )"
    cd ${DSERVER}/easy-rsa && ./easyrsa.real build-client-full $CLIENT
    echo -e "${OK} $CLIENT profile created."
  fi
done



# Copy all keys
echo
echo -ne "${PROGRESS} copy dh.pem|ca.crt|openvpn-server.crt|openvpn-server.key|ta.key to conf dir... "
cd "${DSERVER}/easy-rsa"
if \cp -r "pki/dh.pem" \
  "pki/ca.crt" \
  "pki/issued/openvpn-server.crt" \
  "pki/private/openvpn-server.key" \
  "ta.key" \
  ${DKEYS}; then
  echo -e "${OK}"
else
  echo -e "${FAIL}"
fi

echo
for CLIENT in "${CLIENTS[@]}"; do
  echo -ne "${PROGRESS} copy ${CLIENT}.crt and ${CLIENT}.key to conf dir... "
  if \cp -r "pki/issued/${CLIENT}.crt" \
    "pki/private/${CLIENT}.key" \
    ${DKEYS}; then
    echo -e "${OK}"
  else
    echo -e "${FAIL}"
  fi
done

