#!/bin/bash
# macOS install steps (Intel and Apple Silicon)

macos_brewfile_path() {
    echo "$DOTFILES_ROOT/homebrew/Brewfile"
}

macos_ensure_brew_in_path() {
    if command -v brew >/dev/null 2>&1; then
        return 0
    fi
    if [[ $(uname -m) == "arm64" ]]; then
        [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        [[ -x /usr/local/bin/brew ]] && eval "$(/usr/local/bin/brew shellenv)"
    fi
    command -v brew >/dev/null 2>&1
}

macos_install_prerequisites() {
    info "Installing Xcode Command Line Tools..."
    if ! xcode-select -p >/dev/null 2>&1; then
        xcode-select --install
        sudo xcodebuild -license accept
    else
        warning "Xcode Command Line Tools already installed"
    fi

    info "Installing Homebrew..."
    if ! command -v brew >/dev/null 2>&1; then
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [[ $(uname -m) == "arm64" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        warning "Homebrew already installed"
    fi
    macos_ensure_brew_in_path
}

macos_brew_install_formulas_only() {
    local brewfile
    brewfile="$(macos_brewfile_path)"
    [[ -f "$brewfile" ]] || error "Brewfile not found at $brewfile"

    unset HOMEBREW_BUNDLE_BREW_SKIP
    HOMEBREW_BUNDLE_CASK_SKIP="$(brewfile_cask_names "$brewfile")"
    export HOMEBREW_BUNDLE_CASK_SKIP

    info "Installing Homebrew formulae from Brewfile..."
    if brew bundle check --file="$brewfile" >/dev/null 2>&1; then
        warning "All Brewfile dependencies already satisfied"
    else
        brew bundle install --file="$brewfile"
    fi
}

macos_brew_install_casks_only() {
    local brewfile
    brewfile="$(macos_brewfile_path)"
    [[ -f "$brewfile" ]] || error "Brewfile not found at $brewfile"

    unset HOMEBREW_BUNDLE_CASK_SKIP
    HOMEBREW_BUNDLE_BREW_SKIP="$(brewfile_formula_names "$brewfile")"
    export HOMEBREW_BUNDLE_BREW_SKIP

    info "Installing Homebrew casks from Brewfile..."
    brew bundle install --file="$brewfile"
}

macos_apply_system_defaults() {
    info "Applying macOS system defaults..."

    defaults write -g ApplePressAndHoldEnabled -bool false
    defaults write -g KeyRepeat -int 2
    defaults write -g InitialKeyRepeat -int 15

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

    defaults write com.apple.screencapture type -string "png"
    defaults write com.apple.screencapture disable-shadow -bool true

    defaults write com.apple.dock tilesize -float 48
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock autohide-delay -float 1000
    defaults write com.apple.dock show-recents -bool false
    defaults write com.apple.dock mru-spaces -bool false
    defaults write com.apple.dock expose-group-apps -bool true

    defaults write com.apple.spaces spans-displays -bool false

    defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 7

    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "{enabled = 0; value = { parameters = (32, 49, 1048576); type = 'standard'; };}"
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 "{enabled = 0; value = { parameters = (32, 49, 1048576); type = 'standard'; };}"

    defaults write com.apple.screensaver askForPassword -bool true
    defaults write com.apple.screensaver askForPasswordDelay -int 0

    killall Finder 2>/dev/null || true
    killall Dock 2>/dev/null || true
    killall SystemUIServer 2>/dev/null || true

    success "macOS defaults applied"
}
