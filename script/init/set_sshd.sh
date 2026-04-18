#!/bin/bash

# Harden SSH: disable root login, disable password auth, add key for mike

set_sshd() {
    local pub_key="$1"
    local sshd_config_path="/etc/ssh/sshd_config"

    if [ -z "$pub_key" ]; then
        echo "Usage: set_sshd <pub_key_content>"
        return 1
    fi

    echo "=== Configuring SSHD ==="

    local sshd_config=$(cat << 'EOF'
# See sshd_config(5) for more information.
#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key

#RekeyLimit default none
#SyslogFacility AUTH
#LogLevel INFO
#LoginGraceTime 2m
LoginGraceTime 30
PermitRootLogin no
#StrictModes yes
MaxAuthTries 3
#MaxSessions 10

#PubkeyAuthentication yes
AuthorizedKeysFile     .ssh/authorized_keys

PasswordAuthentication no
#PermitEmptyPasswords no
KbdInteractiveAuthentication no
# ChallengeResponseAuthentication is deprecated in OpenSSH 8.7+
ChallengeResponseAuthentication no

UsePAM yes

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
X11Forwarding no
PrintMotd no

AcceptEnv LANG LC_*

Subsystem       sftp    /usr/lib/openssh/sftp-server
EOF
    )

    echo "$sshd_config" > $sshd_config_path
    echo "Updated $sshd_config_path"

    # setup ssh key for mike (idempotent)
    sudo -i -u mike bash << 'INNEREOF'
cd ~
if [ ! -d ".ssh/" ]; then
    mkdir .ssh
    chmod 700 .ssh/
    echo "Created .ssh/ for mike"
fi
if [ ! -f ".ssh/authorized_keys" ]; then
    touch .ssh/authorized_keys
    chmod 600 .ssh/authorized_keys
    echo "Created authorized_keys for mike"
fi
INNEREOF

    # append public key for mike
    local auth_keys="/home/mike/.ssh/authorized_keys"
    echo "$pub_key" >> "$auth_keys"

    service sshd restart
    echo "**sshd restarted. Please test RSA login before closing this terminal!**"
    echo "=== SSHD configured ==="
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    set_sshd "$1"
fi
