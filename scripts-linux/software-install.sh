#!/bin/bash
# Native software installation for Linux (replaces Ansible)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

install_applications() {
    # Install CLI tools via Homebrew
    info "Installing CLI tools via Homebrew..."
    brew bundle --file="$SCRIPT_DIR/../homebrew/Brewfile"

    # Install GUI applications via apt
    info "Installing GUI applications..."
    sudo apt install -y \
        vlc \
        gnome-shell-extension-manager \
        pipx

    # Install VSCode
    info "Installing VSCode..."
    if ! command -v code >/dev/null 2>&1; then
        curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft.gpg > /dev/null
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
        sudo apt update
        sudo apt install -y code
    fi

    # Install fonts
    install_fonts

    # Install development tools
    install_dev_tools

    success "Applications installed"
}

install_fonts() {
    info "Installing JetBrains Mono Nerd Font..."

    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"

    local font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip"
    local font_zip="/tmp/JetBrainsMono.zip"

    curl -fsSL "$font_url" -o "$font_zip"
    unzip -o "$font_zip" -d "$font_dir"
    rm "$font_zip"

    fc-cache -f -v
}

install_dev_tools() {
    # Install zoxide
    info "Installing zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

    # Install oh-my-posh
    info "Installing oh-my-posh..."
    curl -s https://ohmyposh.dev/install.sh | bash -s

    # Install fzf
    info "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all

    # Install Zsh plugins
    info "Installing Zsh plugins..."
    local zsh_dir="$HOME/.zsh"
    mkdir -p "$zsh_dir"

    git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_dir/zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$zsh_dir/zsh-syntax-highlighting"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_applications
fi
