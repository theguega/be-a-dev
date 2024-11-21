if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
export BAT_THEME="Monokai Extended Bright"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git golang python zsh-autosuggestions zsh-syntax-highlighting zsh-bat)

source $ZSH/oh-my-zsh.sh

alias ls=eza
alias vi=nvim
alias fzf='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi
