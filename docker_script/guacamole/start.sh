#!/bin/bash

mkdir -p ~/guacamole/init

docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --postgres > ~/guacamole/init/initdb.sql

docker-compose -f guacamole.yml up -docker

### Caddy