#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
fi

apt install curl -y

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

if id -u mike >/dev/null 2>&1; then
  sudo usermod -aG docker mike
fi
# systemctl enable docker
# systemctl start docker

echo "== please log out and log in again =="
