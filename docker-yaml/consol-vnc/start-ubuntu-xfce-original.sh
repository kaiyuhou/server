#!/bin/bash
docker run -d \
  --privileged \
  --restart=on-failure:10 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -p 8001:5901 -p 8002:6901 \
  -e VNC_PW=VNC_PASSWORD \
  -e VNC_RESOLUTION=1600x900 \
  -v ~/vnc-data:/headless \
  --user 0 \
  consol/ubuntu-xfce-vnc

## --usr 0: use root account, optional
## 5091: VNC, 6091: browser VNC