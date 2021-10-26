#!/bin/bash

mkdir uptimekuma
cd uptimekuma

docker run -d \
  --network=host \
  --restart=always \
  -v ~/uptimekuma/data:/app/data \
  --name uptime-kuma \
  louislam/uptime-kuma:1


#docker run -d \
#  --network=host \
#  --restart=always \
##  -p 127.0.0.1:8004:3001 \
#  -v ~/uptimekuma/data:/app/data \
##  -v ~/uptimekuma/uptime-kuma:/root/uptime-kuma \
#  --name uptime-kuma \
#  louislam/uptime-kuma:1