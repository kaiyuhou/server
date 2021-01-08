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
encrypted_passwd="\$6\$rytVszyZ\$tnq6Nb1n3XpJ7YQ83xzlTyY1oZv6DpJ57zwENBJcyPFKAMKvN5yECud9BJPCMKioTjZytakZ8Ow6WDCf3dHWM1"
sep_line="========================"

echo "adduser $username"

# add user
adduser $username --gecos "" --disabled-password
adduser $username sudo 

# change passwd
sed -i "s/^$username:\*:/$username:$encrypted_passwd:/" $shadow_path

# set nopasswd in sudo
sed -i '$a mike ALL=(ALL) NOPASSWD:ALL' $sudoers_path