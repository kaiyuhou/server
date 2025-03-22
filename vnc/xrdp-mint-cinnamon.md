# install xrdp on Linux Mint Cinnamon 

## install
```bash
sudo apt install -y xorgxrdp xrdp

## RHEL
# dnf install epel-release
# dnf install xrdp
```

## usage 

Windows `mstsc`:
 - client: `ip`, default port is `3389`
 - Session: `Xorg`

## optimization

### client setting

- Display: `High Coler (16bit)`, Lower resolution also helps a lot
- Experience: Performance: `LAN (10 MBps or higher)`


### server setting

```bash
# /etc/xrdp/xrdp.ini

tcp_send_buffer_bytes=4194304
tcp_recv_buffer_bytes=6291456

crypt_level=high # use none for better performance, not recommand, little impact
max_bpp=16 # 15 (not recommand), 16, 24, 32
xserverbpp=16 # 15 (not recommand), 16, 24, 32

# /etc/xrdp/sesman.ini
KillDisconnected=true

# /etc/sysctl.conf

net.core.wmem_max = 8388608  # 2x tcp_send_buffer_bytes
net.core.rmem_max = 12582912 # 2x tcp_recv_buffer_bytes

# make effect

sudo sysctl -p
sudo systemctl restart xrdp

```

## Information

```bash
# start script of xrdp is at /etc/xrdp/startwm.sh

test -x /etc/X11/Xsession && exec /etc/X11/Xsession
exec /bin/sh /etc/X11/Xsession

# which is related to /etc/X11/xinit/xinitrc
# also related to /usr/share/xsessions/cinnamon.desktop

```

Troubleshooting: 
- https://wiki.archlinux.org/title/Xrdp
- https://github.com/neutrinolabs/xrdp/wiki/Tips-and-FAQ

Generate Keyboard Map: 
- https://askubuntu.com/questions/412755/xrdp-how-to-change-keyboard-layout