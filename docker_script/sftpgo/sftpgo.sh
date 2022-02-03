

mkdir -p ~/sftpgodata
mkdir -p ~/sftpgohome

# 8080: web client
# 2020: sftp
# 10080: webdav

docker run -d \
    -p 127.0.0.1:8016:8080 \
    -p 8017:2022 \
    -p 8018:10080 \
    -e SFTPGO_WEBDAVD__BINDINGS__0__PORT=10080 \
    --name sftpgo \
    -v ~/games:/srv/sftpgo \
    -v ~/sftpgohome:/var/lib/sftpgo \
    --restart=unless-stopped \
    -d "drakkan/sftpgo"

