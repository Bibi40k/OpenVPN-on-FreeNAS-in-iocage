# 2020.05.07 - initial-release
- updated readme file
- introducing The Keeper, The Cleaner, The Updater and The Watcher

# 2020.05.06 - pre-release (testing)
## Notes:
- tested on 11.2 and 11.3 FreeNAS

## Fixes:
- Package missmatch on 11.2 (due to EOL) - please update to FreeNAS-11.2-U8 first

## Features:
- self update on each run
- auto create dir structure and files
- auto discover external IP, gateway IP, your username, FreeNAS version
- after install it sends OpenVPN clients' profile packed into one .ovpn file also compatible with mobile phone
- back-up 'openvpn-configs' and send it to e-mail
- cleaner keeps 'openvpn-install.cfg' and removes OpenVPN jail box and all generated files during previous run
- updates OpenVPN jail box with all the installed packages
- outputs OpenVPN config files and shows last 50 lines of log file