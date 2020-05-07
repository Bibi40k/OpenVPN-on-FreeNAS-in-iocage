# FreeNAS scripts series: OpenVPN server into Iocage Jail

# What this script do:
- create all dir structure and files on a
- store all custom vars into openvpn-configs/jail.vars & /root/openvpn-configs/server/vars
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

![script-menu]([https://github.com/Bibi40k/OpenVPN-on-FreeNAS-in-iocage/blob/master/script-menu.jpg])

# Recommended OpenVPN Clients:
Windows: [OpenVPN](https://openvpn.net/community-downloads/) \
MacOS: [Tunnelblick](https://tunnelblick.net/release/Latest_Tunnelblick_Stable.dmg)


# What you should do:
- forward chosen port (default 1194) to OpenVPN iocage Jail chosen IP (default .66) on Port 1194 UDP
- keep in mind that if your local LAN uses the extremely common subnet address 192.168.0.x or 192.168.1.x this might create routing conflicts if you connect to the VPN server from locations that use the same subnet (work, public wi-fi, hotels, etc).


# Install

## SSH into Freenas
```
ssh Username@FreenasIP # Terminal for MacOS & Linux or Putty on Windows
sudo -i # we need to be root
```
## Get installer
```
git clone https://github.com/Bibi40k/OpenVPN-on-FreeNAS-in-iocage.git
cd OpenVPN-on-FreeNAS-in-iocage # Enter the script dir
git branch -a # List all versions
    * master
    remotes/origin/11.2
    remotes/origin/11.3
    remotes/origin/HEAD -> origin/master
    remotes/origin/dev
    remotes/origin/master
    (END)
```

## Run the installer
```
git checkout 11.3 # switch to your FreeNAS matching version
git pull # allways recommended to pull updates before run the script
./install.sh # run the script
```





# Install

### SSH into Freenas
```
ssh my-user@my-domain.com
sudo -i
```

### Download installer
```
git clone https://github.com/Bibi40k/OpenVPN-on-FreeNAS-in-iocage.git
cd OpenVPN-on-FreeNAS-in-iocage
```

### List branches/versions and enter desired one
```
git branch -a
git checkout 11.2
git pull
```

### Start installer and follow on-screen instructions
```
./install.sh
```
