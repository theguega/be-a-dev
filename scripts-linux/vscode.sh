#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. $SCRIPT_DIR/utils.sh

configure_vscode() {
    info "Installing VSCode extensions"
    code --install-extension mhutchie.git-graph
    code --install-extension "charliermarsh.ruff"
    code --install-extension "thang-nm.catppuccin-perfect-icons"
    code --install-extension "Catppuccin.catppuccin-vsc"
    code --install-extension "oderwat.indent-rainbow"
    code --install-extension "evondev.indent-rainbow-palettes"
    code --install-extension "be5invis.vscode-custom-css"
    code --install-extension "supermaven.supermaven"
    info "VSCode extensions installed successfully."

    info "Giving vscode admin priviledge for Custom CSS - JS"
    sudo chown -R $(whoami) "$(which code)"
    sudo chown -R $(whoami) /usr/share/code
}

if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    configure_vscode
fi
