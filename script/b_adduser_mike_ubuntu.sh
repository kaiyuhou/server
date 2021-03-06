#!/bin/bash

# Usage: bash adduser_mike.sh
# add user and set password

# for Ubuntu/Debian
# if grep -q 'Ubuntu\|Debian' /etc/issue; then
#     adduser .....
# else
#     useradd .....
# fi
# echo "$username:[password]" | sudo chpasswd
# usermod -aG sudo $username

username="mike"
shadow_path="/etc/shadow"
sudoers_path="/etc/sudoers"
sep_line="========================"

echo "adduser $username"

# add user
adduser $username --gecos "" --disabled-password
adduser $username sudo

# disable root passwd
# echo "disable root password"
# usermod -p '!' root

# set nopasswd in sudo
sed -i '$a mike ALL=(ALL) NOPASSWD:ALL' $sudoers_path