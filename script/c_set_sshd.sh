#!/bin/bash

sshd_config_path="/etc/ssh/sshd_config"
# sshd_config_path="test.txt"

unreliabley_pub_key="ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA9kVNB0RG8tYE6LR02+njqhaCe8KLJnm/5iHnhZgfYMyMslJk12XBo6M7saCPvQEcHhp6qdSSUH9zYgR/FbwW4mN9oaEL0By5w5ExDRgMgtOi6TDFnH9CFNwsAu0hX9HWgBWfH/Y7QyVwbe8ArCjRJZuz1Ki5vZq/81a4301jWvamIAXYOmrVcUwkaZIpPHrxxzG8dIAG6aVCJDQR+XFPiqOQufw8g0eg//QDyM8H9gKbaOeDllXmwzCFCMQZl8qDSMKgIXdk4KonxnsSWcIrolSH1Q0rYTZ44uui7l2SdjbK+DArWyeM12T+htRA4YDkpTZkfL4mmb/ha4kcblCJww== unreliabley-pub-key"

sshd_config=`cat << EOF
# See sshd_config(5) for more information.
# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

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
PermitRootLogin no
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes

AuthorizedKeysFile     .ssh/authorized_keys

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

PasswordAuthentication no
#PermitEmptyPasswords no

ChallengeResponseAuthentication no

#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no

#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no

UsePAM yes

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
X11Forwarding yes
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
PrintMotd no
#PrintLastLog yes
#TCPKeepAlive yes
#UseLogin no
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# Allow client to pass locale environment variables
AcceptEnv LANG LC_*

# override default of no subsystems
Subsystem       sftp    /usr/lib/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#       X11Forwarding no
#       AllowTcpForwarding no
#       PermitTTY no
#       ForceCommand cvs server
EOF
`

echo "$sshd_config" > $sshd_config_path
echo "update /etc/ssh/sshd_config"

# switch to user mike
sudo -i -u mike bash << EOF
cd ~
if [ ! -d ".ssh/" ];then
	mkdir .ssh
	chmod 700 .ssh/

	echo "create .ssh/ in mike"
fi
if [ ! -f "authorized_keys" ];then
	touch .ssh/authorized_keys
    chmod 600 .ssh/authorized_keys
	
	echo "authorized_keys in .ssh/"
fi
echo "$unreliabley_pub_key" >> .ssh/authorized_keys
EOF

service sshd restart
echo "**sshd service restart. please try RSA login before close this terminal!**"
