# ~/.zshrc — interactive shells only.
[[ -o interactive ]] || return

bindkey -e

# ── history ─────────────────────────────────────────────────
export HISTFILE="${HISTFILE:-$HOME/.zsh_history}"
export HISTSIZE=100000 SAVEHIST=100000
setopt inc_append_history share_history hist_ignore_dups

# ── completion ──────────────────────────────────────────────
autoload -Uz compinit && compinit -C
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload bashcompinit 2>/dev/null && bashcompinit 2>/dev/null

setopt prompt_subst
autoload -U colors && colors

# ── optional secrets (not in git) ───────────────────────────
[[ -r ~/.keys/export_keys.sh ]] && source ~/.keys/export_keys.sh

# ── brew-based zsh plugins (brew on PATH from ~/.zsh/local.zshenv) ──
_brew_prefix=
if command -v brew >/dev/null 2>&1; then
  _brew_prefix="$(brew --prefix)"
  [[ -r "$_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] &&
    source "$_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

command -v oh-my-posh >/dev/null 2>&1 && eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/zen.toml)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

if [[ -n "$_brew_prefix" && -r "$_brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$_brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
unset _brew_prefix

(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=blue
ZSH_HIGHLIGHT_STYLES[precommand]=fg=blue
ZSH_HIGHLIGHT_STYLES[arg0]=fg=blue

# ── aliases ─────────────────────────────────────────────────
alias c='clear' e='exit'
alias ls='eza' la='eza -l --icons --git -a' lsa='eza -l --icons --git -a --total-size'
alias tree='eza --tree --level=2 --icons --git'
alias cd='z'
alias venv='source .venv/bin/activate'
alias grep='rg' vi='nvim' '??'='aichat -e'
alias imsee='kitty +kitten icat'

alias gc='git commit -m' gca='git commit -a -m' gp='git push' gpu='git pull origin'
alias gst='git status'
alias glog="git log --graph --pretty=format:'%C(yellow)%h%Creset -%C(red)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias gdiff='git diff' gco='git checkout' gb='git branch' gba='git branch -a'
alias gadd='git add' ga='git add -p' gcoall='git checkout -- .' gr='git remote' gre='git reset'

alias dco='docker compose' dps='docker ps' dpa='docker ps -a' dl='docker ps -l -q' dx='docker exec -it'
alias httpserv='python -m http.server 8000'

alias ..='cd ..' ...='cd ../..' ....='cd ../../..' .....='cd ../../../..' ......='cd ../../../../..'
alias doc="$HOME/Documents" dow="$HOME/Downloads"

# ── host / machine overrides ────────────────────────────────
[[ -r ~/.zsh/local.zshrc ]] && source ~/.zsh/local.zshrc
