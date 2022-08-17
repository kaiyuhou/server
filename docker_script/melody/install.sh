mkdir /disk2/molody-profile
docker run -d \
    -p 127.0.0.1:8011:5566 \
    -v /disk2/melody-profile:/app/backend/.profile \
    foamzou/melody:latest

# 大失败，项目还很不成熟
# 并不能解锁不可播放歌曲
# 需要直接明文登录网易账号