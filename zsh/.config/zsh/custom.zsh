autoload -U colors && colors
bindkey -e
PS1="%{$fg[magenta]%}%~%{$fg[red]%} %{$reset_color%}$%b "
source <(fzf --zsh)
finder() {
    open .
}
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Detect processor architecture
ARCH=$(uname -m)

if [ "$ARCH" = "arm64" ]; then
    # Apple Silicon (ARM)
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    # Intel (x86)
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Oh My Posh
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/zen.toml)"

# Load Git completion
zstyle ':completion:*:*:git:*' script $HOME/.config/zsh/git-completion.bash
fpath=($HOME/.config/zsh $fpath)
autoload -Uz compinit && compinit

# Activate syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Disable underline
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
# Change colors
export ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=blue
export ZSH_HIGHLIGHT_STYLES[precommand]=fg=blue
export ZSH_HIGHLIGHT_STYLES[arg0]=fg=blue

# Activate autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Command to change wallpaper on macOS
wallpaper() {
    if [ -z "$1" ]; then
        echo "Usage: wallpaper <path_to_image>"
        return 1
    fi
    osascript -e "tell application \"System Events\" to set picture of every desktop to POSIX file \"$1\""
}

compdef '_files' wallpaper
