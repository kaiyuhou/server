#!/bin/bash

docker run -d -p --restart=on-failure:10 8020:80  badapple9/speedtest-x