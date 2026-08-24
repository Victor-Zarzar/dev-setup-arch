#!/bin/bash

# ============================================
# System Functions
# ============================================

update_system() {
    print_section "Updating System"

    run_command "sudo pacman -Syu --noconfirm" "System packages updated (pacman)"

    if command_exists yay; then
        run_command "yay -Sua --noconfirm" "AUR packages updated (yay)"
    else
        print_info "yay not installed yet, skipping AUR update (see option 3)"
    fi

    log_action "System update finished"
}

setup_directories() {
    print_section "Setting Up Directories"

    local dirs=(
        "$HOME/Projects"
        "$HOME/Documents"
        "$HOME/Downloads/Installers"
        "$HOME/.local/bin"
        "$HOME/.config"
    )

    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            print_info "Directory already exists: $dir"
        else
            if mkdir -p "$dir"; then
                print_success "Directory created: $dir"
                ((TOTAL_INSTALLED++))
            else
                print_error "Failed to create directory: $dir"
            fi
        fi
    done

    log_action "Directories configured"
}

install_zsh() {
    print_section "Installing Zsh"

    pacman_install "zsh" "Zsh"

    print_info "zsh-autosuggestions will be installed via Homebrew (option 20)"
    print_warning "Run 'chsh -s \$(which zsh)' to set Zsh as your default shell"
}
