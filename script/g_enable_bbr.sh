#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
fi

echo "enable BBR, Requirement: Linux Kernel >= 4.9"
uname -r

echo net.core.default_qdisc=fq >> /etc/sysctl.conf
echo net.ipv4.tcp_congestion_control=bbr >> /etc/sysctl.conf
sysctl -p

sysctl net.ipv4.tcp_available_congestion_control
lsmod | grep bbr
