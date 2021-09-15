#!/bin/bash

cd ~ || exit
mkdir filebrowser
cd filebrowser || exit

if [ ! -f database.db ]; then
    touch database.db
fi

if [ ! -f filebrowser.json ]; then
    touch filebrowser.json
fi


docker run -d \
  --restart=on-failure:10 \
  -v /home/mike/filebrowser/database.db:/database.db \
  -v /home/mike/filebrowser/filebrowser.json:/.filebrowser.json \
  -v /home/mike/aria2/downloads/:/srv \
  -p 127.0.0.1:8007:80 \
  --name filebrowser \
  filebrowser/filebrowser