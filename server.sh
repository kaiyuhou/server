#!/bin/bash
#source: server.sh
#create: 2021-01-17
#usage: bash <(wget -qO- git.io/srvsh)

clear
DIR=${HOME}/server_script
if [ ! -d $DIR ]; then
    mkdir $DIR
fi
cd $DIR

GITHUB_RAW="https://raw.githubusercontent.com/kaiyuhou/server/main"

out1 () {
    color=$1
    what=$2
    array=("r" "g" "y" "b" "p" "s" "w")
    for i in $(seq 31 37); do
        if [ ${array[$(($i-31))]} == $color ]; then
            echo -ne "\e[1;${i}m${what}\e[0m"
            break
        fi
    done
}
out0 () {
    color=$1
    what=$2
    array=("r" "g" "y" "b" "p" "s" "w")
    for i in $(seq 31 37); do
        if [ ${array[$(($i-31))]} == $color ]; then
            echo -ne "\e[0;${i}m${what}\e[0m"
            break
        fi
    done
}

out0 s "bash <(wget --no-check-certificate -qO- git.io/srvsh)\n"
while [ 1 -eq 1 ]; do
out0 y "Select a number: \n"
out1 y "------------------------------------------ \n"
out1 b " 0. init setup           - Full Init Setup\n"
out1 b " 1. bench.sh             - Basic Performance and Network Test\n"
out1 b " 2. dd.sh               - DD Reinstall OS\n"
out1 b " 3. install_caddy.sh     - Install Caddy\n"
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
        wget --no-check-certificate -qO- ${GITHUB_RAW}/script/init.sh > init.sh
        bash ${DIR}/init.sh
        rm -rf ${DIR}
        out0 p "Clear Done\n"
        break
        ;;
    1)
        wget --no-check-certificate -qO- ${GITHUB_RAW}/script/bench.sh > bench.sh
        bash ${DIR}/bench.sh
        break
        ;;
    2)
        wget --no-check-certificate -qO- ${GITHUB_RAW}/script/dd.sh > dd.sh
        bash ${DIR}/dd.sh
        break
        ;;
    3)
        wget --no-check-certificate -qO- ${GITHUB_RAW}/script/install_caddy.sh > install_caddy.sh
        bash ${DIR}/install_caddy.sh
        break
        ;;
    *)
        clear
        out0 p "Please Reselect\n"
esac
done
rm -rf ${DIR}
