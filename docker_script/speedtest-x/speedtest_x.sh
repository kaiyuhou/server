#!/bin/bash

docker run -d -p 8020:80 --restart=on-failure:10 --name=speedtest badapple9/speedtest-x