#!/bin/bash

# ============================================
# AUR (yay) Installation Functions
# ============================================

setup_yay() {
    print_section "Setting Up yay (AUR Helper)"

    if command_exists yay; then
        print_info "yay already installed ($(yay --version | head -n1))"
        return 0
    fi

    print_info "Installing yay build dependencies..."
    run_command "sudo pacman -S --noconfirm --needed base-devel git" "Build dependencies installed"

    print_info "Cloning and building yay..."
    if git clone https://aur.archlinux.org/yay.git /tmp/yay >> "$LOG_FILE" 2>&1; then
        if (cd /tmp/yay && makepkg -si --noconfirm) >> "$LOG_FILE" 2>&1; then
            print_success "yay installed successfully"
            ((TOTAL_INSTALLED++))
            log_action "yay installed"
        else
            print_error "Failed to build/install yay"
        fi
        rm -rf /tmp/yay
    else
        print_error "Failed to clone yay repository"
    fi
}

install_editors() {
    print_section "Installing Text Editors"

    if ! command_exists yay; then
        print_warning "yay not installed, run option 3 first"
    else
        yay_install "sublime-text-4" "Sublime Text"
    fi

    print_info "Zed Editor will be installed via curl (option 6 or 23)"
    install_zed
}

install_aur_apps() {
    print_section "Installing AUR Applications"

    if ! command_exists yay; then
        print_error "yay is not installed. Run option 3 (Setup yay) first."
        return 1
    fi

    local apps=(
        "postman-bin:Postman"
        "notion-app-electron:Notion"
        "whatsapp-for-linux:WhatsApp"
        "android-studio:Android Studio"
        "brave-bin:Brave"
        "spotify:Spotify"
        "slack-desktop:Slack"
        "telegram-desktop:Telegram"
        "figma-linux:Figma"
    )

    for app in "${apps[@]}"; do
        IFS=':' read -r pkg desc <<< "$app"
        yay_install "$pkg" "$desc"
    done

    # Proton VPN's GUI client moved into the official extra repo as
    # proton-vpn-gtk-app, so it's installed via pacman, not yay.
    pacman_install "proton-vpn-gtk-app" "Proton VPN"

    # Trello: the only AUR package ("trello") wraps an ancient Electron 17
    # and has to compile Chromium/V8 from source (multi-GB clone, hours to
    # build, and it's flagged broken upstream). There's no maintained
    # binary AUR package for a Trello desktop app, so it's skipped here.
    # Use the web app, or install trello via Notion/Slack's built-in
    # browser shortcuts, or search flathub for a maintained alternative.
    print_info "Trello skipped: no maintained AUR binary exists (only a broken from-source Electron build). Use the web app instead."
}

install_firefox() {
    print_section "Installing Firefox (Optional)"

    if command_exists firefox; then
        print_warning "Firefox is already installed on your system"
        if ! confirm_action "Do you want to reinstall/update Firefox via pacman anyway?"; then
            print_info "Skipping Firefox installation"
            return 0
        fi
    fi

    pacman_install "firefox" "Firefox"
}
