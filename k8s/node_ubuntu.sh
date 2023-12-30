
# 关闭 swap
sudo swapoff -a
sudo sed -ri 's/.*swap.*/#&/' /etc/fstab

# [optional] RHEL 系需要关闭 SELinux

# 开放端口：https://kubernetes.io/docs/reference/networking/ports-and-protocols/
## control plane
sudo ufw allow 6443 # api-server
sudo ufw allow 2379 # etcd
sudo ufw allow 2389 # etcd
sudo ufw allow 10250 # kubelet
## worker nodes
sudo ufw allow 10250 # kubelet

# 启用内核模块，转发桥接流量
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

# 修改 sysctl，转发桥接流量
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system

# [OPTIONAL] 查看 containerd 安装情况
sudo apt show containerd.io

# 重置 containerd 配置 & 修改 containerd 配置
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i "s/SystemdCgroup = false/SystemdCgroup = true/" "/etc/containerd/config.toml"
sudo sed -i "/disabled_plugins = \[\"cri\"\]/d" "/etc/containerd/config.toml"
sudo sed -i 's/sandbox_image.*$/sandbox_image = "registry.k8s.io\/pause:3.9"/g' "/etc/containerd/config.toml"

# sandbox_image = "registry.k8s.io/pause:3.9"

# [OPTIONAL] 修改 pause 镜像为国内源
#  sandbox_image = "registry.aliyuncs.com/google_containers/pause:3.9"

# [OPTIONAL] 修改镜像源用国内加速
#  [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
#    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
#      endpoint = ["https://hub-mirror.c.163.com"]

sudo systemctl restart containerd

# [OPTIONAL] 测试 containerd 正常使用
# sudo ctr images pull docker.io/library/redis:alpine
# sudo ctr images ls
# sudo ctr c create --net-host docker.io/library/redis:alpine redis
# sudo ctr task start -d redis
# sudo ctr containers ls
# sudo ctr task kill -s SIGKILL redis
# sudo ctr containers rm redis

# 安装 ipvs
cat <<EOF | sudo tee /etc/modules-load.d/ipvs.conf
ip_vs
ip_vs_rr
ip_vs_wrr
ip_vs_sh
nf_conntrack
EOF
sudo modprobe ip_vs
sudo modprobe ip_vs_rr
sudo modprobe ip_vs_wrr
sudo modprobe ip_vs_sh
sudo modprobe nf_conntrack
sudo apt install -y ipset ipvsadm

# [OPTIONAL] 查看 ipvs 运行状态
# sudo ipvsadm -ln
# kubectl get configmap -n kube-system kube-proxy -o yaml | grep mode

# 时间同步
sudo apt install -y chrony
sudo systemctl enable chrony
sudo systemctl start chrony
# [OPTIONAL] 设置时区
# timedatectl set-timezone Asia/Shanghai # Europe/London
# [OPTIONAL] 国内时间服务器
# echo 'server tiger.sina.com.cn iburst' >> /etc/chrony/sources.d/cn-ntp-server.sources
# echo 'server ntp1.aliyun.com iburst' >> /etc/chrony/sources.d/cn-ntp-server.sources
# sudo chronyc reload sources

# [OPTIONAL] 修改 节点名称 nodename
# new_hostname=NEWNAME
# old_hostname=$(hostname)
# sudo hostnamectl set-hostname $new_hostname
# sed -i "s/$old_hostname/$new_hostname/g" "/etc/hosts"
# sudo systemctl restart systemd-hostnamed

# 安装 kubelet kubeadm kubectl
sudo apt install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
# [OPTIONAL] 指定版本
# sudo apt install -y kubelet=1.29.0-00 kubeadm=1.29.0-00 kubectl=1.29.0-00
# [OPTIONAL] 国内源
# curl -s https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add -
# tee /etc/apt/sources.list.d/kubernetes.list <<-'EOF'
# deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
# EOF




















# ?? CNI 的必要性

ctr version
runc -v
nerdctl # ctr 的替代工具
crictl # k8s 通过 cri 调用 containerd 的工具