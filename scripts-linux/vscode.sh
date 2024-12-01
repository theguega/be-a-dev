#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. $SCRIPT_DIR/utils.sh

configure_vscode() {
    info "Giving vscode admin priviledge for Custom CSS - JS"
    sudo chown -R $(whoami) "$(which code)"
    sudo chown -R $(whoami) /usr/share/code
}

if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    configure_vscode
fi
