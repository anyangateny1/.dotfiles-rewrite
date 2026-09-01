#!/usr/bin/env bash
set -euo pipefail

readonly NVIM_VERSION="0.12.5"
readonly NVIM_INSTALL_DIR="/opt/nvim"
readonly NVIM_CONFIG_DIR="${HOME}/.config/nvim"
readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

log() {
    printf '[nvim] %s\n' "$*"
}

die() {
    printf '[nvim] [!!] %s\n' "$*" >&2
    exit 1
}

detect_os() {
    case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux) echo "linux" ;;
    *) die "Unsupported OS: $(uname -s)" ;;
    esac
}

detect_arch() {
    case "$(uname -m)" in
    aarch64 | arm64) echo "arm64" ;;
    x86_64) echo "x86_64" ;;
    *) die "Unsupported architecture: $(uname -m)" ;;
    esac
}

detect_pkg_mgr() {
    local os="$1"

    if [[ "$os" == "macos" ]]; then
        command -v brew >/dev/null 2>&1 ||
            die "Homebrew not found."
        echo "brew"
        return
    fi

    if command -v apt-get >/dev/null 2>&1; then
        echo "apt"
    elif command -v dnf >/dev/null 2>&1; then
        echo "dnf"
    elif command -v pacman >/dev/null 2>&1; then
        echo "pacman"
    else
        die "No supported package manager found."
    fi
}

declare -gA BREW_PKGS=(
    ["tar"]="gnu-tar"
    ["make"]="make"
    ["gcc"]="gcc"
    ["rg"]="ripgrep"
    ["lua5.4"]="lua@5.4"
    ["unzip"]="unzip"
    ["clang"]="llvm"
    ["node"]="node"
)

declare -gA APT_PKGS=(
    ["curl"]="curl"
    ["tar"]="tar"
    ["make"]="make"
    ["gcc"]="gcc"
    ["rg"]="ripgrep"
    ["lua5.4"]="lua5.4"
    ["liblua5.4-dev"]="liblua5.4-dev"
    ["unzip"]="unzip"
    ["clang"]="clang"
    ["wl-copy"]="wl-clipboard"
    ["node"]="nodejs"
    ["npm"]="npm"
)

declare -gA DNF_PKGS=(
    ["curl"]="curl"
    ["tar"]="tar"
    ["make"]="make"
    ["gcc"]="gcc"
    ["rg"]="ripgrep"
    ["lua5.4"]="lua"
    ["unzip"]="unzip"
    ["clang"]="clang"
    ["wl-copy"]="wl-clipboard"
    ["node"]="nodejs"
)

declare -gA PACMAN_PKGS=(
    ["curl"]="curl"
    ["tar"]="tar"
    ["make"]="make"
    ["gcc"]="gcc"
    ["rg"]="ripgrep"
    ["lua5.4"]="lua"
    ["unzip"]="unzip"
    ["clang"]="clang"
    ["wl-copy"]="wl-clipboard"
    ["node"]="nodejs"
    ["npm"]="npm"
)

install_dependencies() {
    local pkg_mgr="$1"
    local -n pkg_map="${pkg_mgr^^}_PKGS"
    local missing=()
    local cmd

    for cmd in "${!pkg_map[@]}"; do
        command -v "$cmd" >/dev/null 2>&1 || missing+=("${pkg_map[$cmd]}")
    done

    if ((${#missing[@]} == 0)); then
        log "All system dependencies already installed."
        return
    fi

    log "Installing system dependencies via ${pkg_mgr}: ${missing[*]}"

    case "$pkg_mgr" in
    brew)
        brew install "${missing[@]}"
        ;;
    apt)
        sudo apt-get update
        sudo apt-get install -y "${missing[@]}"
        ;;
    dnf)
        sudo dnf install -y "${missing[@]}"
        ;;
    pacman)
        sudo pacman -Sy --needed --noconfirm "${missing[@]}"
        ;;
    esac
}

install_neovim() {
    local os="$1"
    local arch="$2"
    local tmp_dir archive_path extracted_dir nvim_platform nvim_archive nvim_url

    if [[ -x "${NVIM_INSTALL_DIR}/bin/nvim" ]]; then
        if [[ "$("${NVIM_INSTALL_DIR}/bin/nvim" --version | head -n1)" == "NVIM v${NVIM_VERSION}" ]]; then
            log "Neovim ${NVIM_VERSION} already installed."
            return
        fi
    fi

    [[ "$os" == "macos" ]] && nvim_platform="macos" || nvim_platform="linux"
    nvim_archive="nvim-${nvim_platform}-${arch}.tar.gz"
    nvim_url="https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/${nvim_archive}"

    tmp_dir="$(mktemp -d)"
    trap 'rm -rf -- "$tmp_dir"; trap - RETURN' RETURN

    archive_path="${tmp_dir}/${nvim_archive}"
    extracted_dir="${tmp_dir}/${nvim_archive%.tar.gz}"

    log "Downloading Neovim ${NVIM_VERSION}..."

    curl \
        --fail \
        --location \
        --show-error \
        --output "$archive_path" \
        "$nvim_url"

    if [[ "$os" == "macos" ]]; then
        xattr -c "$archive_path"
    fi

    log "Installing Neovim ${NVIM_VERSION} to ${NVIM_INSTALL_DIR}..."

    tar -xzf "$archive_path" -C "$tmp_dir"

    sudo mkdir -p -- "$(dirname -- "$NVIM_INSTALL_DIR")"
    sudo rm -rf -- "$NVIM_INSTALL_DIR"
    sudo mv -- "$extracted_dir" "$NVIM_INSTALL_DIR"
}

