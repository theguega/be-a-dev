#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. $SCRIPT_DIR/utils.sh

install_ansible_and_git() {
    info "Installing Ansible and Git..."

    sudo apt update && sudo apt upgrade -y

    # Check if Git is already installed
    if command -v git >/dev/null; then
        warning "Git is already installed."
    else
        sudo apt install -y git
        success "Git installed successfully."
    fi

    # Check if Ansible is already installed
    if ! command -v ansible &>/dev/null; then
        info "Ansible is not installed. Installing prerequisites..."
        sudo apt update && sudo apt install -y software-properties-common

        info "Adding Ansible PPA and updating package list..."
        sudo add-apt-repository --yes ppa:ansible/ansible
        sudo apt update

        info "Installing Ansible..."
        sudo apt install -y ansible

        info "Ansible installation completed."
    else
        info "Ansible is already installed. Checking for updates..."
        sudo apt update
        sudo apt upgrade -y ansible
    fi

    # Ensure community.general collection is installed
    if ! ansible-galaxy collection list | grep -q "community.general"; then
        info "Installing community.general collection for extended functionality..."
        ansible-galaxy collection install community.general
        info "community.general collection installed."
    else
        info "community.general collection is already installed."
    fi

    info "Ansible setup is complete. You can now use Ansible for automation tasks!"
}


if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    install_ansible_and_git
fi
