#!/bin/bash
#source: server.sh
#create: 2021-01-17
#usage: bash <(wget -qO- git.io/srvsh)
#credit: color schame from sysbench.sh

clear
DIR=${HOME}/server_script
if [ ! -d $DIR ];then
    mkdir $DIR
fi
cd $DIR

# copy from superbench
if [ -f /etc/redhat-release ]; then
            release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
            release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
            release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
            release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
            release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
            release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
            release="centos"
fi

out1 () {
        color=$1
        what=$2
        array=("r" "g" "y" "b" "p" "s" "w")
        for i in `seq 31 37`;do
                if [ ${array[$(($i-31))]} == $color ] ; then
                        echo -ne "\e[1;${i}m${what}\e[0m"
                        break
                fi
        done
}
out0 () {
        color=$1
        what=$2
        array=("r" "g" "y" "b" "p" "s" "w")
        for i in `seq 31 37`;do
                if [ ${array[$(($i-31))]} == $color ] ; then
                        echo -ne "\e[0;${i}m${what}\e[0m"
                        break
                fi
        done
}

out0 s "bash <(wget --no-check-certificate -qO- git.io/srvsh)\n"
out0 r "v 1.0\n"
while [ 1 -eq 1 ];do
out0 y "Select a number: \n"
out1 y "------------------------------------------ \n"
out1 b " 0. init setup           - Init Setup\n"
out1 b " 1. bench.sh             - Basic Performance and Network Test\n"
out1 b " 2. dd.sh (cxthhhhh.com) - DD Instal New OS\n"
out1 b " 3. hostname_utf8_bbr    - Set Hostname UTF-8, BBR\n"
out1 b " 4. adduser_mike.sh      - Add User mike\n"
out1 b " 5. set_sshd.sh          - Disable root and pwd login|Add key for mike\n"
out1 b " 6. set_ufw.sh           - Enable firewall UFW|Allow port 22\n"
out1 b " 456. 4 + 5 + 6          - Add User, Set SSH, Set UFW\n"
out1 b " 7. install_docker.sh    - Install Docker\n"
out1 b " 76. ipv6nat_for_docker.sh - Enable IPv6 Nat Docker\n"
out1 b " 9. container-vnc.sh     - Install ubuntu-vnc\n"
out1 b " f. install_caddy.sh     - Install caddy\n"
out1 b " 7f. 7 + f docker caddy  - Install docker + caddy\n"
out1 b " g. enable_bbr.sh        - Enable bbr\n"
out1 b " h. add_caddy_record.sh  - Add Caddy Record and Reload\n"
out1 b " s. speedtest-x server   - Docker Speedtest-x port 8020\n"
out1 b " s3. 3Net Speed Test     - speedtest.sh bash\n"
out1 r " q. clear & exit   \n"
out1 y "------------------------------------------ \n"


read id
case $id in
    q)
        rm -rf ${DIR}
        clear
        out0 p "Clear Done\n"
        break
        ;;
    0)
        wget --no-check-certificate -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/script/0_init_setup.sh > init_setup.sh
        bash ${DIR}/init_setup.sh
        rm -rf ${DIR}
        out0 p "Clear Done\n"
        break
        ;;
    1)
        wget --no-check-certificate -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/bench/bench.sh > bench.sh
        bash ${DIR}/bench.sh
        break
        ;;
    2)
        wget --no-check-certificate -qO Network-Reinstall-System-Modify.sh https://raw.githubusercontent.com/kaiyuhou/server/main/dd_os/Network-Reinstall-System-Modify.sh
        chmod a+x Network-Reinstall-System-Modify.sh
        bash Network-Reinstall-System-Modify.sh -UI_Options
        break
        ;;
    3)
        wget --no-check-certificate -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/script/a_set_hostname_utf8.sh > a_set_hostname_utf8_bbr.sh
        read -p "Hostname: " hostname
        bash ${DIR}/a_set_hostname_utf8_bbr.sh ${hostname}
        break
        ;;
    4)
        wget --no-check-certificate -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/script/b_adduser_mike_ubuntu.sh > b_adduser_mike_ubuntu.sh
        bash ${DIR}/b_adduser_mike_ubuntu.sh
        break
        ;;
    5)
        wget --no-check-certificate -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/script/c_set_sshd.sh > c_set_sshd.sh
        bash ${DIR}/c_set_sshd.sh
        break
        ;;
    6)
        wget --no-check-certificate -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/script/d_set_ufw_ubuntu.sh > d_set_ufw_ubuntu.sh
        bash ${DIR}/d_set_ufw_ubuntu.sh
        break
        ;;
    456)
        wget --no-check-certificate -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/script/b_adduser_mike_ubuntu.sh > b_adduser_mike_ubuntu.sh
        bash ${DIR}/b_adduser_mike_ubuntu.sh
        wget --no-check-certificate -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/script/c_set_sshd.sh > c_set_sshd.sh
        bash ${DIR}/c_set_sshd.sh
        wget --no-check-certificate -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/script/d_set_ufw_ubuntu.sh > d_set_ufw_ubuntu.sh
        bash ${DIR}/d_set_ufw_ubuntu.sh
        break
        ;;

    7)
        wget --no-check-certificate -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/script/e_install_docker_ubuntu.sh > e_install_docker_ubuntu.sh
        bash ${DIR}/e_install_docker_ubuntu.sh
        break
        ;;

    76)
        wget --no-check-certificate -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/script/e6_enable_docker_ipv6nat.sh > e6_enable_docker_ipv6nat.sh
        bash ${DIR}/e6_enable_docker_ipv6nat.sh
        break
        ;;
    9)
        wget --no-check-certificate -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/docker_script/ubuntu-vnc/start-ubuntu-vnc.sh > start-ubuntu-vnc.sh
        read -p "Password: " password
        read -p "VNC Client Port (127.0.0.1:8003): " vncpt
        read -p "VNC Web Port (127.0.0.1：8002): " webpt
        # shellcheck disable=SC2086
        bash ${DIR}/start-ubuntu-vnc.sh "${password}" "${vncpt}" "${webpt}"
        break
        ;;
    "f")
        wget --no-check-certificate -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/script/f_install_caddy.sh > f_install_caddy.sh
        bash ${DIR}/f_install_caddy.sh
        break
        ;;
    "7f")
        wget --no-check-certificate -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/script/e_install_docker_ubuntu.sh > e_install_docker_ubuntu.sh
        bash ${DIR}/e_install_docker_ubuntu.sh
        wget --no-check-certificate -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/script/f_install_caddy.sh > f_install_caddy.sh
        bash ${DIR}/f_install_caddy.sh
        break
        ;;
    "g")
        wget --no-check-certificate -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/script/g_enable_bbr.sh > g_enable_bbr.sh
        bash ${DIR}/g_enable_bbr.sh
        break
        ;;
    "s")
        bash <(wget --no-check-certificate -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/docker_script/speedtest-x/speedtest_x.sh)
        break
        ;;
    "h")
        wget --no-check-certificate -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/script/h_add_caddy_record.sh > h_add_caddy_record.sh
        bash ${DIR}/h_add_caddy_record.sh
        break
        ;;
    "s3")
        bash <(wget --no-check-certificate -qO- http://yun.789888.xyz/speedtest.sh)
        break
        ;;

    *)
        clear
        out0 p "Please Reselect\n"
esac
done
rm -rf ${DIR}