#!/bin/bash

File=/etc/caddy/Caddyfile

if grep -q ":80 {" "$File"; then
  sudo rm $File
  touch $File
fi

read -p "Domain: " domain
read -p "Port: " port

sudo echo "$domain {" >> $File
sudo echo $'\t'"reverse_proxy localhost:$port" >> $File
sudo echo "}" >> $File

sudo caddy reload --config $File