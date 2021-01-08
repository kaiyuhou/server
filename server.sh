#!/bin/bash
#source: server.sh
#create: 2021-01-17
#usage: bash <(wget -O - https://raw.githubusercontent.com/kaiyuhou/server/main/server.sh)
#credit: based on sysbench

clear
DIR=${HOME}/server_script
if [ ! -d $DIR ];then
    mkdir $DIR
fi
cd $DIR

#cDIR=`pwd`
#trap "cl" 2
#cl () {
#    echo "..."
#    echo "clear..."
#    rm -f $cDIR/$0
#    echo "OK"
#    exit 0
#}

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
# id=0
# if [ ! $# -eq 0 ];then
#     id=$1
# fi
out0 s "Root: bash <bash <(wget -O - https://raw.githubusercontent.com/kaiyuhou/server/main/server.sh)\n"
out0 r "v0.1"
while [ 1 -eq 1 ];do
out0 y " Select a number: \n"
out1 y "------------------------------------------ \n"
out1 b " 1. bench.sh        - Basic Performance and Network Test\n"
out1 b " 2. dd.sh           - DD Instal New OS\n"
out1 b " 3. set_hostname.sh - Set Hostname\n"
out1 r " 0. clear & exit   \n"
out1 y "|\n"
out1 y "------------------------------------------ \n"


read id
case $id in
    0)
        break
        ;;
    1)
        wget --no-hsts -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/bench/bench.sh > bench.sh
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
        wget --no-hsts -qO- https://raw.githubusercontent.com/kaiyuhou/server/main/script/a_set_hostname.sh > a_set_hostname.sh
        read -p "Hostname: " hostname
        bash ${DIR}/a_set_hostname.sh hostname
        break
        ;;

    5)
        while [ ! -f ./test.sh ]; do
            wget -N --no-check-certificate https://raw.githubusercontent.com/91yun/91yuntest/master/test.sh
        done
        echo "91yuntest:请选择需要测试的项目序号(以空格分开)"
        echo "1.io 2.bandwidth 3.chinabw 4.download 5.traceroute 6.backtraceroute 7.allping 8.gotoping 9.benchtest"
        arr=("io," "bandwidth," "chinabw," "download," "traceroute," "backtraceroute," "allping," "gotoping," "benchtest,")
        read -r m
        st=""
        for i in $m ; do
            st=${st}${arr[$(($i-1))]}
        done
        # st=\"${st%,*}\"
        # echo $st
        # bash ${DIR}/91yuntest.sh -i "io,bandwidth,chinabw,download,traceroute,backtraceroute,allping,gotoping,benchtest"
        bash ./test.sh -i $st
        break
        ;;
    10|16)
        if [ ! -f ${DIR}/kos ]; then
            wget -q kos.f2k.pub -O ${DIR}/kos
        fi
        sh ${DIR}/kos
        break
        ;;
    12)
        if [ $release == "centos" ]; then
            yum install epel-release -y
            yum install sysbench -y
            sysbench cpu run
        else
            apt-get install sysbench
            sysbench cpu run
        fi
        break
        ;;
    20)
        rm -rf ${DIR}
        clear
        out0 p "Clear Done\n"
        break
        ;;
    *)
        clear
        out0 p "Please Reselect\n"
esac
done