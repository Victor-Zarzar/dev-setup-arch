#!/bin/bash

# ============================================
# Generic Utility Functions
# ============================================

# Check if a pacman (official repo) package is installed
is_pacman_pkg_installed() {
    pacman -Qi "$1" &> /dev/null
}

# Check if an AUR package is installed (same DB as pacman, kept as alias for clarity)
is_aur_pkg_installed() {
    pacman -Qi "$1" &> /dev/null
}

# Check if a binary exists on PATH
command_exists() {
    command -v "$1" &> /dev/null
}

# Simple yes/no confirmation prompt. Returns 0 for yes, 1 for no.
confirm_action() {
    local prompt="${1:-Are you sure?} (y/N): "
    local response
    echo -n "$prompt"
    read -r response
    [[ "$response" =~ ^[Yy]$ ]]
}

# Install a package via pacman if not already installed
pacman_install() {
    local pkg="$1"
    local desc="${2:-$1}"

    if is_pacman_pkg_installed "$pkg"; then
        print_info "$desc already installed"
        return 0
    fi
    run_command "sudo pacman -S --noconfirm --needed $pkg" "$desc installed"
}

# Install a package via yay (AUR) if not already installed
yay_install() {
    local pkg="$1"
    local desc="${2:-$1}"

    if ! command_exists yay; then
        print_error "yay is not installed. Run option 3 (Setup yay) first."
        return 1
    fi

    if is_aur_pkg_installed "$pkg"; then
        print_info "$desc already installed"
        return 0
    fi
    run_command "yay -S --noconfirm --needed $pkg" "$desc installed"
}
