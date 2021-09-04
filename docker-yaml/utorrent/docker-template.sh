# utorrent

docker run -d --restart=on-failure:10  \
    --network host  \
    --name utorrent  \
    -v ~/utorrent/data:/data  \
    -v ~/utorrent/settings:/utorrent/settings  \
    ekho/utorrent:latest