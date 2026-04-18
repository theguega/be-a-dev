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
