# using vnc for kde-plasma desktop

## install 

# suppose we already install kde-plasma
```bash
sudo apt update

# install fonts and inputs
sudo locale-gen en_US.UTF-8
sudo apt install -y ttf-wqy-zenhei fonts-noto-cjk-extra ibus-pinyin

# install vnc
sudo apt install -y tigervnc-standalone-server tigervnc-xorg-extension

# install dbus-launce
sudo apt install dbus-x11

# create password
vncpasswd
```

## xstartup setting

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

## start vncserver

```bash
vncserver :1 -depth 24 -geometry 1920x1050 -localhost no

# other options
## protection
-set BlackListTimeout=600 -set BlackListThresholds=10

```
