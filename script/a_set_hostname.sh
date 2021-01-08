#!/bin/bash

# Usage: bash set_hostname.sh [hostname]
# Update hostname in /etc/hostname and /etc/hosts
# Reboot computer to make the change effected.

seperate_line="========================"

if [ ! -n "$1" ]; then
	echo "Usage: bash set_hostname.sh [hostname]"
	exit -1
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
echo $seperate_line
echo "[new $hosts_path]"
cat $hosts_path


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
