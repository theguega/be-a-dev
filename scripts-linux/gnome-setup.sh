#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "$SCRIPT_DIR"/utils.sh

set_gnome_extensions() {
    info "Installing GNOME extensions..."

    sudo apt install -y gnome-shell-extension-manager pipx
    pipx install gnome-extensions-cli --system-site-packages

    # Turn off default Ubuntu extensions
    gnome-extensions disable tiling-assistant@ubuntu.com
    gnome-extensions disable ubuntu-appindicators@ubuntu.com
    gnome-extensions disable ubuntu-dock@ubuntu.com
    gnome-extensions disable ding@rastersoft.com

    # Pause to assure user is ready to accept confirmations
    info confirm "To install Gnome extensions, you need to accept some confirmations. Are you ready?"

    # Install new extensions
    gext install tactile@lundal.io
    gext install just-perfection-desktop@just-perfection
    gext install blur-my-shell@aunetx
    gext install space-bar@luchrioh
    gext install undecorate@sun.wxg@gmail.com
    gext install tophat@fflewddur.github.io
    gext install AlphabeticalAppGrid@stuarthayhurst

    # Compile gsettings schemas in order to be able to set them
    sudo cp ~/.local/share/gnome-shell/extensions/tactile@lundal.io/schemas/org.gnome.shell.extensions.tactile.gschema.xml /usr/share/glib-2.0/schemas/
    sudo cp ~/.local/share/gnome-shell/extensions/just-perfection-desktop\@just-perfection/schemas/org.gnome.shell.extensions.just-perfection.gschema.xml /usr/share/glib-2.0/schemas/
    sudo cp ~/.local/share/gnome-shell/extensions/blur-my-shell\@aunetx/schemas/org.gnome.shell.extensions.blur-my-shell.gschema.xml /usr/share/glib-2.0/schemas/
    sudo cp ~/.local/share/gnome-shell/extensions/space-bar\@luchrioh/schemas/org.gnome.shell.extensions.space-bar.gschema.xml /usr/share/glib-2.0/schemas/
    sudo cp ~/.local/share/gnome-shell/extensions/tophat@fflewddur.github.io/schemas/org.gnome.shell.extensions.tophat.gschema.xml /usr/share/glib-2.0/schemas/
    sudo cp ~/.local/share/gnome-shell/extensions/AlphabeticalAppGrid\@stuarthayhurst/schemas/org.gnome.shell.extensions.AlphabeticalAppGrid.gschema.xml /usr/share/glib-2.0/schemas/
    sudo glib-compile-schemas /usr/share/glib-2.0/schemas/

    # Configure Tactile
    gsettings set org.gnome.shell.extensions.tactile col-0 1
    gsettings set org.gnome.shell.extensions.tactile col-1 2
    gsettings set org.gnome.shell.extensions.tactile col-2 1
    gsettings set org.gnome.shell.extensions.tactile col-3 0
    gsettings set org.gnome.shell.extensions.tactile row-0 1
    gsettings set org.gnome.shell.extensions.tactile row-1 1
    gsettings set org.gnome.shell.extensions.tactile gap-size 32

    # Configure Just Perfection
    gsettings set org.gnome.shell.extensions.just-perfection animation 2
    gsettings set org.gnome.shell.extensions.just-perfection dash-app-running true
    gsettings set org.gnome.shell.extensions.just-perfection workspace true
    gsettings set org.gnome.shell.extensions.just-perfection workspace-popup false

    # Configure Blur My Shell
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

    # Configure Space Bar
    gsettings set org.gnome.shell.extensions.space-bar.behavior smart-workspace-names false
    gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-activate-workspace-shortcuts false
    gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-move-to-workspace-shortcuts true
    gsettings set org.gnome.shell.extensions.space-bar.shortcuts open-menu "@as []"

    # Configure TopHat
    gsettings set org.gnome.shell.extensions.tophat show-icons false
    gsettings set org.gnome.shell.extensions.tophat show-cpu false
    gsettings set org.gnome.shell.extensions.tophat show-disk false
    gsettings set org.gnome.shell.extensions.tophat show-mem false
    gsettings set org.gnome.shell.extensions.tophat network-usage-unit bits

    # Configure AlphabeticalAppGrid
    gsettings set org.gnome.shell.extensions.alphabetical-app-grid folder-order-position 'end'
}

set_gnome_hotkeys() {
    info "Setting up GNOME hotkeys..."

    # Alt+F4 is very cumbersome
    gsettings set org.gnome.desktop.wm.keybindings close "['<Super>w']"

    # Make it easy to maximize like you can fill left/right
    gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>Up']"

    # Make it easy to resize undecorated windows
    gsettings set org.gnome.desktop.wm.keybindings begin-resize "['<Super>BackSpace']"

    # For keyboards that only have a start/stop button for music, like Logitech MX Keys Mini
    gsettings set org.gnome.settings-daemon.plugins.media-keys next "['<Shift>AudioPlay']"

    # Full-screen with title/navigation bar
    gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Shift>F11']"

    # Use 6 fixed workspaces instead of dynamic mode
    gsettings set org.gnome.mutter dynamic-workspaces false
    gsettings set org.gnome.desktop.wm.preferences num-workspaces 6

    # Use alt for pinned apps
    gsettings set org.gnome.shell.keybindings switch-to-application-1 "['<Alt>1']"
    gsettings set org.gnome.shell.keybindings switch-to-application-2 "['<Alt>2']"
    gsettings set org.gnome.shell.keybindings switch-to-application-3 "['<Alt>3']"
    gsettings set org.gnome.shell.keybindings switch-to-application-4 "['<Alt>4']"
    gsettings set org.gnome.shell.keybindings switch-to-application-5 "['<Alt>5']"
    gsettings set org.gnome.shell.keybindings switch-to-application-6 "['<Alt>6']"
    gsettings set org.gnome.shell.keybindings switch-to-application-7 "['<Alt>7']"
    gsettings set org.gnome.shell.keybindings switch-to-application-8 "['<Alt>8']"
    gsettings set org.gnome.shell.keybindings switch-to-application-9 "['<Alt>9']"

    # Use super for workspaces
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"

    # Reserve slots for custom keybindings
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/']"

    # Set ulauncher to Super+Space
    gsettings set org.gnome.desktop.wm.keybindings switch-input-source "@as []"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'ulauncher-toggle'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'ulauncher-toggle'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>space'

    # Set flameshot (with the sh fix for starting under Wayland) on alternate print screen key
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Flameshot'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'sh -c -- "flameshot gui"'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Control>Print'

    # Start a new alacritty window (rather than just switch to the already open one)
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'alacritty'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 'alacritty'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding '<Shift><Alt>2'

    # Start a new Chrome window (rather than just switch to the already open one)
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ name 'new chrome'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command 'google-chrome'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ binding '<Shift><Alt>1'
}


if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    set_gnome_extensions
    set_gnome_hotkeys
fi