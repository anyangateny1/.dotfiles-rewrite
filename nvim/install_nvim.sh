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

install_dependencies() {
    local os="$1"
    local missing=()
    local cmd

    if [[ "$os" == "macos" ]]; then
        command -v brew >/dev/null 2>&1 ||
            die "Homebrew not found. Install it from https://brew.sh first."

        local -A pkg_map=(
            ["tar"]="gnu-tar"
            ["make"]="make"
            ["gcc"]="gcc"
            ["rg"]="ripgrep"
            ["npm"]="node"
            ["lua5.4"]="lua@5.4"
            ["unzip"]="unzip"
            ["clang"]="llvm"
        )

        for cmd in "${!pkg_map[@]}"; do
            command -v "$cmd" >/dev/null 2>&1 || missing+=("${pkg_map[$cmd]}")
        done

        if ((${#missing[@]} == 0)); then
            log "All dependencies already installed."
            return
        fi

        log "Installing dependencies via brew: ${missing[*]}"
        brew install "${missing[@]}"
    else
        command -v apt-get >/dev/null 2>&1 ||
            die "apt-get not found. This script only supports apt-based Linux."

        local -A pkg_map=(
            ["tar"]="tar"
            ["make"]="make"
            ["gcc"]="gcc"
            ["rg"]="ripgrep"
            ["npm"]="npm"
            ["lua5.4"]="lua5.4"
            ["liblua5.4-dev"]="liblua5.4-dev"
            ["unzip"]="unzip"
            ["clang"]="clang"
            ["wl-copy"]="wl-clipboard"
        )

        for cmd in "${!pkg_map[@]}"; do
            command -v "$cmd" >/dev/null 2>&1 || missing+=("${pkg_map[$cmd]}")
        done

        if ((${#missing[@]} == 0)); then
            log "All dependencies already installed."
            return
        fi

        log "Installing dependencies via apt: ${missing[*]}"
        sudo apt-get update
        sudo apt-get install -y "${missing[@]}"
    fi
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

install_tree_sitter() {
    local os="$1"
    local arch="$2"

    if command -v tree-sitter >/dev/null 2>&1; then
        log "tree-sitter already installed."
        return
    fi

    if [[ "$os" == "macos" ]]; then
        log "Installing tree-sitter via brew..."
        brew install tree-sitter
        return
    fi

    local ts_version="0.25.3"
    local ts_arch="$arch"
    local tmp_dir archive binary_url

    [[ "$ts_arch" == "arm64" ]] && ts_arch="arm"

    archive="tree-sitter-linux-${ts_arch}.gz"
    binary_url="https://github.com/tree-sitter/tree-sitter/releases/download/v${ts_version}/${archive}"

    tmp_dir="$(mktemp -d)"
    trap 'rm -rf -- "$tmp_dir"; trap - RETURN' RETURN

    log "Downloading tree-sitter CLI v${ts_version}..."

    curl \
        --fail \
        --location \
        --show-error \
        --output "${tmp_dir}/${archive}" \
        "$binary_url"

    log "Installing tree-sitter CLI to /usr/local/bin..."

    gzip -d "${tmp_dir}/${archive}"
    chmod +x "${tmp_dir}/tree-sitter-linux-${ts_arch}"
    sudo mv -- "${tmp_dir}/tree-sitter-linux-${ts_arch}" /usr/local/bin/tree-sitter

    log "tree-sitter installed."
}

install_luarocks() {
    local os="$1"

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
    local OS ARCH

    OS="$(detect_os)"
    ARCH="$(detect_arch)"

    install_dependencies "$OS"

    install_neovim "$OS" "$ARCH"
    configure_path
    link_config

    install_tree_sitter "$OS" "$ARCH"
    install_luarocks "$OS"

    log "Neovim setup complete."
}

main "$@"
