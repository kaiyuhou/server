#!/bin/bash

# Enable BBR congestion control (requires Linux Kernel >= 4.9)

enable_bbr() {
    echo "=== Enabling BBR ==="
    echo "Requirement: Linux Kernel >= 4.9"
    uname -r

    echo "==before=="
    sysctl net.ipv4.tcp_available_congestion_control
    lsmod | grep bbr || true

    echo "==after=="
    if ! grep -q "net.core.default_qdisc=fq" /etc/sysctl.conf; then
        echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    fi
    if ! grep -q "net.ipv4.tcp_congestion_control=bbr" /etc/sysctl.conf; then
        echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    fi
    sysctl -p

    sysctl net.ipv4.tcp_available_congestion_control
    lsmod | grep bbr
    echo "=== BBR enabled ==="
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    enable_bbr
fi
