# using vnc for kde-plasma desktop

## install 

```bash
# suppose we already installed kde-plasma
sudo apt update

# install fonts and inputs
sudo locale-gen en_US.UTF-8
sudo apt install -y ttf-wqy-zenhei fonts-noto-cjk-extra ibus-pinyin

# install vnc
sudo apt install -y tigervnc-standalone-server tigervnc-xorg-extension

# install dbus-launch
sudo apt install dbus-x11

# create password
vncpasswd
```

## Start vncserver by config/command

- tigervnc does not recommend to use `xstartup`: https://github.com/TigerVNC/tigervnc/issues/1271

- the recommend way config tigervnc is to use `/etc/tigervnc/vncserver-config-mandatory`:
  - Simple Howto: https://github.com/TigerVNC/tigervnc/blob/master/unix/vncserver/HOWTO.md
  - Docs: https://wiki.archlinux.org/title/TigerVNC

- **simple way:** just use the command to specify desktop session
```bash
vncserver :1 -depth 16 -geometry 1920x1050 -localhost no -- plasma
# "plasma" is the seesion name, locate at /usr/share/xsessions
# ls /usr/share/xsessions: plasma.desktop
# supported desktops: https://wiki.archlinux.org/title/Desktop_environment

## other options
# protection
# -set BlackListTimeout=600 -set BlackListThresholds=10

## not sure if we have to run following commands to reset something
# unset SESSION_MANAGER
# unset DBUS_SESSION_BUS_ADDRESS
# exec /etc/X11/xinit/xinitrc
# xsetroot -solid grey
```

## Use TLS for traffic encrytion

```bash
# self-signed certificate
sudo apt install openssl -y
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout server.key -out server.crt

# start vncserver
vncserver :1 -depth 16 -geometry 1920x1050 -localhost no -X509Cert=/home/$USER/.vnc/server.crt -X509Key=/home/$USER/.vnc/server.key -SecurityTypes=X509Vnc -- plasma

# SecurityTypes: VncAuth(default), Plain, TLSNone, TLSVnc, TLSPlain, X509None, X509Vnc, X509Plain
```  
**Node:** realVNC viewer does not support TLSVnc or X509Vnc, try tigerVNC vierver https://tigervnc.org/

## [Deprecated] xstartup setting

create `xstartup` file at `~/.vnc/xstartup`

```
# unset SESSION_MANAGER
# unset DBUS_SESSION_BUS_ADDRESS
exec /etc/X11/xinit/xinitrc
# xsetroot -solid grey
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
vncconfig -iconic &
dbus-launch --exit-with-session /usr/bin/startplasma-x11 
```

- `vncconfig -iconic & `: copy/paste for vnc
- not sure how the following four lines work, but combination of them will make the vnc work
```
# unset SESSION_MANAGER
# unset DBUS_SESSION_BUS_ADDRESS
exec /etc/X11/xinit/xinitrc
# xsetroot -solid grey
```

 start vncserver

```bash
vncserver :1 -depth 16 -geometry 1920x1050 -localhost no

# other options
## protection
-set BlackListTimeout=600 -set BlackListThresholds=10
```
