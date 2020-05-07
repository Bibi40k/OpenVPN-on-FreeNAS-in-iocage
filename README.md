# FreeNAS scripts series: OpenVPN server into Iocage Jail

# What this script do:
- check for new version on each run and update itself
- create all dir structure and files on you
- store all configuration files into 'openvpn-configs'
- create iocage Jail with proper values and configurations
- build Certificate Authority
- build Server Certificates
- generate Diffie Hellman Parameters
- generate the TA key
- build Client(s) Certificate
- copy everything together and set paths to OpenVPN server config file
- creates the firewall and routing tables
- mix all certs and keys together with client(s) config files and create a single .ovpn file useful for mobile also.
- sends email with client(s) config file.

![script-menu]([https://github.com/Bibi40k/OpenVPN-on-FreeNAS-in-iocage/blob/master/src/script-menu.jpg])

# Recommended OpenVPN Clients:
Windows: [OpenVPN](https://openvpn.net/community-downloads/) \
MacOS: [Tunnelblick](https://tunnelblick.net/release/Latest_Tunnelblick_Stable.dmg)

# What you should do:
- edit the config file
- during the installation you'll be asked to create a PASS PHRASE which you'll be using to authorize further operations like generating certificates, keys, users 
- forward chosen port (default 1194) to OpenVPN iocage Jail chosen IP (default .66) on Port 1194 UDP
- keep in mind that if your local LAN uses the extremely common subnet address 192.168.0.x or 192.168.1.x this might create routing conflicts if you connect to the VPN server from locations that use the same subnet (work, public wi-fi, hotels, etc).

# Installing steps

## SSH into Freenas or use shell from the interface
```
ssh your-username@your-FreeNAS-IP # Terminal for MacOS & Linux or Putty on Windows
sudo -i # we need to be root
```

## Download installer
```
git clone https://github.com/Bibi40k/OpenVPN-on-FreeNAS-in-iocage.git
cd OpenVPN-on-FreeNAS-in-iocage # Enter the script dir
```

## Start installer and follow on-screen instructions
```
./install.sh # run the script and enters the menu
```

# About the menu colors
- blue is used to display default values generated/discovered by the script or defaults
- green is used to display your custom values

