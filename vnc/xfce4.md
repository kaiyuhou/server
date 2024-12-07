# install vnc on xfce4 desktop

## install vnc server and xfce4

```bash
sudo apt install -y tigervnc-standalone-server tigervnc-xorg-extension
# sudo apt-get install vnc4serve

sudo apt install xfce4 xfce4-goodies xfce4-terminal
sudo update-alternatives --config x-terminal-emulator 
# select /usr/bin/xterm 
```

## xstartup

put file at `~/.vnc/xstartup`

```bash
#!/bin/sh
# Uncomment the following two lines for normal desktop:
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
# exec /etc/X11/xinit/xinitrc
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &
xfce4-session & startxfce4 & 
x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
# x-window-manager &
session-manager & 
xfdesktop & xfce4-panel &
xfce4-menu-plugin &
xfsettingsd &
xfconfd &
xfwm4 &
```

- `startxfce4` maybe enough to start all the xfce4 tools

## start

```bash
vncserver :1 -depth 24 -geometry 1920x1050 -localhost no

# other options
## protection
-set BlackListTimeout=600 -set BlackListThresholds=10
```