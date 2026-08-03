#!/bin/bash
# Stow package selection and linking for the dotfiles bootstrap.

ensure_brew_on_path() {
    if command -v brew >/dev/null 2>&1; then
        return 0
    fi
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [[ -x "${HOME}/.linuxbrew/bin/brew" ]]; then
        eval "$("${HOME}/.linuxbrew/bin/brew" shellenv)"
    fi
}

dotfiles_is_desktop() {
    if is_ssh_session; then
        return 1
    fi
    case "$DOTFILES_OS" in
        darwin) return 0 ;;
        linux) linux_has_gui_session ;;
        *) return 1 ;;
    esac
}

stow_packages_for_context() {
    local packages=(zsh nvim git ohmyposh bat lazygit yazi)

    if dotfiles_is_desktop; then
        packages+=(ghostty zed)
        if [[ "$DOTFILES_OS" == darwin ]]; then
            packages+=(aerospace)
        fi
    fi

    printf '%s\n' "${packages[@]}"
}

run_dotfiles_stow() {
    local root="${1:-${DOTFILES_ROOT:?DOTFILES_ROOT is not set}}"
    local -a packages
    local pkg

    detect_platform
    ensure_brew_on_path

    if ! command -v stow >/dev/null 2>&1; then
        error "stow not found on PATH after setup (is brew installed and on PATH?)"
    fi

    while IFS= read -r pkg; do
        [[ -n "$pkg" ]] && packages+=("$pkg")
    done < <(stow_packages_for_context)

    info "Stowing packages: ${packages[*]}"
    if ! (
        cd "$root" || exit 1
        stow -v "${packages[@]}"
    ); then
        error "stow failed — resolve conflicts in \$HOME, then re-run stow from $root"
    fi
    success "Stow completed"
}
