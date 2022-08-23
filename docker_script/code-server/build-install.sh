mkdir -p $HOME/workspace/code-server/.config
docker run -d \
  --restart=unless-stopped \
  --name code-server \
  -p 127.0.0.1:8017:8080 \
  -v "$HOME/workspace/code-server/.config:/home/coder/.config" \
  -v "$HOME/workspace:/home/coder/project" \
  -u "$(id -u):$(id -g)" \
  -e "DOCKER_USER=$USER" \
  codercom/code-server:latest