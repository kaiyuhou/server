#!/bin/bash

docker run -d \
    --name embyserver \
    --volume /home/mike/emby:/config \
    --volume /home/mike/aria2/downloads/crayon/video:/mnt/share1 \
    --publish 127.0.0.1:8010:8096 \
    --publish 127.0.0.1:8011:8920 \
    --device /dev/dri:/dev/dri \
    --env UID=1000 \
    --env GID=1000 \
    --env GIDLIST=1000 \
    emby/embyserver:latest

# embyserver_arm64v8

#docker run -d \
#    --name embyserver \
#    --volume /path/to/programdata:/config \ # Configuration directory
#    --volume /path/to/share1:/mnt/share1 \ # Media directory
#    --volume /path/to/share2:/mnt/share2 \ # Media directory
#    --net=host \ # Enable DLNA and Wake-on-Lan
#    --device /dev/dri:/dev/dri \ # VAAPI/NVDEC/NVENC render nodes
#    --device /dev/vchiq:/dev/vchiq \ # MMAL/OMX on Raspberry Pi
#    --runtime=nvidia \ # Expose NVIDIA GPUs
#    --publish 8096:8096 \ # HTTP port
#    --publish 8920:8920 \ # HTTPS port
#    --env UID=1000 \ # The UID to run emby as (default: 2)
#    --env GID=100 \ # The GID to run emby as (default 2)
#    --env GIDLIST=100 \ # A comma-separated list of additional GIDs to run emby as (default: 2)
#    emby/embyserver:latest