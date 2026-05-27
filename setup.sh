#!/usr/bin/env bash
# Dotfiles installer — interactive by default; pass flags for non-interactive use (see --help).

set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_ROOT

# shellcheck source=install/run.sh
source "$DOTFILES_ROOT/install/run.sh"

main "$@"
