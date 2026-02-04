export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"
export CMAKE_PREFIX_PATH="/usr/local/opt/llvm"
export PATH="/usr/local/bin:$PATH"
export DEFAULT_USER="$(whoami)"
export EDITOR=/usr/local/bin/nvim
export VISUAL=/usr/local/bin/nvim

ARCH=$(uname -m)
OS=$(uname -s)

if [ "$ARCH" = "arm64" ]; then
    # Apple Silicon (ARM)
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ "$OS" = "Linux" ]; then
    # Linux
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    # Intel (x86) or other
    eval "$(/usr/local/bin/brew shellenv)"
fi

setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
autoload -U colors && colors

# others
source ~/.keys/export_keys.sh

# tools
source $HOME/.local/bin/env
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/zen.toml)"
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
eval "$(zoxide init zsh)"
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
export ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=blue
export ZSH_HIGHLIGHT_STYLES[precommand]=fg=blue
export ZSH_HIGHLIGHT_STYLES[arg0]=fg=blue

# alias
alias c='clear'
alias e='exit'
alias ls="eza"
alias la="eza -l --icons --git -a"
alias lsa="eza -l --icons --git -a --total-size"
alias tree="eza --tree --level=2  --icons --git"
alias cd="z"
alias grep="rg"
alias find="fd"
alias vi="nvim"
alias vim="nvim"
alias venv="source .venv/bin/activate"
alias "??"="aichat -e"


# Git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --pretty=format:'%C(yellow)%h%Creset -%C(red)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

# Docker
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias doc="$HOME/Documents"
alias dow="$HOME/Downloads"

. "$HOME/.local/bin/env"

# Added by Antigravity
export PATH="/Users/theguega/.antigravity/antigravity/bin:$PATH"

# Added by Antigravity
export PATH="/Users/theguega/.antigravity/antigravity/bin:$PATH"
export PATH="/usr/local/opt/llvm/bin:$PATH"

# bun completions
[ -s "/Users/theguega/.bun/_bun" ] && source "/Users/theguega/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
