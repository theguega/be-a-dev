#!/bin/bash
# macOS system defaults configuration

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

apply_system_defaults() {
    info "Applying macOS system defaults..."

    # Keyboard & Input
    defaults write -g ApplePressAndHoldEnabled -bool false
    defaults write -g KeyRepeat -int 2
    defaults write -g InitialKeyRepeat -int 15

    # Finder
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
    defaults write com.apple.finder CreateDesktop -bool false
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder ShowStatusBar -bool true
    defaults write com.apple.finder "AppleShowAllFiles" -bool true
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Screenshots
    defaults write com.apple.screencapture type -string "png"
    defaults write com.apple.screencapture disable-shadow -bool true

    # Dock
    defaults write com.apple.dock tilesize -float 48
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock autohide-delay -float 1000
    defaults write com.apple.dock show-recents -bool false
    defaults write com.apple.dock mru-spaces -bool false
    defaults write com.apple.dock expose-group-apps -bool true

    # Mission Control
    defaults write com.apple.spaces spans-displays -bool false

    # Software Updates
    defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 7

    # Disable Spotlight shortcut (for Raycast)
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "{enabled = 0; value = { parameters = (32, 49, 1048576); type = 'standard'; };}"
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 "{enabled = 0; value = { parameters = (32, 49, 1048576); type = 'standard'; };}"

    # Security
    defaults write com.apple.screensaver askForPassword -bool true
    defaults write com.apple.screensaver askForPasswordDelay -int 0

    # Kill affected applications
    killall Finder
    killall Dock
    killall SystemUIServer

    success "macOS defaults applied"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    apply_system_defaults
fi
