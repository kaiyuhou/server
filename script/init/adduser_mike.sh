#!/bin/bash

# Add user mike with sudo privileges

adduser_mike() {
    local username="mike"
    local sudoers_path="/etc/sudoers"

    echo "=== Adding user $username ==="

    # check if user exists
    if id -u "$username" &> /dev/null; then
        echo "User $username already exists, ensuring sudo privileges"
    else
        # add user
        adduser $username --gecos "" --disabled-password
    fi

    # ensure user is in sudo group
    usermod -aG sudo $username

    # set nopasswd in sudo
    sed -i '$a mike ALL=(ALL) NOPASSWD:ALL' $sudoers_path

    echo "=== User $username configured ==="
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    adduser_mike
fi
