#!/bin/bash

# Add user mike with sudo privileges

adduser_mike() {
    local username="mike"
    local sudoers_path="/etc/sudoers"

    echo "=== Adding user $username ==="

    # add user
    adduser $username --gecos "" --disabled-password
    adduser $username sudo

    # set nopasswd in sudo
    sed -i '$a mike ALL=(ALL) NOPASSWD:ALL' $sudoers_path

    echo "=== User $username added ==="
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    adduser_mike
fi
