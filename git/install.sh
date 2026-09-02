#!/usr/bin/env bash
set -euo pipefail
DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

ln -sf "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
git lfs install --skip-repo
printf '[git] done\n'
