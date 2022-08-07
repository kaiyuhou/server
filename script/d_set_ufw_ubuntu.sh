#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
fi

if ! [ -x "$(command -v ufw)" ]; then  # -x: if the path executable
	echo "install ufw"
	apt install ufw -y
fi

echo "==before=="
ufw status verbose
ufw app list

echo "allow ssh"
ufw allow ssh

echo "enable ufw"
#sleep 10s
ufw enable

echo "==after=="
ufw status verbose
