#!/bin/bash
# Homebrew package installation for macOS

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

install_prerequisites() {
    info "Installing Xcode Command Line Tools..."
    if ! xcode-select -p >/dev/null 2>&1; then
        xcode-select --install
        sudo xcodebuild -license accept
    else
        warning "Xcode Command Line Tools already installed"
    fi

    info "Installing Homebrew..."
    if ! command -v brew >/dev/null 2>&1; then
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Configure Homebrew path based on architecture
        if [[ $(uname -m) == "arm64" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        warning "Homebrew already installed"
    fi
}

install_applications() {
    local brewfile="$SCRIPT_DIR/../homebrew/Brewfile"

    if [[ -f "$brewfile" ]]; then
        info "Installing packages from Brewfile..."

        # Check if dependencies are already satisfied
        if brew bundle check --file="$brewfile" >/dev/null 2>&1; then
            warning "All Brewfile dependencies already satisfied"
        else
            brew bundle install --file="$brewfile"
        fi
    else
        error "Brewfile not found at $brewfile"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_prerequisites
    install_applications
fi
