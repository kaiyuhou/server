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
COPY wallpapers /headless/wallpapers
RUN cp /headless/wallpapers/non-non-biyori.png /headless/.config/bg_sakuli.png

RUN apt-get install sudo -y
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ubuntu
