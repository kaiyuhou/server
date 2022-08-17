#!/bin/bash

docker_config=`cat << EOF
{
  "ipv6": true,
  "fixed-cidr-v6": "fd00::/80",
  "experimental": true,
  "ip6tables": true
}
EOF
`

echo $docker_config | sudo tee /etc/docker/daemon.json
sudo systemctl restart docker
# Test
# sudo docker run --rm -it busybox ifconfig
# sudo docker run --rm -it busybox ping6 ipv6.google.com