Some bash scripts that can make your work easier for linux server administration.

## Scripts:

- hostnamechange.sh
sudo bash hostnamechange.sh "hostname"

- ip.sh
Check the IP Address on the terminal screen at startup to look does your computer has the correct ip when it boots up. 
Add the script as a startup application .

- usercheck.sh
sudo bash userchck.sh "username"

Script will check the given username, if not exist, user will created with .ssh file.
Then SSH port and SSH KEY will be asked. UFW will be installed and configured with the given SSH port.
Root user will be locked, sshd_config will be configured for key login only(hardened). 
