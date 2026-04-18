#!/bin/bash
# OS / session detection for the dotfiles installer
# DOTFILES_OS / DOTFILES_ARCH are consumed by install/run.sh after sourcing.
# shellcheck disable=SC2034

detect_platform() {
    case "$(uname -s)" in
        Darwin) DOTFILES_OS=darwin ;;
        Linux) DOTFILES_OS=linux ;;
        *) error "Unsupported OS: $(uname -s)" ;;
    esac
    DOTFILES_ARCH="$(uname -m)"
}

is_ssh_session() {
    [[ -n "${SSH_CONNECTION:-}" ]] || [[ -n "${SSH_CLIENT:-}" ]]
}

linux_has_gui_session() {
    [[ -n "${DISPLAY:-}" ]] || [[ -n "${WAYLAND_DISPLAY:-}" ]]
}

gnome_available() {
    command -v gnome-session >/dev/null 2>&1 || command -v gnome-shell >/dev/null 2>&1
}
