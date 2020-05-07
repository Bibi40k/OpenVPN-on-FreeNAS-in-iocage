#!/bin/bash
# This script will create all necessary dirs & store them in vars



### DIRS ###
DCONFIG="${DIR}/openvpn-configs"    # Custom configs dir
DBACKUP="${DIR}/backup"             # Custom backup dir
DSERVER="${DCONFIG}/server"         # Server configs dir
DCLIENTS="${DCONFIG}/clients"       # User(s)/client(s) profiles dir
DKEYS="${DSERVER}/keys"             # Keys, certs dir
DLOGS="${DCONFIG}/logs"             # Logs dir



function CheckConfigDirs {
   
    # Create config dir(s) if doesn't exist(s) already
    # We check for the '/server/originals' because we always keep customizations
    echo -ne "${PROGRESS} checking config dirs... "
    if [[ ! -d "${DCONFIG}/server/originals" ]] ; then
        echo -e "${WARNING} no config dirs found"
        DIRS=(${DCONFIG}/{server/{keys,originals},clients/originals,logs/originals})
        
        echo -ne "${PROGRESS} creating config dirs to ${DCONFIG}... "
        if mkdir -p -- "${DIRS[@]}"; then
            echo -e "${OK}"
        else
            echo -e "${FAIL}"
        fi
    else
        echo -e "${OK}"
    fi

}


echo
CheckConfigDirs

