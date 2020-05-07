#!/bin/bash
# Requires: dirs.sh



function CheckOS {

    # Make sure we both support current FreeNAS version and auto switch to propper branch. 
    OS_VERSION=$(freebsd-version | sed "s/STABLE/RELEASE/g" | sed "s/-.*//g")
    FULL_OS_VERSION=$(freebsd-version)

    if (( $(echo "${OS_VERSION} < 11.2" | bc -l) )); then
        echo -e "Hi ${AUTO_USER}, ${COLOR_RED}only FreeNAS greater thsn 11.2 are confirmed to work.${COLOR_N}"
        echo -e "${INFO} Please forward your feedback and $FLOG and i'll try to help you. We continue in few seconds."
        sleep 5
    fi

}

CheckOS

