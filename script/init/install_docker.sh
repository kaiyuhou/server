#!/bin/bash

# Install Docker Engine and add mike to docker group

install_docker() {
    echo "=== Installing Docker ==="

    apt install curl -y

    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm -f get-docker.sh

    if id -u mike >/dev/null 2>&1; then
        usermod -aG docker mike
    fi

    systemctl enable docker
    echo "=== Docker installed ==="
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_docker
fi