configure_path() {
    local shell_rc
    local path_line="export PATH=\"\$PATH:${NVIM_INSTALL_DIR}/bin\""

    # Make nvim available to this script immediately.
    export PATH="${NVIM_INSTALL_DIR}/bin:${PATH}"

    case "${SHELL##*/}" in
    bash) shell_rc="$HOME/.bashrc" ;;
    zsh) shell_rc="$HOME/.zshrc" ;;
    *)
        log "Unrecognized shell '${SHELL##*/}'"
        return
        ;;
    esac

    touch "$shell_rc"

    if ! grep -qxF "$path_line" "$shell_rc"; then
        printf '\n%s\n' "$path_line" >>"$shell_rc"
        log "Added Neovim to PATH in ${shell_rc}."
    else
        log "Neovim PATH already configured."
    fi
}

link_config() {
    local backup

    if [[ -L "$NVIM_CONFIG_DIR" ]]; then
        if [[ "$(readlink -f "$NVIM_CONFIG_DIR")" == "$(readlink -f "$SCRIPT_DIR")" ]]; then
            log "Neovim config already linked."
            return
        fi

        log "Removing existing Neovim symlink."
        rm -- "$NVIM_CONFIG_DIR"

    elif [[ -e "$NVIM_CONFIG_DIR" ]]; then
        backup="${NVIM_CONFIG_DIR}.bak.$(date +%Y%m%d%H%M%S)"

        log "Existing Neovim config found."
        log "Backing it up to ${backup}."

        mv -- "$NVIM_CONFIG_DIR" "$backup"
    fi

    mkdir -p -- "$(dirname -- "$NVIM_CONFIG_DIR")"
    ln -s -- "$SCRIPT_DIR" "$NVIM_CONFIG_DIR"

    log "Linked ${SCRIPT_DIR} -> ${NVIM_CONFIG_DIR}"
}

install_rust() {
    # if command -v cargo >/dev/null 2>&1; then
    #     log "Rust/cargo already installed."
    #     return
    # fi

    log "Installing Rust via rustup..."

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs |
        sh -s -- -y

    # shellcheck disable=SC1091
    source "$HOME/.cargo/env"

    log "Rust installed."
}

install_tree_sitter() {
    if command -v tree-sitter >/dev/null 2>&1; then
        log "tree-sitter already installed."
        return
    fi

    command -v cargo >/dev/null 2>&1 ||
        die "cargo not found. Rust must be installed before tree-sitter."

    log "Installing tree-sitter CLI via cargo..."

    cargo install tree-sitter-cli

    log "tree-sitter installed."
}

install_luarocks() {
    local os="$1"
    local pkg_mgr="$2"

    if [[ "$os" == "macos" ]]; then
        if command -v luarocks >/dev/null 2>&1; then
            log "LuaRocks already installed."
        else
            log "Installing LuaRocks via brew..."
            brew install luarocks
        fi

        if luarocks list --porcelain | grep -q '^luasocket '; then
            log "LuaSocket already installed."
        else
            log "Installing LuaSocket..."
            luarocks install luasocket
        fi
        return
    fi

    if [[ "$pkg_mgr" == "dnf" ]]; then
        if command -v luarocks >/dev/null 2>&1; then
            log "LuaRocks already installed."
        else
            log "Installing LuaRocks via dnf..."
            sudo dnf install -y luarocks
        fi

        if luarocks list --porcelain | grep -q '^luasocket '; then
            log "LuaSocket already installed."
        else
            log "Installing LuaSocket..."
            if ! sudo dnf install -y lua-luasocket 2>/dev/null; then
                sudo luarocks install luasocket
            fi
        fi
        return
    fi

    if [[ "$pkg_mgr" == "pacman" ]]; then
        if command -v luarocks >/dev/null 2>&1; then
            log "LuaRocks already installed."
        else
            log "Installing LuaRocks via pacman..."
            sudo pacman -S --needed --noconfirm luarocks
        fi

        if luarocks list --porcelain | grep -q '^luasocket '; then
            log "LuaSocket already installed."
        else
            log "Installing LuaSocket..."
            if ! sudo pacman -S --needed --noconfirm lua-socket 2>/dev/null; then
                sudo luarocks install luasocket
            fi
        fi
        return
    fi

    local luarocks_version="3.13.0"
    local tmp_dir archive source_dir

    if command -v luarocks >/dev/null 2>&1; then
        log "LuaRocks already installed."
    else
        tmp_dir="$(mktemp -d)"
        trap 'rm -rf -- "$tmp_dir"; trap - RETURN' RETURN

        archive="luarocks-${luarocks_version}.tar.gz"
        source_dir="${tmp_dir}/luarocks-${luarocks_version}"

        log "Downloading LuaRocks ${luarocks_version}..."

        curl \
            --fail \
            --location \
            --show-error \
            --output "${tmp_dir}/${archive}" \
            "https://luarocks.org/releases/${archive}"

        log "Building LuaRocks..."

        tar -xzf "${tmp_dir}/${archive}" -C "$tmp_dir"

        (
            cd "$source_dir"

            ./configure
            make
            sudo make install
        )

        log "LuaRocks installed."
    fi

    if luarocks list --porcelain | grep -q '^luasocket '; then
        log "LuaSocket already installed."
    else
        log "Installing LuaSocket..."
        sudo luarocks install luasocket
    fi
}

main() {
    local OS ARCH PKG_MGR

    OS="$(detect_os)"
    ARCH="$(detect_arch)"
    PKG_MGR="$(detect_pkg_mgr "$OS")"

    log "Detected package manager: ${PKG_MGR}"

    install_dependencies "$PKG_MGR"

    install_neovim "$OS" "$ARCH"
    configure_path
    link_config

    install_rust
    install_tree_sitter
    install_luarocks "$OS" "$PKG_MGR"

    log "Neovim setup complete."
}

main "$@"
