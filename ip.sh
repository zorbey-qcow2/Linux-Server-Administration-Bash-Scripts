#!/bin/bash
## change $myip = "127.0.0.1" to your ip.
myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo "Your IP: $myip"

if [ $myip = "127.0.0.1" ]; 
then
	echo "Continue. Everything OK"
else
	echo "Something wrong - FALSE"
fi;
read;
