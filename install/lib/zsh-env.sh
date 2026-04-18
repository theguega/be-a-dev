#!/bin/bash
# ~/.zsh/local.zshenv — created/updated by the installer (user still edits freely).

ensure_zsh_local_zshenv() {
    mkdir -p "${HOME}/.zsh"
    local f="${HOME}/.zsh/local.zshenv"
    if [[ ! -f "$f" ]]; then
        {
            echo '# Host-specific environment (PATH, Homebrew shellenv, toolchains).'
            echo '# Loaded by ~/.zshenv from your dotfiles.'
        } >"$f"
        info "Created ~/.zsh/local.zshenv — use this file for machine-specific PATH and exports."
    fi
}

append_brew_shellenv_to_local_zshenv_linux() {
    ensure_zsh_local_zshenv
    local f="${HOME}/.zsh/local.zshenv"
    [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]] || return 0
    if grep -qF "linuxbrew" "$f" 2>/dev/null; then
        return 0
    fi
    # shellcheck disable=SC2016
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>"$f"
    info "Added Linuxbrew to ~/.zsh/local.zshenv (new shells will have brew on PATH)."
}

append_brew_shellenv_to_local_zshenv_macos() {
    ensure_zsh_local_zshenv
    local f="${HOME}/.zsh/local.zshenv"
    local line
    if [[ -x /opt/homebrew/bin/brew ]]; then
        # shellcheck disable=SC2016
        line='eval "$(/opt/homebrew/bin/brew shellenv)"'
    elif [[ -x /usr/local/bin/brew ]]; then
        # shellcheck disable=SC2016
        line='eval "$(/usr/local/bin/brew shellenv)"'
    else
        return 0
    fi
    if grep -qF "brew shellenv" "$f" 2>/dev/null; then
        return 0
    fi
    echo "$line" >>"$f"
    info "Added Homebrew to ~/.zsh/local.zshenv (new shells will have brew on PATH)."
}
