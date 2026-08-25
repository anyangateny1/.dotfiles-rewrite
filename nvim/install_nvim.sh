#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
CONFIG_SRC="$SCRIPT_DIR"
CONFIG_DEST="${HOME}/.config/nvim"

POST_INSTALL_PACKAGES=(wl-clipboard make ripgrep)

require_command() {
    local cmd="$1"

    if command -v "$cmd" >/dev/null 2>&1; then
        return 0
    fi

    echo "'$cmd' is not installed. Installing..."

    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y "$cmd"
    else
        echo "Error: no supported package manager found. Please install '$cmd' manually." >&2
        exit 1
    fi
}

post_install() {
    for pkg in "${POST_INSTALL_PACKAGES[@]}"; do
        require_command "$pkg"
    done
    # FIX: Remove hardcode
    source $HOME/.bashrc
}

link_config() {
    local src="$1" dest="$2"

    if [[ -L "$dest" ]]; then
        if [[ "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
            echo "Config already symlinked at ${dest}."
            return 0
        fi
        rm "$dest"
    elif [[ -e "$dest" ]]; then
        local backup="${dest}.bak.$(date +%Y%m%d%H%M%S)"
        echo "Existing config found at ${dest}, backing up to ${backup}."
        mv "$dest" "$backup"
    fi

    mkdir -p "$(dirname -- "$dest")"
    ln -s "$src" "$dest"
    echo "Symlinked ${src} -> ${dest}."
}

main() {
    link_config "$CONFIG_SRC" "$CONFIG_DEST"
    post_install
}

main "$@"
