# Enable Powerlevel10k instant prompt. Keep this near the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Machine-local path overrides — written by terminal/install.sh.
[[ ! -r "$HOME/.oh-my-zsh.rc" ]] || source "$HOME/.oh-my-zsh.rc"

: "${ZSH:=$HOME/.oh-my-zsh}"
: "${FZF_BASE:=/usr/share/fzf}"
: "${POWERLEVEL10K_THEME:=$HOME/.local/share/powerlevel10k/powerlevel10k.zsh-theme}"

typeset -ga DOTFILES_ZSH_EXTRA_SOURCES
if (( ${#DOTFILES_ZSH_EXTRA_SOURCES[@]} == 0 )); then
  DOTFILES_ZSH_EXTRA_SOURCES=(
    "${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
    "${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
    "${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  )
fi

export EDITOR="nvim"
export VISUAL="$EDITOR"
export FZF_BASE

HISTFILE="${HISTFILE:-$HOME/.zsh_history}"
HISTSIZE="${HISTSIZE:-10000}"
SAVEHIST="${SAVEHIST:-10000}"
setopt append_history
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt share_history

DISABLE_MAGIC_FUNCTIONS="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HISTORY_IGNORE="(&|[bf]g|c|clear|history|exit|q|pwd|* --help)"
plugins=(git fzf extract)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  print -u2 "oh-my-zsh not found at $ZSH — run terminal/install.sh"
fi

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"

for _f in "${DOTFILES_ZSH_EXTRA_SOURCES[@]}"; do
  [[ ! -r "$_f" ]] || source "$_f"
done
unset _f

[[ ! -r "$POWERLEVEL10K_THEME" ]] || source "$POWERLEVEL10K_THEME"

alias make='make -j$(nproc)'
alias ninja='ninja -j$(nproc)'

export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

[[ ! -r "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"

export PATH="$PATH:/opt/nvim/bin"
