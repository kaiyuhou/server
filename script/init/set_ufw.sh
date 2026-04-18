#!/bin/bash

# Configure UFW firewall and allow SSH

set_ufw() {
    echo "=== Configuring UFW ==="

    if ! [ -x "$(command -v ufw)" ]; then
        echo "Installing ufw"
        apt install ufw -y
    fi

    echo "==before=="
    ufw status verbose
    ufw app list

    echo "Allow SSH"
    ufw allow ssh

    echo "Enable UFW"
    echo "y" | ufw enable
    systemctl enable ufw

    echo "==after=="
    ufw status verbose
    echo "=== UFW configured ==="
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    set_ufw
fi
