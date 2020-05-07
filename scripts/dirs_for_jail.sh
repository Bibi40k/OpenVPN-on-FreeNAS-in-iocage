#!/bin/bash
# This script will create/copy all necessary files for jailbox
# Destination folder is '/mnt/ZFS_NAME/iocage/jails/OpenVPN/root/...'



# Get iocage path (accessible from FreeNAS)
IOCAGE_PATH=$(zfs list -o name,mountpoint | grep -m1 iocage/jails/${JAIL_NAME} | awk '{print $2;}')

JAIL_DCONFIG="/root/openvpn-configs" # Custom configs dir inside jail
JAIL_DBACKUP="/root/backup" # Custom backup dir inside jail
JAIL_DSERVER="${JAIL_DCONFIG}/server" # Server configs dir inside jail
JAIL_DCLIENTS="${JAIL_DCONFIG}/clients" # User(s)/client(s) profiles dir inside jail
JAIL_DKEYS="${JAIL_DSERVER}/keys" # Keys, certs dir inside jail
JAIL_DLOGS="${JAIL_DCONFIG}/logs" # Logs dir inside jail

