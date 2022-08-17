mkdir /disk2/navidrome

docker run -d \
   --name navidrome \
   --restart=unless-stopped \
   -v /disk2/Musics:/music \
   -v /disk2/navidrome:/data \
   -p 127.0.0.1:8011:4533 \
   -e ND_LOGLEVEL=info \
   deluan/navidrome:latest