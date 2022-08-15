mkdir /disk2/molody-profile
docker run -d \
    -p 127.0.0.1:8011:5566 \
    -v /disk2/melody-profile:/app/backend/.profile \
    foamzou/melody:latest
