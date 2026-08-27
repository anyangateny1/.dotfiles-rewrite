#!/usr/bin/env bash
set -euo pipefail

NVIM_VERSION="0.12.5"
NVIM_ARCHIVE="nvim-linux-x86_64.tar.gz"
# NVIM_ARCHIVE="nvim-macos-arm64.tar.gz"
# NVIM_ARCHIVE="nvim-linux-arm64.tar.gz"
NVIM_URL="https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/${NVIM_ARCHIVE}"

INSTALL_DIR="/opt/nvim"
NVIM_BIN_DIR="${INSTALL_DIR}/bin"

PREREQUISITE_PACKAGES=(sudo curl tar git)

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

check_prerequisites() {
    for pkg in "${PREREQUISITE_PACKAGES[@]}"; do
        require_command "$pkg"
    done
}

install_neovim() {
    local version="$1" url="$2" archive="$3" install_dir="$4"
    local tmp_dir
    tmp_dir="$(mktemp -d)"
    trap 'rm -rf "$tmp_dir"; trap - RETURN' RETURN

    echo "Downloading Neovim ${version}..."
    curl -fLO --output-dir "$tmp_dir" "$url"

    echo "Installing Neovim ${version} to ${install_dir}..."
    sudo rm -rf "$install_dir"
    sudo tar -C /opt -xzf "$tmp_dir/$archive"
    sudo mv "/opt/${NVIM_ARCHIVE%%.*}" "$install_dir"
}

configure_path() {
    local bin_dir="$1"
    local path_export="export PATH=\"\$PATH:${bin_dir}\""

    export PATH="$PATH:$bin_dir"

    local shell_rc="$HOME/.bashrc"
    [[ -f "$shell_rc" ]] || [[ -f "$HOME/.profile" ]] && shell_rc="${shell_rc:-$HOME/.profile}"
    touch "$shell_rc"

    if ! grep -qxF "$path_export" "$shell_rc"; then
        echo "$path_export" >> "$shell_rc"
        echo "Added Neovim to PATH in $shell_rc (restart your shell or 'source $shell_rc')."
    fi
}

link_config() {
    local linker="./nvim/install_nvim.sh"
    echo "Running ${linker}..."
    "$linker"
}

main() {
    check_prerequisites
    install_neovim "$NVIM_VERSION" "$NVIM_URL" "$NVIM_ARCHIVE" "$INSTALL_DIR"
    configure_path "$NVIM_BIN_DIR"
    link_config
    echo "Neovim ${NVIM_VERSION} installed successfully at ${NVIM_BIN_DIR}."
}

main "$@"
