#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "$SCRIPT_DIR"/utils.sh

run_software_playbook() {
    info "Installing software on a new Ubuntu system..."

    # Check if Ansible is installed
    if ! command -v ansible-playbook &>/dev/null; then
        error "Ansible is not installed. Please install Ansible first."
        exit 1
    fi

    # Check if the playbook file exists
    PLAYBOOK_PATH="$SCRIPT_DIR/software_playbook.yml"
    if [ ! -f "$PLAYBOOK_PATH" ]; then
        error "Ansible playbook file (software_playbook.yml) not found in $SCRIPT_DIR."
        exit 1
    fi

    # Offer a dry-run (preview changes without applying)
    if [ "$1" == "--check" ]; then
        info "Running Ansible playbook in dry-run mode (no changes will be made)..."
        sudo ansible-playbook "$PLAYBOOK_PATH" --check
        if [ $? -ne 0 ]; then
            error "Dry-run of the playbook failed."
            exit 1
        fi
        info "Dry-run completed successfully."
        return
    fi

    # Run the Ansible playbook to install the software
    info "Running Ansible playbook to install software..."
    sudo ansible-playbook "$PLAYBOOK_PATH"

    # Check if the playbook ran successfully
    if [ $? -eq 0 ]; then
        info "Software installation completed successfully."
    else
        error "There was an error running the playbook. Check the logs for details."
        exit 1
    fi
}

if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    run_software_playbook
fi
