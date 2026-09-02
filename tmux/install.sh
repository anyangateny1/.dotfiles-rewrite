#!/usr/bin/env bash
set -euo pipefail
DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
printf '[tmux] done\n'
