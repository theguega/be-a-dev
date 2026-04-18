#!/bin/bash
# Interactive dotfiles setup: OS is detected automatically; prompts are SSH-aware.

source "$DOTFILES_ROOT/install/lib/utils.sh"
source "$DOTFILES_ROOT/install/lib/env.sh"
source "$DOTFILES_ROOT/install/lib/brewfile.sh"
source "$DOTFILES_ROOT/install/lib/zsh-env.sh"
source "$DOTFILES_ROOT/install/macos.sh"
source "$DOTFILES_ROOT/install/linux.sh"

dotfiles_platform_label() {
    case "$DOTFILES_OS" in
        darwin)
            if [[ "$DOTFILES_ARCH" == "arm64" ]]; then
                echo "macOS (Apple Silicon), $DOTFILES_ARCH"
            else
                echo "macOS (Intel), $DOTFILES_ARCH"
            fi
            ;;
        linux)
            echo "Linux ($DOTFILES_ARCH)"
            ;;
    esac
}

prompt_yes_no() {
    local prompt_text="$1"
    local default_yes="${2:-1}"
    local reply
    if [[ "$default_yes" == "1" ]]; then
        read -p "$prompt_text [Y/n] " -n 1 -r reply
        echo
        [[ -z "$reply" || ! $reply =~ ^[Nn]$ ]]
    else
        read -p "$prompt_text [y/N] " -n 1 -r reply
        echo
        [[ -n "$reply" && $reply =~ ^[Yy]$ ]]
    fi
}

show_install_help() {
    cat <<'EOF'
Usage: ./install.sh [OPTION]...

With no arguments, runs interactive prompts (SSH-aware).

Options:
  -a, --all       Enable all options for this OS (SSH / GUI rules still apply)
  -c, --cli       Install Homebrew CLI packages (Brewfile formulae)
  -u, --ui        GUI: Homebrew casks (macOS) or apt + fonts (Linux)
  -d, --defaults  Apply macOS system defaults (macOS only)
  -g, --gnome     GNOME extensions and hotkeys (Linux desktop only)
  -h, --help      Show this help

Examples:
  ./install.sh
  ./install.sh -a
  ./install.sh --cli --ui --defaults
EOF
}

parse_install_args() {
    local -n _cli=$1 _od=$2 _ui=$3 _gnome=$4
    shift 4

    _cli=false
    _od=false
    _ui=false
    _gnome=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -a | --all)
                _cli=true
                _ui=true
                if [[ "$DOTFILES_OS" == darwin ]]; then
                    _od=true
                fi
                if [[ "$DOTFILES_OS" == linux ]]; then
                    _gnome=true
                fi
                ;;
            -c | --cli)
                _cli=true
                ;;
            -u | --ui)
                _ui=true
                ;;
            -d | --defaults)
                _od=true
                ;;
            -g | --gnome)
                _gnome=true
                ;;
            *)
                error "Unknown option: $1 (use --help)"
                ;;
        esac
        shift
    done
}

apply_install_arg_guards() {
    local -n _cli=$1 _od=$2 _ui=$3 _gnome=$4

    if [[ "$DOTFILES_OS" == linux ]] && $_od; then
        warning "Linux: ignoring --defaults (macOS only)"
        _od=false
    fi
    if [[ "$DOTFILES_OS" == darwin ]] && $_gnome; then
        warning "macOS: ignoring --gnome (Linux only)"
        _gnome=false
    fi

    if is_ssh_session; then
        if $_ui; then
            warning "SSH session: skipping --ui"
            _ui=false
        fi
        if $_gnome; then
            warning "SSH session: skipping --gnome"
            _gnome=false
        fi
    fi

    if [[ "$DOTFILES_OS" == linux ]]; then
        if ! linux_has_gui_session && $_ui; then
            warning "No GUI session detected: skipping --ui"
            _ui=false
        fi
        if { ! linux_has_gui_session || ! gnome_available; } && $_gnome; then
            warning "GNOME/GUI not available: skipping --gnome"
            _gnome=false
        fi
    fi
}

