# Dotfiles

This repository contains an installation script to download software and dotfiles for my personal development environment.

![Neofetch](img/maci5.png)

## Essential Tools

- **Editor**: [Zed](https://zed.dev/) Zed is a next-generation code editor designed for high-performance collaboration with humans and AI.
- **Terminal**: [Ghostty](https://ghostty.org/) 👻 Ghostty is a fast, feature-rich, and cross-platform terminal emulator that uses platform-native UI and GPU
- **Shell Prompt**: [Oh My Posh](https://ohmyposh.dev/), a prompt theme engine for any shell written in Go
- **Shell**: [Zsh](https://www.zsh.org/)
- **Nvim**: [Nvim](https://neovim.io/) because I use Vim btw (sometimes)

## Setup

### Prerequisites

#### macOS
Install Apple's Command Line Tools (prerequisites for Git and Homebrew):
```zsh
xcode-select --install
```

#### Linux (Ubuntu/Debian)
No special prerequisites needed - the script handles everything.

### Installation

1. Clone repo into your Home directory.

```zsh
# Use SSH (if set up)...
git clone git@github.com:theguega/be-a-dev.git ~/

# ...or use HTTPS and switch remotes later.
git clone https://github.com/theguega/be-a-dev.git ~/
```

2. Run the installation script.

```zsh
cd ~/be-a-dev
./install.sh
```

The script will:
- Detect your operating system (macOS/Linux)
- Ask what you want to install/configure:
  - **Applications**: CLI tools via Homebrew, GUI apps via platform-specific package managers
  - **System defaults**: macOS system preferences or GNOME extensions/hotkeys
  - **Symlinks**: Create symbolic links for dotfiles (with backup of existing files)
- Install everything automatically
- Set up your development environment

3. Restart your computer to apply all changes.

4. Enjoy your new development environment!

## What's Installed

### Cross-Platform (via Homebrew)
- **CLI Tools**: fzf, fd, ripgrep, eza, zoxide, neovim, tmux, cmake, gcc, etc.
- **Shell**: zsh with oh-my-posh, zsh-autosuggestions, zsh-syntax-highlighting
- **Development**: git, stow, ruby, python tools

### macOS Only
- **Editors**: Zed, VSCode, Cursor
- **Terminal**: Ghostty
- **Window Manager**: Aerospace
- **Utilities**: Raycast, Onyx, HiddenBar, AppCleaner
- **Fonts**: JetBrains Mono Nerd Font
- **Media**: VLC

### Linux Only
- **Editors**: VSCode
- **Media**: VLC
- **GNOME Extensions**: Tactile, Just Perfection, Blur My Shell, etc.
- **Fonts**: JetBrains Mono Nerd Font (downloaded)

## Customization

### Adding New Dotfiles

Dotfiles are managed using GNU Stow, which creates symbolic links. To add a new dotfile:

1. Create the file in the appropriate directory (e.g., `zsh/.zshrc` for shell config)
2. The installation script will automatically create symlinks

### Adding Software

#### CLI Tools (Cross-platform)
Add to `homebrew/Brewfile`:
```ruby
brew "package-name"
```

#### GUI Applications
- **macOS**: Add to `homebrew/Brewfile` with `cask "app-name"`
- **Linux**: Add to `scripts-linux/software-install.sh` in the apt install section

### VSCode Extensions
Extensions are managed in the platform-specific `vscode.sh` scripts. Add new extensions there.

## Project Structure

```
be-a-dev/
├── install.sh                 # Main cross-platform installer
├── scripts-macos/            # macOS-specific scripts
│   ├── brew-install.sh       # Homebrew package installation
│   ├── vscode.sh             # VSCode setup
│   ├── osx-defaults.sh      # macOS system preferences
│   └── utils.sh              # Shared utilities
├── scripts-linux/            # Linux-specific scripts
│   ├── software-install.sh   # Native software installation
│   ├── vscode.sh             # VSCode setup
│   ├── gnome-setup.sh       # GNOME configuration
│   └── utils.sh              # Shared utilities
├── homebrew/                 # Cross-platform package definitions
│   └── Brewfile              # Homebrew packages (CLI + macOS casks)
├── vscode-macos/             # VSCode settings for macOS
├── vscode-linux/             # VSCode settings for Linux
└── [other config dirs]       # Individual tool configurations
```

## Troubleshooting

- **Permission issues**: Make sure scripts are executable (`chmod +x install.sh`)
- **Homebrew issues**: On macOS, ensure Xcode Command Line Tools are installed
- **VSCode extensions**: Run the vscode.sh script manually if extensions fail to install
- **Symlinks**: Existing files are backed up automatically

## Inspiration

https://github.com/hendrikmi/dotfiles/tree/main