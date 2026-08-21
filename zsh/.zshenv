# ~/.zshenv — every zsh process (scripts, SSH, interactive). Keep small and fast.
typeset -U path fpath   # drop duplicate entries, first occurrence wins

export LANG="${LANG:-en_US.UTF-8}"
export EDITOR=nvim VISUAL=nvim

# Host-specific: Homebrew/Nix, toolchain flags, locale overrides.
[[ -r ~/.zsh/local.zshenv ]] && source ~/.zsh/local.zshenv

# User bins outrank anything the host config prepended.
path=(~/.local/bin ~/.cargo/bin $path)
