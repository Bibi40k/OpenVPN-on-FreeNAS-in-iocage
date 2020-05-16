#!/bin/bash
# Update config file if we add more vars in it

# Add 'RELEASE' variable
grep -q 'RELEASE' ${FVARS} || cat >> ${FVARS} <<- EOM
# Iocage version. Normally autodetected but sometime you need
# to upgrade it to the next version due to end-of-life.
# Default: your-FreeNAS-version
RELEASE=""
EOM
echo

# Add 'EXT_IP' variable to let usage of DDNS
grep -q 'EXT_IP' ${FVARS} || sed -i "" "|JAIL_NAME|a \
\
# External IP/DDNS that you'll use to connect \
# Default: your-IP \
EXT_IP=\"\" \
" ${FVARS}

