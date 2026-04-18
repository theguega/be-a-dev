# ~/.zshenv — every zsh process (scripts, SSH, interactive). Keep small and fast.
export LANG="${LANG:-en_US.UTF-8}"
export EDITOR=nvim VISUAL=nvim

# Host-specific: Homebrew/Nix/PATH, toolchain flags, locale overrides.
[[ -r ~/.zsh/local.zshenv ]] && source ~/.zsh/local.zshenv
