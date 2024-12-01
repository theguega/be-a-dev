#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. $SCRIPT_DIR/utils.sh

software_playbook() {
    info "Installing software on a new Ubuntu system..."

    # Ensure the script is being run with sudo
    if [ "$(id -u)" -ne 0 ]; then
        error "Please run as root or with sudo."
    fi

    # Check if the playbook file exists
    if [ ! -f "$SCRIPT_DIR/software_playbook.yml" ]; then
        error "Ansible playbook file (software_playbook.yml) not found."
    fi

    # Run the Ansible playbook to install the software
    info "Running Ansible playbook to install software..."
    ansible-playbook "$SCRIPT_DIR/software_playbook.yml"

    # Check if the playbook ran successfully
    if [ $? -eq 0 ]; then
        info "Software installation completed successfully."
    else
        error "There was an error running the playbook."
    fi
}

if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    software_playbook
fi
