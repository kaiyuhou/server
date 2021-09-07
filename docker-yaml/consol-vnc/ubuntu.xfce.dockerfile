## Custom Dockerfile
FROM consol/ubuntu-xfce-vnc
ENV REFRESHED_AT 2021-09-03

# Switch to root user to install additional software
USER 0

RUN apt-get update
RUN apt-get install docker.io -y
RUN apt-get install xfce4-goodies -y

ENV VNC_RESOLUTION=1600x900

RUN adduser --disabled-password --gecos "" --uid 1000 ubuntu
RUN adduser ubuntu sudo

RUN adduser ubuntu docker
RUN usermod -aG docker ubuntu
RUN newgrp docker

# Set Wallpaper
COPY wallpapers/* /headless/.config/
RUN cp /headless/.config/non-non-biyori.png /headless/.config/bg_sakuli.png

# Install Sublime
RUN wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add - && \
    apt-get install apt-transport-https && \
    echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list && \
    apt-get update && \
    apt-get install sublime-text -y

RUN apt-get install htop nano -y

# Install Icon and Theme
COPY themes/Qogir /usr/share/themes/Qogir/
COPY themes/Qogir-light /usr/share/themes/Qogir-light

RUN apt install software-properties-common -y && \
    add-apt-repository ppa:papirus/papirus -y && \
    apt update && \
    apt install papirus-icon-theme

# Set xfce panel
COPY xfce-config/* /headless/.config/xfce4/xfconf/xfce-perchannel-xml/

## Unused themes and Icons
# RUN apt install software-properties-common -y && \
#    add-apt-repository ppa:daniruiz/flat-remix -y && \
#    apt update && \
#    apt install flat-remix

RUN apt-get install sudo -y
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Update startup script
COPY scripts/vnc_startup.sh /dockerstartup/vnc_startup.sh
RUN chmod +x /dockerstartup/vnc_startup.sh

USER ubuntu

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
