# Oh My Posh
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/zen.toml)"

# Load Git completion
zstyle ':completion:*:*:git:*' script $HOME/.config/zsh/git-completion.bash
fpath=($HOME/.config/zsh $fpath)
autoload -Uz compinit && compinit

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Disable underline
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
# Change colors
export ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=blue
export ZSH_HIGHLIGHT_STYLES[precommand]=fg=blue
export ZSH_HIGHLIGHT_STYLES[arg0]=fg=blue

# Command to change wallpaper on macOS
wallpaper() {
    if [ -z "$1" ]; then
        echo "Usage: wallpaper <path_to_image>"
        return 1
    fi

    # Check if the file exists
    if [ ! -f "$1" ]; then
        echo "File does not exist: $1"
        return 1
    fi

    # Set the wallpaper using gsettings
    gsettings set org.gnome.desktop.background picture-uri "file://$1"
}

compdef '_files' wallpaper
