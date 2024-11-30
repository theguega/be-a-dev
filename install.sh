#!/bin/bash

os=$(uname -s)
echo $SHELL

if [ "$os" = "Darwin" ]; then
    . scripts-macos/utils.sh
    . scripts-macos/prerequisites.sh
    . scripts-macos/brew-install-custom.sh
    . scripts-macos/osx-defaults.sh
    . scripts-macos/vscode.sh

    info "macOS profile detected"

    info "Dotfiles intallation initialized..."
    read -p "Install apps? [y/n] " install_apps
    read -p "Overwrite existing dotfiles? [y/n] " overwrite_dotfiles

    if [[ "$install_apps" == "y" ]]; then
        printf "\@n"
        info "===================="
        info "Prerequisites"
        info "===================="

        install_xcode
        install_homebrew

        printf "\n"
        info "===================="
        info "Apps"
        info "===================="

        install_custom_casks
        run_brew_bundle
    fi

    printf "\n"
    info "===================="
    info "OSX System Defaults"
    info "===================="

    apply_osx_system_defaults

    printf "\n"
    info "===================="
    info "Symbolic Links"
    info "===================="

    if [[ "$overwrite_dotfiles" == "y" ]]; then
    info "Using GNU Stow to create simlinks"
        stow alacritty wallpaper git nvim ohmyposh rectangle tmux vim vscode-macos zsh
    fi

    osascript -e "tell application \"System Events\" to set picture of every desktop to POSIX file \"~/.wallpaper/laputa_robot.jpeg\""

    success "Dotfiles set up successfully."
else
    echo "Installing Linux-specific files..."
fi

info "Please restart your computer by running 'restart' to apply the changes."
