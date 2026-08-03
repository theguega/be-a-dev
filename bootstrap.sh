#!/usr/bin/env bash
# Curl-able entrypoint: clone/update ~/.dotfiles, non-interactive setup, then stow.
#
#   curl -fsSL https://raw.githubusercontent.com/theguega/.dotfiles/main/bootstrap.sh | bash

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
REPO_URL="${DOTFILES_REPO_URL:-https://github.com/theguega/.dotfiles.git}"

log() {
    printf '==> %s\n' "$1"
}

die() {
    printf '==> %s\n' "$1" >&2
    exit 1
}

ensure_git() {
    if command -v git >/dev/null 2>&1; then
        return 0
    fi

    case "$(uname -s)" in
        Linux)
            log "Installing git via apt..."
            sudo apt-get update
            sudo apt-get install -y git
            ;;
        Darwin)
            die "git not found. Install Xcode Command Line Tools first: xcode-select --install"
            ;;
        *)
            die "Unsupported OS: $(uname -s)"
            ;;
    esac

    command -v git >/dev/null 2>&1 || die "git still not available after install"
}

clone_or_update() {
    if [[ -d "$DOTFILES_DIR/.git" ]]; then
        log "Updating $DOTFILES_DIR..."
        git -C "$DOTFILES_DIR" pull --ff-only
    elif [[ -e "$DOTFILES_DIR" ]]; then
        die "$DOTFILES_DIR exists but is not a git repo"
    else
        log "Cloning $REPO_URL → $DOTFILES_DIR..."
        git clone "$REPO_URL" "$DOTFILES_DIR"
    fi
}

main() {
    ensure_git
    clone_or_update

    export DOTFILES_ROOT="$DOTFILES_DIR"
    # shellcheck source=/dev/null
    source "$DOTFILES_ROOT/install/lib/utils.sh"
    # shellcheck source=/dev/null
    source "$DOTFILES_ROOT/install/lib/env.sh"
    # shellcheck source=/dev/null
    source "$DOTFILES_ROOT/install/lib/stow.sh"

    info "Running non-interactive setup (-a)..."
    "$DOTFILES_ROOT/setup.sh" -a

    run_dotfiles_stow "$DOTFILES_ROOT"
    success "Bootstrap complete"
}

main "$@"
