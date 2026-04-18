#!/bin/bash
# Unified init setup script
# Usage: bash init.sh

set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

GITHUB_RAW="https://raw.githubusercontent.com/kaiyuhou/server/main"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INIT_DIR="$SCRIPT_DIR/init"
CERT_DIR="$SCRIPT_DIR/cert"

# Download all init modules and cert
mkdir -p "$INIT_DIR" "$CERT_DIR"
for f in basic_software set_hostname set_utf8 enable_bbr adduser_mike set_sshd set_ufw install_docker reboot; do
    wget --no-check-certificate -qO- "${GITHUB_RAW}/script/init/${f}.sh" > "$INIT_DIR/${f}.sh"
done
wget --no-check-certificate -qO- "${GITHUB_RAW}/script/cert/unreliabley.pub" > "$CERT_DIR/unreliabley.pub"

# Source all init modules
source "$INIT_DIR/basic_software.sh"
source "$INIT_DIR/set_hostname.sh"
source "$INIT_DIR/set_utf8.sh"
source "$INIT_DIR/enable_bbr.sh"
source "$INIT_DIR/adduser_mike.sh"
source "$INIT_DIR/set_sshd.sh"
source "$INIT_DIR/set_ufw.sh"
source "$INIT_DIR/install_docker.sh"
source "$INIT_DIR/reboot.sh"

# Prompt for hostname
read -p "Hostname: " HOSTNAME

# Reset root passwd
passwd

# Auto select needrestart in apt
if [ -f "/etc/needrestart/needrestart.conf" ]; then
    sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
fi

# Read public key
PUB_KEY=$(cat "$CERT_DIR/unreliabley.pub")

# Execute init steps in order
basic_software
set_hostname "$HOSTNAME"
set_utf8
enable_bbr
adduser_mike
set_sshd "$PUB_KEY"
set_ufw
install_docker

# Reboot is always the last step
reboot_node
