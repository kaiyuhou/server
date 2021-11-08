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

#==Disable BBR==
#
#nano /etc/sysctl.conf
#remove the folloing line
#
## net.core.default_qdisc = fq
## net.ipv4.tcp_congestion_control = bbr
#
#sysctl -p
#reboot

# reboot computer
echo $seperate_line
read -p "Restart Computer Now? [Y/n]" answer

if [ "$answer" != "${answer#[Nn]}" ] ; then
	exit 0
fi

echo "Reboot"
reboot