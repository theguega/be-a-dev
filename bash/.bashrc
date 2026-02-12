. "$HOME/.local/bin/env"

eval "$(zoxide init bash)"

# alias
alias c='clear'
alias e='exit'
alias ls="eza"
alias la="eza -l --icons --git -a"
alias lsa="eza -l --icons --git -a --total-size"
alias tree="eza --tree --level=2  --icons --git"
alias cd="z"
alias grep="rg"
alias venv="source .venv/bin/activate"

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

eval "$(oh-my-posh init bash --config ~/.config/ohmyposh/zen.toml)"
PATH="/home/theo/.cargo/bin/:$PATH"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"
export CMAKE_PREFIX_PATH="/usr/local/opt/llvm"
export PATH="/usr/local/bin:$PATH"
export DEFAULT_USER="$(whoami)"export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"
export CMAKE_PREFIX_PATH="/usr/local/opt/llvm"
export PATH="/usr/local/bin:$PATH"
export DEFAULT_USER="$(whoami)"

export EDITOR=/usr/bin/vi
export VISUAL=/usr/bin/vi

ARCH=$(uname -m)
OS=$(uname -s)
