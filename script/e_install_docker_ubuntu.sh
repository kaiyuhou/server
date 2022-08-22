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

if id -u ubuntn >/dev/null 2>&1; then
  sudo usermod -aG docker ubuntu
fi
# systemctl enable docker
# systemctl start docker

echo "install docker compose"
sudo curl -L "https://github.com/docker/compose/releases/download/v2.8.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo "== please log out and log in again =="
