#!/usr/bin/env bash
set -euo pipefail

NVIM_CONFIG_DIR="$HOME/.config/nvim"
NVIM_INSTALL_DIR="/opt/nvim"
PATH_LINE="export PATH=\"\$PATH:${NVIM_INSTALL_DIR}/bin\""

log() { printf '[nvim] %s\n' "$*"; }

if [[ -L "$NVIM_CONFIG_DIR" ]]; then
    rm -- "$NVIM_CONFIG_DIR"
    log "removed $NVIM_CONFIG_DIR symlink"
elif [[ -e "$NVIM_CONFIG_DIR" ]]; then
    log "$NVIM_CONFIG_DIR exists but is not a symlink — leaving it alone"
else
    log "$NVIM_CONFIG_DIR not found, nothing to remove"
fi

for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
    [[ -f "$rc" ]] || continue
    if grep -qxF "$PATH_LINE" "$rc"; then
        grep -vxF "$PATH_LINE" "$rc" >"${rc}.tmp" && mv "${rc}.tmp" "$rc"
        log "removed PATH entry from $rc"
    fi
done

log "done — neovim binary left at $NVIM_INSTALL_DIR"
