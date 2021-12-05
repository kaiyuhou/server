#!/bin/bash

docker run -d  \
  -p 127.0.0.1:8015:8096 \
  -p 127.0.0.1:8016:8920 \
  -v ~/jellyfin/config:/config \
  -v ~/jellyfin/cache:/cache \
  -v ~/files/file/:/media \
  --name=jellyfin \
  --restart=unless-stopped \
  jellyfin/jellyfin:latest