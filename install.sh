#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

declare -A REQUIRED_PACKAGES=(
    [curl]="curl"
    [git]="git"
    [wget]="wget"
    [tar]="tar"
    [unzip]="unzip"
    [make]="make"
    [clang]="clang"
    [wl - copy]="wl-clipboard"
)

log() {
    printf '[*] %s\n' "$*"
}

die() {
    printf '[!!] %s\n' "$*" >&2
    exit 1
}

install_dependencies() {
    local missing=()
    local cmd

    for cmd in "${!REQUIRED_PACKAGES[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing+=("${REQUIRED_PACKAGES[$cmd]}")
        fi
    done

    ((${#missing[@]} == 0)) && return

    command -v apt-get >/dev/null 2>&1 ||
        die "Missing packages: ${missing[*]}. No supported package manager found."

    log "Installing: ${missing[*]}"

    sudo apt-get update
    sudo apt-get install -y "${missing[@]}"
}

install_neovim() {
    log "Installing Neovim..."
    "${SCRIPT_DIR}/nvim/install_nvim.sh"
}

main() {

    install_dependencies

    install_neovim

    log "System setup complete."
}

main "$@"
