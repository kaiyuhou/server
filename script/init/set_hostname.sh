#!/bin/bash

# Set system hostname
# Usage: source this file then call set_hostname "new_hostname"
#   or:  bash set_hostname.sh <hostname>

set_hostname() {
    local new_hostname=$1

    if [ -z "$new_hostname" ]; then
        echo "Usage: set_hostname <hostname>"
        return 1
    fi

    local old_hostname=$(hostname)
    echo "=== Setting hostname ==="
    echo "Previous hostname: $old_hostname"
    echo "New hostname: $new_hostname"

    # escape special characters for sed
    local old_escaped=$(printf '%s\n' "$old_hostname" | sed 's/[.[\/\*^$]/\\&/g')
    local new_escaped=$(printf '%s\n' "$new_hostname" | sed 's/[.\/&]/\\&/g')

    # set hostname file
    local hostname_path="/etc/hostname"
    sed -i "s/$old_escaped/$new_escaped/" $hostname_path
    echo "[new $hostname_path]"
    cat $hostname_path

    # set hosts file
    local hosts_path="/etc/hosts"
    sed -i "s/$old_escaped/$new_escaped/g" $hosts_path
    echo "[new $hosts_path]"
    cat $hosts_path

    # apply hostname immediately
    hostnamectl set-hostname "$new_hostname"

    echo "=== Hostname set ==="
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    set_hostname "$1"
fi
