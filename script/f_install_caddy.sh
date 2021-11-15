#!/bin/bash

# Ubuntu
sudo apt install -y curl debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo tee /etc/apt/trusted.gpg.d/caddy-stable.asc
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy

echo "ufw allow 80 443"
sudo ufw allow 80
sudo ufw allow 443

# Centos
#dnf install 'dnf-command(copr)' -y
#dnf copr enable @caddy/caddy -y
#dnf install caddy -y