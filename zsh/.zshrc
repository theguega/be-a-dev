source ~/.zprofile

alias ls=eza
alias vi=nvim
alias fzf='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'

eval "$(starship init zsh)"