main() {
    local _a
    for _a in "$@"; do
        if [[ "$_a" == "-h" || "$_a" == "--help" ]]; then
            show_install_help
            exit 0
        fi
    done

    detect_platform

    info "Dotfiles installer — $(dotfiles_platform_label)"

    local want_cli=false
    local want_os_defaults=false
    local want_ui=false
    local want_gnome=false

    if [[ $# -gt 0 ]]; then
        parse_install_args want_cli want_os_defaults want_ui want_gnome "$@"
        apply_install_arg_guards want_cli want_os_defaults want_ui want_gnome
        info "Non-interactive: CLI=$want_cli macOS_defaults=$want_os_defaults UI=$want_ui GNOME=$want_gnome"
    else
        if is_ssh_session; then
            warning "SSH session: GUI app and GNOME steps are disabled (run locally on the machine for those)."
        fi

        if prompt_yes_no "Install CLI packages (Homebrew formulae)?" 1; then
            want_cli=true
        fi

        case "$DOTFILES_OS" in
            darwin)
                if prompt_yes_no "Apply macOS system defaults (Finder, Dock, keyboard, …)?" 1; then
                    want_os_defaults=true
                fi
                if ! is_ssh_session; then
                    if prompt_yes_no "Install GUI apps (Homebrew casks)?" 1; then
                        want_ui=true
                    fi
                fi
                ;;
            linux)
                if ! is_ssh_session && linux_has_gui_session; then
                    if prompt_yes_no "Install desktop packages (apt, fonts)?" 1; then
                        want_ui=true
                    fi
                fi
                if ! is_ssh_session && linux_has_gui_session && gnome_available; then
                    if prompt_yes_no "Configure GNOME (extensions, hotkeys, gsettings)?" 1; then
                        want_gnome=true
                    fi
                elif ! is_ssh_session && ! gnome_available; then
                    warning "GNOME not detected; skipping GNOME configuration prompts."
                fi
                ;;
        esac
    fi

    if [[ "$DOTFILES_OS" == darwin ]]; then
        run_darwin "$want_cli" "$want_os_defaults" "$want_ui"
    else
        run_linux "$want_cli" "$want_ui" "$want_gnome"
    fi

    info "Done. Restart the system if you changed system settings or desktop environment."
}

run_darwin() {
    local want_cli="$1"
    local want_os_defaults="$2"
    local want_ui="$3"

    if ! $want_cli && ! $want_ui && ! $want_os_defaults; then
        warning "Nothing selected; exiting."
        return 0
    fi

    ensure_zsh_local_zshenv

    if $want_cli || $want_ui; then
        run_with_progress "Installing prerequisites (Xcode CLT, Homebrew)" macos_install_prerequisites
    fi
    if $want_cli; then
        run_with_progress "Installing Homebrew formulae" macos_brew_install_formulas_only
    fi
    if $want_ui; then
        run_with_progress "Installing Homebrew casks" macos_brew_install_casks_only
    fi
    if $want_os_defaults; then
        run_with_progress "Applying macOS system defaults" macos_apply_system_defaults
    fi

    append_brew_shellenv_to_local_zshenv_macos
}

run_linux() {
    local want_cli="$1"
    local want_ui="$2"
    local want_gnome="$3"

    if ! $want_cli && ! $want_ui && ! $want_gnome; then
        warning "Nothing selected; exiting."
        return 0
    fi

    ensure_zsh_local_zshenv

    if $want_cli || $want_ui; then
        run_with_progress "Installing prerequisites (apt, Homebrew)" linux_install_prerequisites
    elif $want_gnome; then
        run_with_progress "Installing GNOME prerequisites (apt, pipx)" linux_gnome_prerequisites
    fi

    if $want_cli; then
        run_with_progress "Installing Homebrew CLI packages" linux_brew_install_cli
    fi
    if $want_ui; then
        run_with_progress "Installing desktop packages and fonts" linux_install_ui_packages
    fi
    if $want_gnome; then
        run_with_progress "Configuring GNOME extensions" linux_set_gnome_extensions
        run_with_progress "Configuring GNOME hotkeys" linux_set_gnome_hotkeys
    fi

    if $want_cli || $want_ui || $want_gnome; then
        info "Setting default shell to zsh (if available)"
        if [[ -x /bin/zsh ]]; then
            chsh -s /bin/zsh || warning "Could not change login shell to zsh (run: chsh -s /bin/zsh)"
        else
            warning "/bin/zsh not found; skipping chsh"
        fi
    fi
}
