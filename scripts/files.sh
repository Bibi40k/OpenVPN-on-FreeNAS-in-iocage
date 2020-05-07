#!/bin/bash
# This script will create/copy all necessary files

### FILES ###
FVARS="${DCONFIG}/ovpn-install.cfg" # My custom vars file
FLOG="${DCONFIG}/ovpn-install.log" # Log file






function CheckConfigFile {
   
    # Create config dir(s) if doesn't exist(s) already
    # Use default vars file if i don't find a custom one yet
    echo -ne "${PROGRESS} checking config file... "
    if [[ ! -f "${FVARS}" ]] ; then
        echo -e "${WARNING} no config file found"
        
        echo -ne "${PROGRESS} copy 'sample-ovpn-install.cfg' to ${FVARS}... "
        if \cp -n "$DIR/src/sample-ovpn-install.cfg" "${FVARS}"; then
            echo -e "${OK}"
        else
            echo -e "${FAIL}"
        fi
    else
        echo -e "${OK}"
    fi

}

CheckConfigFile
echo

