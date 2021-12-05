#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
fi

echo "enable BBR, Requirement: Linux Kernel >= 4.9"
uname -r

echo "==before=="
sysctl net.ipv4.tcp_available_congestion_control
lsmod | grep bbr

echo "==after=="
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


## CentOS 7 enable bbr
# https://www.gaoxiaobo.com/web/server/131.html

#rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
#yum install https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm -y
#yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
#yum --disablerepo='*' --enablerepo=elrepo-kernel install kernel-ml -y
#grub2-set-default 0
#
#echo 'net.core.default_qdisc=fq' >> /etc/sysctl.conf
#echo 'net.ipv4.tcp_congestion_control=bbr' >> /etc/sysctl.conf
#
#sysctl -n net.ipv4.tcp_congestion_control
#lsmod | grep bbr
#
#reboot