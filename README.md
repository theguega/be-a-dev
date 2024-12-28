# Dotfiles

This repository contain an installation script to download sotfware and dotfiles for my personal development environment.

![Neofetch](img/maci5.png)

## Essential Tools

- **Editor**: [Zed](https://zed.dev/) Zed is a next-generation code editor designed for high-performance collaboration with humans and AI.
- **Terminal**: [Ghostty](https://ghostty.org/) 👻 Ghostty is a fast, feature-rich, and cross-platform terminal emulator that uses platform-native UI and GPU
- **Shell Prompt**: [Oh My Posh](https://ohmyposh.dev/), a prompt theme engine for any shell written in Go
- **Shell**: [Zsh](https://www.zsh.org/)
- **Nvim**: [Nvim](https://neovim.io/) because I use Vim btw (sometimes)


## Setup

### MacOS

1. Install Apple's Command Line Tools, which are prerequisites for Git and Homebrew.

```zsh
xcode-select --install

```

2. Clone repo into your Home directory.

```zsh
# Use SSH (if set up)...
git clone git@github.com:theguega/be-a-dev.git ~/

# ...or use HTTPS and switch remotes later.
git clone https://github.com/theguega/be-a-dev.git ~/
```

3. Run installation script.

```zsh
cd ~/be-a-dev
./install.sh
```

4. Restart your computer.

5. Enjoy!


## Adding New Dotfiles and Software

### Dotfiles

Dotfiles are managed using GNU Stow, which is a symbolic link manager that allows you to create symlinks to files and directories. To add a new dotfile, simply create a new file in the `dotfiles` directory and run the `stow` command to create the symlink.

### Sotfware

Software is managed using Homebrew, which is a package manager for macOS.
To add a new package to the list, you can edit the `homebrew/Brewfile`.

On Ubuntu, i have used Ansible to manage software installations to be able to be idempotent.

## Inspiration

https://github.com/hendrikmi/dotfiles/tree/main
