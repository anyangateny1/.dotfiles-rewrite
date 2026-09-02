#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

ZSH_DIR="$DOTFILES_DIR/terminal/zsh"

log() { printf '[*] %s\n' "$*"; }

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
    else
        die "No supported package manager found (brew / pacman / apt-get / dnf)"
    fi
}

install_omz() {
    [[ -d "$HOME/.oh-my-zsh" ]] && {
        log "oh-my-zsh already present"
        return
    }
    log "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
        "" --unattended --keep-zshrc
}

install_p10k() {
    local dest="$HOME/.local/share/powerlevel10k"
    [[ -d "$dest" ]] && {
        log "powerlevel10k already present"
        return
    }
    log "Cloning powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k "$dest"
}

clone_plugin() {
    local name="$1" url="$2"
    local dest="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$name"
    [[ -d "$dest" ]] && {
        log "$name already present"
        return
    }
    log "Cloning $name..."
    git clone --depth=1 "$url" "$dest"
}

setup_brew() {
    log "Installing packages via Homebrew..."
    brew install zsh curl git fzf zsh-autosuggestions zsh-syntax-highlighting \
        zsh-history-substring-search powerlevel10k
    install_omz
    local prefix
    prefix="$(brew --prefix)"
    cat >"$HOME/.oh-my-zsh.rc" <<EOF
POWERLEVEL10K_THEME=$prefix/share/powerlevel10k/powerlevel10k.zsh-theme
FZF_BASE=$prefix/opt/fzf
DOTFILES_ZSH_EXTRA_SOURCES=(
  $prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  $prefix/share/zsh-history-substring-search/zsh-history-substring-search.zsh
  $prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
)
EOF
}

setup_pacman() {
    log "Arch: ensure the following are installed (e.g. via paru/yay):"
    log "  oh-my-zsh zsh-autosuggestions zsh-syntax-highlighting"
    log "  zsh-history-substring-search zsh-theme-powerlevel10k fzf pkgfile"
    cat >"$HOME/.oh-my-zsh.rc" <<'EOF'
ZSH=/usr/share/oh-my-zsh
FZF_BASE=/usr/share/fzf
POWERLEVEL10K_THEME=/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
DOTFILES_ZSH_EXTRA_SOURCES=(
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
)
EOF
}

setup_apt() {
    log "Installing packages..."
    sudo apt-get update -qq
    sudo apt-get install -y zsh curl git fzf zsh-autosuggestions zsh-syntax-highlighting
    install_omz
    install_p10k
    clone_plugin zsh-history-substring-search \
        https://github.com/zsh-users/zsh-history-substring-search
    cat >"$HOME/.oh-my-zsh.rc" <<EOF
POWERLEVEL10K_THEME=$HOME/.local/share/powerlevel10k/powerlevel10k.zsh-theme
DOTFILES_ZSH_EXTRA_SOURCES=(
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  "\${ZSH_CUSTOM:-\$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
)
EOF
}

setup_dnf() {
    log "Installing packages..."
    sudo dnf install -y zsh curl git fzf zsh-autosuggestions zsh-syntax-highlighting
    install_omz
    install_p10k
    clone_plugin zsh-history-substring-search \
        https://github.com/zsh-users/zsh-history-substring-search
    cat >"$HOME/.oh-my-zsh.rc" <<EOF
POWERLEVEL10K_THEME=$HOME/.local/share/powerlevel10k/powerlevel10k.zsh-theme
DOTFILES_ZSH_EXTRA_SOURCES=(
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  "\${ZSH_CUSTOM:-\$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
)
EOF
}

link_configs() {
    ln -sf "$ZSH_DIR/.zshrc" "$HOME/.zshrc"
    ln -sf "$ZSH_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
    log "Symlinked .zshrc and .p10k.zsh"
}

main() {
    local pm
    pm="$(detect_pm)"
    log "Detected: $pm"
    case "$pm" in
    brew) setup_brew ;;
    pacman) setup_pacman ;;
    apt) setup_apt ;;
    dnf) setup_dnf ;;
    esac
    link_configs
    log "Done — restart your shell or run: exec zsh"
}
main "$@"
