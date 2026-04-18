#!/bin/bash
# Bench test menu
# Usage: bash bench.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if docker is installed, install if not
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Docker not found. Installing..."
        source "$SCRIPT_DIR/init/install_docker.sh"
        install_docker
    fi
}

run_net_test() {
    echo "=== Network Speed Test ==="
    docker run -it --rm --entrypoint bash ubuntu -c \
        "apt update && apt install curl wget -y && curl -L https://gitlab.com/spiritysdx/za/-/raw/main/ecs.sh -o ecs.sh && chmod +x ecs.sh && bash ecs.sh -banup -m 4 1" \
        | tee nettest.log
}

run_ping_test() {
    echo "=== Ping Test ==="
    docker run -it --rm --entrypoint bash ubuntu -c \
        "apt update && apt install curl wget -y && curl -L https://gitlab.com/spiritysdx/za/-/raw/main/ecs.sh -o ecs.sh && chmod +x ecs.sh && bash ecs.sh -banup -m 6 3" \
        | tee pingtest.log
}

run_full_test() {
    echo "=== Full Test ==="
    docker run -it --rm --entrypoint bash ubuntu -c \
        "apt update && apt install curl -y && curl -L https://gitlab.com/spiritysdx/za/-/raw/main/ecs.sh -o ecs.sh && chmod +x ecs.sh && bash ecs.sh -banup"
}

run_ip_check() {
    echo "=== IP Quality Check ==="
    docker run --rm --net=host -it xykt/check -N -p
    docker rmi xykt/check > /dev/null 2>&1
}

check_docker

while true; do
    echo ""
    echo "========== Bench Test Menu =========="
    echo " 1. Network Speed Test"
    echo " 2. Ping Test"
    echo " 3. Full Test"
    echo " 4. IP Quality Check"
    echo " q. Exit"
    echo "====================================="
    read -p "Select: " choice

    case $choice in
        1) run_net_test ;;
        2) run_ping_test ;;
        3) run_full_test ;;
        4) run_ip_check ;;
        q) echo "Exit."; break ;;
        *) echo "Invalid option, please reselect." ;;
    esac
done
