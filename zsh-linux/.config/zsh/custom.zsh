# Oh My Posh
export PATH=$PATH:$HOME/.local/bin
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/zen.toml)"

# Load Git completion
zstyle ':completion:*:*:git:*' script $HOME/.config/zsh/git-completion.bash
fpath=($HOME/.config/zsh $fpath)
autoload -Uz compinit && compinit

# Disable underline
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
# Change colors
export ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=blue
export ZSH_HIGHLIGHT_STYLES[precommand]=fg=blue
export ZSH_HIGHLIGHT_STYLES[arg0]=fg=blue
