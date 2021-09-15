#!/bin/bash

docker-compose -f aria2.yml up -d

# use web server to reverse proxy port 8003 8005