#!/bin/bash
# Main installation script for cross-platform dotfiles setup

set -euo pipefail

# Color definitions and utility functions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() { echo -e "${BLUE}==>${NC} $1"; }
success() { echo -e "${GREEN}==>${NC} $1"; }
warning() { echo -e "${YELLOW}==>${NC} $1"; }
error() { echo -e "${RED}==>${NC} $1"; exit 1; }

# OS Detection
detect_os() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux) echo "linux" ;;
        *) error "Unsupported OS: $(uname -s)" ;;
    esac
}

OS=$(detect_os)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source platform-specific utilities
source_platform_scripts() {
    local platform="$1"
    source "$SCRIPT_DIR/scripts-$platform/software-install.sh"
    if [[ $platform == "macos" ]]; then
        source "$SCRIPT_DIR/osx-defaults.sh"
    fi
}

# Main installation flow with better UX
main() {
    info "Dotfiles installation initialized for $OS"
    # Interactive prompts with defaults
    read -p "Install applications? [Y/n] " -n 1 -r install_apps
    echo
    [[ $install_apps =~ ^[Nn]$ ]] && install_apps=false || install_apps=true

    read -p "Create symlinks? [Y/n] " -n 1 -r create_symlinks
    echo
    [[ $create_symlinks =~ ^[Nn]$ ]] && create_symlinks=false || create_symlinks=true

    read -p "Configure system defaults? [Y/n] " -n 1 -r configure_system
    echo
    [[ $configure_system =~ ^[Nn]$ ]] && configure_system=false || configure_system=true

    # Platform-specific installation
    case "$OS" in
        macos) install_macos ;;
        linux) install_linux ;;
    esac

    info "Please restart your computer to apply all changes."
}

install_macos() {
    source_platform_scripts "macos"

    if $install_apps; then
        run_with_progress "Installing prerequisites" install_prerequisites
        run_with_progress "Installing applications" install_applications
    fi

    if $create_symlinks; then
        stow aerospace ohmyposh vscode-macos zsh ghostty wallpaper git nvim zed
    fi

    if $configure_system; then
        run_with_progress "Applying system defaults" apply_system_defaults
    fi
}

install_linux() {
    source_platform_scripts "linux"

    if $install_apps; then
        run_with_progress "Installing prerequisites" install_prerequisites
        run_with_progress "Installing applications" install_applications
    fi

    if $create_symlinks; then
        stow ohmyposh vscode-linux zsh ghostty wallpaper git nvim zed
    fi

    if $configure_system; then
        run_with_progress "Configuring GNOME" configure_gnome
    fi

    info "Setting default shell to zsh"
    chsh -s /bin/zsh
}

run_with_progress() {
    local message="$1"
    local command="$2"
    info "$message..."
    if $command; then
        success "$message completed"
    else
        error "$message failed"
    fi
}

main "$@"
