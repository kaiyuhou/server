#!/bin/bash

# Usage: bash set_hostname.sh [hostname]
# Update hostname in /etc/hostname and /etc/hosts
# Reboot computer to make the change effected.

seperate_line="========================"

# shellcheck disable=SC2236
if [ ! -n "$1" ]; then
	echo "Usage: bash set_hostname.sh [hostname]"
	exit 1
fi

echo $seperate_line
new_hostname=$1
echo "set new hostname: $new_hostname"
old_hostname=$(hostname)
echo "previous hostname: $old_hostname"


# set hostname file
hostname_path="/etc/hostname"
sed -i "s/$old_hostname/$new_hostname/" $hostname_path
echo $seperate_line
echo "[new $hostname_path]"
cat $hostname_path


# set hosts file
hosts_path="/etc/hosts"
sed -i "s/$old_hostname/$new_hostname/g" $hosts_path
# hostnamectl set-hostname $new_hostname
echo $seperate_line
echo "[new $hosts_path]"
cat $hosts_path


# set utf8
echo "Set UTF-8"
cat /etc/default/locale
sed -i 's/LANG=.*/LANG="en_US\.UTF-8"/' /etc/default/locale
sed -i 's/LANGUAGE=.*/LANGUAGE="en_US:en"/' /etc/default/locale
echo "New config"
locale-gen en_US.UTF-8
cat /etc/default/locale

# enable bbr
echo "enable BBR, Requirement: Linux Kernel >= 4.9"
uname -r

echo "==before=="
sysctl net.ipv4.tcp_available_congestion_control
lsmod | grep bbr | true

echo "==after=="
echo net.core.default_qdisc=fq >> /etc/sysctl.conf
echo net.ipv4.tcp_congestion_control=bbr >> /etc/sysctl.conf
sysctl -p

sysctl net.ipv4.tcp_available_congestion_control
lsmod | grep bbr

# reboot computer
echo $seperate_line
read -p "Restart Computer Now? [Y/n]" answer

if [ "$answer" != "${answer#[Nn]}" ] ; then
	exit 0
fi

echo "Reboot in 10 Seconds..."
sleep 10s
echo "Reboot"
reboot
