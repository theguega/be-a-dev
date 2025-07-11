setopt HIST_IGNORE_ALL_DUPS

# Aliases
[ -f "$HOME/.config/zsh/aliases.zsh" ] && source "$HOME/.config/zsh/aliases.zsh"

# Custom zsh
[ -f "$HOME/.config/zsh/custom.zsh" ] && source "$HOME/.config/zsh/custom.zsh"
export PATH="/usr/local/opt/binutils/bin:$PATH"

. "$HOME/.local/bin/env"
