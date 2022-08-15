#!/bin/bash

File=/etc/caddy/Caddyfile

if grep -q ":80 {" "$File"; then
  sudo rm $File
  sudo touch $File
fi

read -p "Domain: " domain
read -p "Port: " port

echo "$domain {" | sudo tee -a $File
echo $'\t'"reverse_proxy localhost:$port" | sudo tee -a $File
echo "}" | sudo tee -a $File

sudo caddy reload --config $File