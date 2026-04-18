#!/bin/bash
# Shared logging for dotfiles installer

if [[ "${TERM:-}" == dumb ]] || [[ "${TERM:-}" == unknown ]] || ! tput sgr0 >/dev/null 2>&1; then
    default_color=""
    red=""
    yellow=""
    green=""
    blue=""
else
    default_color=$(tput sgr0)
    red="$(tput setaf 1)"
    yellow="$(tput setaf 3)"
    green="$(tput setaf 2)"
    blue="$(tput setaf 4)"
fi

info() {
    printf "%s==> %s%s\n" "$blue" "$1" "$default_color"
}

success() {
    printf "%s==> %s%s\n" "$green" "$1" "$default_color"
}

error() {
    printf "%s==> %s%s\n" "$red" "$1" "$default_color"
    exit 1
}

warning() {
    printf "%s==> %s%s\n" "$yellow" "$1" "$default_color"
}

run_with_progress() {
    local message="$1"
    local fn="$2"
    info "$message..."
    if "$fn"; then
        success "$message completed"
    else
        error "$message failed"
    fi
}
