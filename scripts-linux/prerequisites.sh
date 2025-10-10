#!/bin/bash
# Basic system prerequisites for Linux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

install_prerequisites() {
    info "Installing Homebrew on Linux..."

    if ! command -v brew >/dev/null 2>&1; then
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
        warning "Homebrew already installed"
    fi

    info "Updating system packages..."
    sudo apt update && sudo apt upgrade -y

    info "Installing basic build tools..."
    sudo apt install -y build-essential curl git unzip

    success "Prerequisites installed"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_prerequisites
fi
