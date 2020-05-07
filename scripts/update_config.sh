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