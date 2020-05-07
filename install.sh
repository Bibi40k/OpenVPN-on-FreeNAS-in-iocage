#!/bin/bash

#########################################################################
# Title: OpenVPN iocage jail under FreeNAS                              #
# Author: Bibi40k                                                       #
# Repository: https://github.com/Bibi40k/OpenVPN-on-FreeNAS-in-iocage   #
#########################################################################

# First of all, we clear the screen
clear


# Getting installer dir ( /root/OpenVPN-on-FreeNAS-in-iocage )
CWD="`pwd`"
SCRIPT="`which $0`"
RELDIR="`dirname $SCRIPT`"
cd "$RELDIR"
DIR="`pwd`"
cd "$CWD"


source $DIR/scripts/colors.sh # messages' colors
source $DIR/scripts/check_user.sh # checks minimum requirements

CheckUser # user must be root

# Update script to the latest version
echo
echo -e "${INFO} Checking for script updates..."
echo
cd ${DIR}
git pull


# Import scripts from /scripts dir
source $DIR/scripts/autodiscover.sh # autodiscovers few vars we need later
source $DIR/scripts/dirs.sh # create all dir structure
source $DIR/scripts/files.sh # create/copy all files
source $FVARS # custom vars in '${DCONFIG}/jail-install.cfg'
source $DIR/scripts/update_config.sh # update 'openvpn-install.cfg' file so user will keep customizations
source $DIR/scripts/check_os.sh # checks minimum requirements

# Loading fixes for specific versions; updated as they appear
echo -e "${INFO} Getting fixes for ${COLOR_BLUE}FreeNAS ${OS_VERSION}${COLOR_N}... "
source $DIR/scripts/${OS_VERSION}/fixes.sh

CheckOS # check if script is compatible with this FreeNAS version

source $DIR/scripts/defaults.sh # default vars & constants
source $DIR/scripts/functions.sh # functions


if [[ $# == "1" ]]; then
	HandleArgs "$1"
	exit 0
else
	StartUpScreen
fi

