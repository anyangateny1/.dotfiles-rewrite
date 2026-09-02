#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

log() { printf '[dotfiles] %s\n' "$*"; }

die() {
    printf '[!!] %s\n' "$*" >&2
    exit 1
}

detect_pm() {
    if command -v brew >/dev/null 2>&1; then
        echo brew
    elif command -v pacman >/dev/null 2>&1; then
        echo pacman
    elif command -v apt-get >/dev/null 2>&1; then
        echo apt
    elif command -v dnf >/dev/null 2>&1; then
        echo dnf
    else die "no supported package manager found"; fi
}

install_base() {
    log "installing base tools..."
    case "$1" in
    brew) brew install curl git unzip make ripgrep fd wl-clipboard git-lfs ;;
    pacman) sudo pacman -S --needed --noconfirm curl git unzip make ripgrep fd wl-clipboard git-lfs ;;
    apt)
        sudo apt-get update -qq
        sudo apt-get install -y curl git unzip make ripgrep fd-find wl-clipboard git-lfs
        ;;
    dnf) sudo dnf install -y curl git unzip make ripgrep fd-find wl-clipboard git-lfs ;;
    esac
}

run() {
    local script="$SCRIPT_DIR/$1"
    [[ -x "$script" ]] || {
        log "skipping $1"
        return
    }
    log "running $1"
    "$script"
}

main() {
    local pm
    pm="$(detect_pm)"
    log "detected: $pm"
    install_base "$pm"
    run git/install.sh
    run terminal/install.sh
    run tmux/install.sh
    run alacritty/install.sh
    run nvim/install_nvim.sh
    log "done"
}

main "$@"
