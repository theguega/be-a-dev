#!/bin/bash
# Linux install steps

linux_brewfile_path() {
    echo "$DOTFILES_ROOT/homebrew/Brewfile"
}

linux_ensure_brew_shellenv() {
    if command -v brew >/dev/null 2>&1; then
        return 0
    fi
    if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [[ -x "$HOME/.linuxbrew/bin/brew" ]]; then
        eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
    fi
    command -v brew >/dev/null 2>&1
}

linux_gnome_prerequisites() {
    info "Updating apt and installing packages needed for GNOME setup..."
    sudo apt update
    sudo apt install -y pipx
    success "GNOME prerequisites installed"
}

linux_install_prerequisites() {
    info "Installing Homebrew on Linux..."
    if ! command -v brew >/dev/null 2>&1; then
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        linux_ensure_brew_shellenv
    else
        warning "Homebrew already installed"
        linux_ensure_brew_shellenv
    fi
    append_brew_shellenv_to_local_zshenv_linux

    info "Updating system packages..."
    sudo apt update && sudo apt upgrade -y

    info "Installing basic build tools..."
    sudo apt install -y build-essential curl git unzip

    success "Prerequisites installed"
}

linux_brew_install_cli() {
    local brewfile
    brewfile="$(linux_brewfile_path)"
    [[ -f "$brewfile" ]] || error "Brewfile not found at $brewfile"
    linux_ensure_brew_shellenv || error "Homebrew not available; run prerequisites first"

    info "Installing CLI tools via Homebrew..."
    if brew bundle check --file="$brewfile" >/dev/null 2>&1; then
        warning "All Brewfile dependencies already satisfied"
    else
        brew bundle install --file="$brewfile"
    fi
}

linux_install_ui_packages() {
    info "Installing desktop packages via apt..."
    sudo apt install -y \
        vlc \
        gnome-shell-extension-manager \
        pipx

    linux_install_fonts
    success "Desktop packages installed"
}

linux_install_fonts() {
    info "Installing JetBrains Mono Nerd Font..."

    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"

    local font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip"
    local font_zip="/tmp/JetBrainsMono.zip"

    curl -fsSL "$font_url" -o "$font_zip"
    unzip -o "$font_zip" -d "$font_dir"
    rm "$font_zip"

    fc-cache -f -v
}

