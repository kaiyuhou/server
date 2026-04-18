#!/bin/bash
# Install Caddy web server
# Usage: bash install_caddy.sh

install_caddy() {
    echo "=== Installing Caddy ==="

    apt install -y curl debian-keyring debian-archive-keyring apt-transport-https
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
    apt update
    apt install caddy -y

    echo "UFW allow 80 443"
    ufw allow 80
    ufw allow 443

    echo "=== Caddy installed ==="
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_caddy
fi
