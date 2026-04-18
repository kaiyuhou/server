#!/bin/bash

# Install basic software packages

basic_software() {
    echo "=== Installing basic software ==="
    apt update
    apt install -y curl htop ufw nano locales
    echo "=== Basic software installed ==="
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    basic_software
fi
