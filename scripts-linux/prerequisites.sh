#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. $SCRIPT_DIR/utils.sh

install_ansible_and_git() {
    info "Installing Ansible and Git..."

    # Check if Git is already installed
    if command -v git >/dev/null; then
        warning "Git is already installed."
    else
        sudo apt update
        sudo apt install -y git
        success "Git installed successfully."
    fi

    # Check if Ansible is already installed
    if ! command -v ansible &>/dev/null; then
        info "Ansible is not installed. Installing Ansible..."
        sudo apt update && sudo apt install -y software-properties-common
        sudo add-apt-repository --yes ppa:ansible/ansible
        sudo apt update && sudo apt install -y ansible
    else
        info "Ansible is already installed."
    fi
}


if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    install_ansible_and_git
fi