linux_set_gnome_extensions() {
    info "Installing GNOME extensions..."

    if ! command -v pipx >/dev/null 2>&1; then
        sudo apt install -y pipx
    fi

    PATH="$PATH:$HOME/.local/bin"

    pipx install gnome-extensions-cli --system-site-packages

    gnome-extensions disable tiling-assistant@ubuntu.com 2>/dev/null || true
    gnome-extensions disable ubuntu-appindicators@ubuntu.com 2>/dev/null || true
    gnome-extensions disable ubuntu-dock@ubuntu.com 2>/dev/null || true
    gnome-extensions disable ding@rastersoft.com 2>/dev/null || true

    warning "To install GNOME extensions, you may need to confirm browser prompts."
    read -p "Continue with extension install? [Y/n] " -n 1 -r
    echo
    [[ $REPLY =~ ^[Nn]$ ]] && return 1

    gext install tactile@lundal.io
    gext install just-perfection-desktop@just-perfection
    gext install blur-my-shell@aunetx
    gext install space-bar@luchrioh
    gext install undecorate@sun.wxg@gmail.com
    gext install tophat@fflewddur.github.io
    gext install AlphabeticalAppGrid@stuarthayhurst

    sudo cp ~/.local/share/gnome-shell/extensions/tactile@lundal.io/schemas/org.gnome.shell.extensions.tactile.gschema.xml /usr/share/glib-2.0/schemas/
    sudo cp ~/.local/share/gnome-shell/extensions/just-perfection-desktop\@just-perfection/schemas/org.gnome.shell.extensions.just-perfection.gschema.xml /usr/share/glib-2.0/schemas/
    sudo cp ~/.local/share/gnome-shell/extensions/blur-my-shell\@aunetx/schemas/org.gnome.shell.extensions.blur-my-shell.gschema.xml /usr/share/glib-2.0/schemas/
    sudo cp ~/.local/share/gnome-shell/extensions/space-bar\@luchrioh/schemas/org.gnome.shell.extensions.space-bar.gschema.xml /usr/share/glib-2.0/schemas/
    sudo cp ~/.local/share/gnome-shell/extensions/tophat@fflewddur.github.io/schemas/org.gnome.shell.extensions.tophat.gschema.xml /usr/share/glib-2.0/schemas/
    sudo cp ~/.local/share/gnome-shell/extensions/AlphabeticalAppGrid\@stuarthayhurst/schemas/org.gnome.shell.extensions.AlphabeticalAppGrid.gschema.xml /usr/share/glib-2.0/schemas/
    sudo glib-compile-schemas /usr/share/glib-2.0/schemas/

    gsettings set org.gnome.shell.extensions.tactile col-0 1
    gsettings set org.gnome.shell.extensions.tactile col-1 2
    gsettings set org.gnome.shell.extensions.tactile col-2 1
    gsettings set org.gnome.shell.extensions.tactile col-3 0
    gsettings set org.gnome.shell.extensions.tactile row-0 1
    gsettings set org.gnome.shell.extensions.tactile row-1 1
    gsettings set org.gnome.shell.extensions.tactile gap-size 32

    gsettings set org.gnome.shell.extensions.just-perfection animation 2
    gsettings set org.gnome.shell.extensions.just-perfection dash-app-running true
    gsettings set org.gnome.shell.extensions.just-perfection workspace true
    gsettings set org.gnome.shell.extensions.just-perfection workspace-popup false

    gsettings set org.gnome.shell.extensions.blur-my-shell.appfolder blur false
    gsettings set org.gnome.shell.extensions.blur-my-shell.lockscreen blur false
    gsettings set org.gnome.shell.extensions.blur-my-shell.screenshot blur false
    gsettings set org.gnome.shell.extensions.blur-my-shell.window-list blur false
    gsettings set org.gnome.shell.extensions.blur-my-shell.panel blur false
    gsettings set org.gnome.shell.extensions.blur-my-shell.overview blur true
    gsettings set org.gnome.shell.extensions.blur-my-shell.overview pipeline 'pipeline_default'
    gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock blur true
    gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock brightness 0.6
    gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock sigma 30
    gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock static-blur true
    gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock style-dash-to-dock 0

    gsettings set org.gnome.shell.extensions.space-bar.behavior smart-workspace-names false
    gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-activate-workspace-shortcuts false
    gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-move-to-workspace-shortcuts true
    gsettings set org.gnome.shell.extensions.space-bar.shortcuts open-menu "@as []"

    gsettings set org.gnome.shell.extensions.tophat show-icons false
    gsettings set org.gnome.shell.extensions.tophat show-cpu false
    gsettings set org.gnome.shell.extensions.tophat show-disk false
    gsettings set org.gnome.shell.extensions.tophat show-mem false
    gsettings set org.gnome.shell.extensions.tophat network-usage-unit bits

    gsettings set org.gnome.shell.extensions.alphabetical-app-grid folder-order-position 'end'
}

linux_set_gnome_hotkeys() {
    info "Setting up GNOME hotkeys..."

    gsettings set org.gnome.desktop.wm.keybindings close "['<Super>w']"
    gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>Up']"
    gsettings set org.gnome.desktop.wm.keybindings begin-resize "['<Super>BackSpace']"
    gsettings set org.gnome.settings-daemon.plugins.media-keys next "['<Shift>AudioPlay']"
    gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Shift>F11']"

    gsettings set org.gnome.mutter dynamic-workspaces false
    gsettings set org.gnome.desktop.wm.preferences num-workspaces 6

    gsettings set org.gnome.shell.keybindings switch-to-application-1 "['<Alt>1']"
    gsettings set org.gnome.shell.keybindings switch-to-application-2 "['<Alt>2']"
    gsettings set org.gnome.shell.keybindings switch-to-application-3 "['<Alt>3']"
    gsettings set org.gnome.shell.keybindings switch-to-application-4 "['<Alt>4']"
    gsettings set org.gnome.shell.keybindings switch-to-application-5 "['<Alt>5']"
    gsettings set org.gnome.shell.keybindings switch-to-application-6 "['<Alt>6']"
    gsettings set org.gnome.shell.keybindings switch-to-application-7 "['<Alt>7']"
    gsettings set org.gnome.shell.keybindings switch-to-application-8 "['<Alt>8']"
    gsettings set org.gnome.shell.keybindings switch-to-application-9 "['<Alt>9']"

    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"

    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/']"

    gsettings set org.gnome.desktop.wm.keybindings switch-input-source "@as []"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'ulauncher-toggle'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'ulauncher-toggle'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>space'

    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Flameshot'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'sh -c -- "flameshot gui"'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Control>Print'

    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'alacritty'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 'alacritty'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding '<Shift><Alt>2'

    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ name 'new chrome'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command 'google-chrome'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ binding '<Shift><Alt>1'
}
