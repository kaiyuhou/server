#!/bin/bash

read -p "Hostname: " HOSTNAME

sep_line="========================"

print_sep_line() {
    echo $sep_line 
}

add_basic_software() {
    apt update
    apt install -y curl htop ufw neofetch nano locale
}

show_basic_info() {
    curl ipinfo.io
    neofetch
}

set_host_name() {
    if [ ! -n "$HOSTNAME" ]; then
	    echo "Usage: hostname needed"
	    exit 1
    fi

    old_hostname=$(hostname)
    new_hostname=$HOSTNAME
    echo "previous hostname: $old_hostname"
    echo "set new hostname: $new_hostname"

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
}
 

set_utf8() {
    echo "Set UTF-8"
    cat /etc/default/locale
    sed -i 's/LANG=.*/LANG="en_US\.UTF-8"/' /etc/default/locale
    sed -i 's/LANGUAGE=.*/LANGUAGE="en_US:en"/' /etc/default/locale
    echo "New config"
    locale-gen en_US.UTF-8
    cat /etc/default/locale
}

enable_bbr() {
    echo "enable BBR, Requirement: Linux Kernel >= 4.9"
    uname -r

    echo net.core.default_qdisc=fq >> /etc/sysctl.conf
    echo net.ipv4.tcp_congestion_control=bbr >> /etc/sysctl.conf
    sysctl -p

    sysctl net.ipv4.tcp_available_congestion_control
    lsmod | grep bbr
}

add_user_mike() {
    username="mike"
    shadow_path="/etc/shadow"
    sudoers_path="/etc/sudoers"

    echo "adduser $username"

    # add user
    adduser $username --gecos "" --disabled-password
    adduser $username sudo

    # disable root passwd
    # echo "disable root password"
    # usermod -p '!' root

    # set nopasswd in sudo
    sed -i '$a mike ALL=(ALL) NOPASSWD:ALL' $sudoers_path

    # set ssh config
    wget --no-check-certificate -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/script/c_set_sshd.sh > c_set_sshd.sh
    bash ./c_set_sshd.sh
}

set_ufw() {
    echo "==before=="
    ufw status verbose
    ufw app list

    echo "allow ssh"
    ufw allow ssh

    echo "enable ufw"
    echo "y" | ufw enable
    systemctl enable ufw

    echo "==after=="
    ufw status verbose
}

install_docker() {
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh

    if id -u mike >/dev/null 2>&1; then
        usermod -aG docker mike
    fi
    
    systemctl enable docker
    # systemctl start docker
}

install_caddy() {
    apt install -y curl debian-keyring debian-archive-keyring apt-transport-https
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
    apt update
    apt install caddy -y

    echo "ufw allow 80 443"
    ufw allow 80
    ufw allow 443
}

reboot_node() {
    echo $seperate_line
    read -p "Restart Computer Now? [Y/n]" answer

    if [ "$answer" != "${answer#[Nn]}" ] ; then
        exit 0
    fi

    echo "Reboot in 10 Seconds..."
    sleep 10s
    echo "Reboot"
    reboot
}


if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
fi

# reset root passwd
passwd

# auto select needrestart in apt
if [ -f "/etc/needrestart/needrestart.conf" ]; then
    sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
fi

add_basic_software
show_basic_info
set_host_name
set_utf8
enable_bbr
add_user_mike
set_ufw
install_docker
# install_caddy
reboot_node
