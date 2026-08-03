#!/bin/bash
# Helpers for selective Homebrew Bundle installs (formulas vs casks)

brewfile_formula_names() {
    local brewfile="$1"
    grep -E '^\s*brew\s+' "$brewfile" | sed -E 's/^[[:space:]]*brew[[:space:]]+"([^"]+)".*/\1/' | tr '\n' ' '
}

brewfile_cask_names() {
    local brewfile="$1"
    grep -E '^\s*cask\s+' "$brewfile" | sed -E 's/^[[:space:]]*cask[[:space:]]+"([^"]+)".*/\1/' | tr '\n' ' '
}

# Third-party tap entries look like "owner/repo/name" (core entries have no slash).
brewfile_third_party_formula_names() {
    local brewfile="$1"
    grep -E '^\s*brew\s+"[^"]+/[^"]+"' "$brewfile" | sed -E 's/^[[:space:]]*brew[[:space:]]+"([^"]+)".*/\1/' | tr '\n' ' '
}

brewfile_third_party_cask_names() {
    local brewfile="$1"
    grep -E '^\s*cask\s+"[^"]+/[^"]+"' "$brewfile" | sed -E 's/^[[:space:]]*cask[[:space:]]+"([^"]+)".*/\1/' | tr '\n' ' '
}

# Recent Homebrew refuses to load formulae/casks from third-party taps until
# explicitly trusted (`brew trust`), which blocks `brew bundle install` in
# non-interactive setups. Pre-trust everything the Brewfile references.
brewfile_trust_third_party() {
    local brewfile="$1"
    local formulae casks
    formulae="$(brewfile_third_party_formula_names "$brewfile")"
    casks="$(brewfile_third_party_cask_names "$brewfile")"
    # shellcheck disable=SC2086
    [[ -n "$formulae" ]] && brew trust --formula $formulae
    # shellcheck disable=SC2086
    [[ -n "$casks" ]] && brew trust --cask $casks
    return 0
}
