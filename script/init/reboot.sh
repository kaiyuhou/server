#!/bin/bash

# Prompt for reboot (should be the last step)

reboot_node() {
    echo "========================"
    read -p "Restart Computer Now? [Y/n] " answer

    if [ "$answer" != "${answer#[Nn]}" ]; then
        echo "Skipping reboot."
        exit 0
    fi

    echo "Reboot in 10 Seconds..."
    sleep 10s
    echo "Reboot"
    reboot
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    reboot_node
fi
