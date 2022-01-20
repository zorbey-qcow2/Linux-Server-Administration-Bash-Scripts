#!/bin/bash

if [ ! -n "$1" ] ; then
	echo 'Missing argument: username'
	echo 'Example: sudo bash' $0 'username'
	exit 1
fi

userName=$1

echo "Given username:" $userName

if [ "$(id -u)" != "0" ] ; then
	echo "Sorry, you are not root."
	echo "Try with sudo."
	exit 2
fi

if id "$1" &>/dev/null; then
    echo 'FatalError: Username exist'
    echo 'Try with another username'
    exit 1
else
    echo 'User not found'
    echo "I'm going to create it"
fi

adduser $userName
usermod -aG sudo $userName
mkdir /home/$userName/.ssh
touch /home/$userName/.ssh/authorized_keys
chmod 700 /home/$userName/.ssh
chmod 600 /home/$userName/.ssh/authorized_keys
chown -R $userName:$username /home/$userName/.ssh

read -p "Enter SSH-Port: " sshport
echo "Your ssh port will be: ${sshport}"

port22='#Port 22'
newport="Port ${sshport}"
permitrootdef='#PermitRootLogin prohibit-password'
permitrootmod='PermitRootLogin no'
passauthdef='#PasswordAuthentication yes'
passauthmod='PasswordAuthentication no'
usepamdef='UsePAM yes'
usepammod='UsePAM no'
x11forwarddef='X11Forwarding yes'
x11forwardmod='X11Forwarding no'

ipaddress=$(hostname -I | awk '{print $1}')

SSHD_FILE=/etc/ssh/sshd_config
if [ -f "$SSHD_FILE" ]; then
    echo "$SSHD_FILE exists. We're going to harden it."
    sed -i "s/$port22/$newport/g" /etc/ssh/sshd_config
    sed -i "s/$permitrootdef/$permitrootmod/g" /etc/ssh/sshd_config
    sed -i "s/$passauthdef/$passauthmod/g" /etc/ssh/sshd_config
    sed -i "s/$usepamdef/$usepammod/g" /etc/ssh/sshd_config
    sed -i "s/$x11forwarddef/$x11forwardmod/g" /etc/ssh/sshd_config
else 
    echo "$SSHD_FILE does not exist."
    exit 1
fi

read -p "Do you use SSH-KEY (y/n) " sshkeych
if [ "$sshkeych" = "y" ]; then
    read -p "Give me your ssh-key " mysshkey
    echo $mysshkey > /home/$userName/.ssh/authorized_keys
else
  echo "Holy.."
fi

systemctl restart sshd

echo "====================="
echo "====================="
echo "Ip adress: $ipaddress"
echo "Username: $userName"
echo "Ssh port: $sshport"
echo "====================="
echo "====================="

echo "NOW: Open new tab and check SSH connection."

sleep 3s

echo "Now the Firewall part is coming. If there is a problem with SSH / exit script"

read -p "Did you check it? Is everything okay?? (y/n) " RESP
if [ "$RESP" = "y" ]; then
  echo "Glad to hear it, going to install UFW and configure it."
  apt update
  apt install ufw
  ufw default allow outgoing
  ufw default deny incoming
  ufw allow $sshport
  ufw enable
else
  echo "Holy.."
fi

passwd -d root
passwd -l root

# cat /etc/ssh/sshd_config | grep "#Port 22"

# check-part
echo "Check these files - confs;"
echo "/etc/ssh/sshd_config"
echo "/home/$userName/.ssh/authorized_keys"
echo "sudo ufw status"
