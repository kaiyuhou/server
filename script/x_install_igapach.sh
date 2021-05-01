#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
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

c3_install () {
        out0 b "Hostname:"
        read hostname
        PASS=$hostname

        apt update
        apt install cpulimit htop -y
        wget --no-check-certificate $C3_URL -qO $HOME/xmrig.tar.gz --show-progress
        mkdir $HOME/c3
        tar xf $HOME/xmrig.tar.gz -C $HOME/c3
        rm $HOME/xmrig.tar.gz
        mv $HOME/c3/xmrig $HOME/c3/igapach

        sed -i 's/"url": *"[^"]*",/"url": "mine.c3pool.com:33333",/' $HOME/c3/config.json
        sed -i 's/"user": *"[^"]*",/"user": "469RgSVfF4EWmZq7jDXfgr6GgpXG8Qw858T3dWnqBxsz6zdxxJKEr7J8ckwr2xjXHQV1szNbZqVbjKHciTEFEPssJkNwRWQ",/' $HOME/c3/config.json
        sed -i 's/"pass": *"[^"]*",/"pass": "'$PASS'",/' $HOME/c3/config.json
        sed -i 's/"tls": *false,/"tls": true,/' $HOME/c3/config.json
        sed -i 's#"log-file": *null,#"log-file": "'$HOME/c3/run.log'",#' $HOME/c3/config.json
        sed -i 's/"background": *false,/"background": true,/' $HOME/c3/config.json
}

while [ 1 -eq 1 ];do
out0 y "Select a number: \n"
out1 y "------------------------------------------ \n"
out1 b " 0. install master\n"
out1 b " 1. install 6.12\n"
out1 b " 2. install 6.11\n"
out1 b " 3. install 6.10\n"
out1 b " 4. kill\n"
out1 b " 5. start\n"
out1 b " 6. disable panthera\n"
out1 b " 7. set cpulimit\n"
out1 b " 8. remove cpulimit\n"
out1 b " 9. start with cpulimit\n"
out1 r " 99. exit   \n"
out1 y "------------------------------------------ \n"

# "https://raw.githubusercontent.com/C3Pool/xmrig_setup/master/xmrig.tar.gz"

read id
case $id in
    99)
        break
        ;;
    0)
        C3_URL="https://raw.githubusercontent.com/C3Pool/xmrig_setup/master/xmrig.tar.gz"
        c3_install
        ;;
    1)
        C3_URL="https://github.com/C3Pool/xmrig-C3/releases/download/v6.12.0-C3/xmrig-v6.12.0-C3-linux-Static.tar.gz"
        c3_install
        ;;
    2)
        C3_URL="https://github.com/C3Pool/xmrig-C3/releases/download/v6.11.0-C3/xmrig-v6.11.0-C3-linux-Static.tar.gz"
        c3_install
        ;;
    3)
        C3_URL="https://github.com/C3Pool/xmrig-C3/releases/download/v6.10.0-C2/xmrig-v6.10.0-C3-linux-Static.tar.gz"
        c3_install
        ;;
    4)
        killall xmrig
        ;;
    5)
        $HOME/c3/igapach
        ;;
    6)
        sed -i 's/"panthera": .*$/"panthera": 0.0/' $HOME/c3/config.json
        ;;
    7)
        LSCPU=`lscpu`
        CPU_THREADS=`echo "$LSCPU" | grep "^CPU(s):" | cut -d':' -f2 | sed "s/^[ \t]*//"`
        out0 b "CPULimit: 1 - ${CPU_THREADS}00:"
        read cpu_limit
        cpulimit -e igapach -l $cpu_limit -b
        ;;
    8)
        killall cpulimit
        ;;
    9)
        LSCPU=`lscpu`
        CPU_THREADS=`echo "$LSCPU" | grep "^CPU(s):" | cut -d':' -f2 | sed "s/^[ \t]*//"`
        out0 b "CPULimit: 1 - ${CPU_THREADS}00:"
        read cpu_limit
        $HOME/c3/igapach
        sleep 0.01
        cpulimit -e igapach -l $cpu_limit -b
        break
        ;;
    *)
        clear
        out0 p "Please Reselect\n"
esac

done