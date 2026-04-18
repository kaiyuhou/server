#!/bin/bash
# DD reinstall OS script
# Usage: bash dd.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GITHUB_RAW="https://raw.githubusercontent.com/kaiyuhou/server/main"

download_dependencies() {
    echo "=== Downloading dependencies ==="
    mkdir -p "$SCRIPT_DIR/cert"
    wget --no-check-certificate -qO- "${GITHUB_RAW}/script/cert/unreliabley.pub" > "$SCRIPT_DIR/cert/unreliabley.pub"
}

dd_reinstall() {
    local pub_key=$(cat "$SCRIPT_DIR/cert/unreliabley.pub")

    echo "=== Downloading reinstall script ==="
    curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh || wget -O ${_##*/} $_

    echo "=== Reinstalling Ubuntu 24.04 ==="
    bash reinstall.sh ubuntu24.04 --minimal --ssh-key "$pub_key"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    download_dependencies
    dd_reinstall
fi
