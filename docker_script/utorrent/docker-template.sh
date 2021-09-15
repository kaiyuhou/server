# utorrent

docker run -d --restart=on-failure:10  \
    -v ~/utorrent/data:/data  \
    -v ~/utorrent/settings:/utorrent/settings  \
    --name utorrent  \
    --ipv6
    ekho/utorrent:latest


# --network host  \