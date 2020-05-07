#!/bin/bash
# This script will create clients config file


echo
for CLIENT in "${CLIENTS[@]}"; do
    echo -ne "${PROGRESS} copy 'sample-client.ovpn' to $CLIENT.ovpn... "
    if \cp -r "$DIR/src/clients/sample-client.ovpn" "${DCLIENTS}/$CLIENT.ovpn"; then
        echo -e "${OK}"
    else
        echo -e "${FAIL}"
    fi

    echo -ne "${PROGRESS} inject values and secrets in $CLIENT.ovpn file... "
    sed -i "" "s/{EXT_IP}/${AUTO_EXT_IP}/" "${DCLIENTS}/$CLIENT.ovpn"
    sed -i "" "s/{EXT_PORT}/${EXT_PORT}/" "${DCLIENTS}/$CLIENT.ovpn"
    sed -i "" -e "/<ca>/ r ${DKEYS}/ca.crt" "${DCLIENTS}/$CLIENT.ovpn"
    sed -i "" -e "/<cert>/ r ${DKEYS}/$CLIENT.crt" "${DCLIENTS}/$CLIENT.ovpn"
    sed -i "" -e "/<key>/ r ${DKEYS}/$CLIENT.key" "${DCLIENTS}/$CLIENT.ovpn"
    sed -i "" -e "/<tls-auth>/ r ${DKEYS}/ta.key" "${DCLIENTS}/$CLIENT.ovpn"
    echo -e "${OK}"
done

