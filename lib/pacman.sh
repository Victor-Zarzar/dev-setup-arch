#!/bin/bash

# ============================================
# Pacman Package Installation Functions
# ============================================

install_git() {
    print_section "Installing Git"

    if command_exists git; then
        print_info "Git already installed ($(git --version))"
        return 0
    fi

    pacman_install "git" "Git"
}

install_security_tools() {
    print_section "Installing Security Tools"

    pacman_install "keepassxc" "KeePassXC"
    yay_install "localsend-bin" "LocalSend"
    pacman_install "openvpn" "OpenVPN"
    pacman_install "networkmanager-openvpn" "NetworkManager OpenVPN plugin"
}

install_python_env() {
    print_section "Installing Python Environment"

    pacman_install "python-pip" "python-pip"
    pacman_install "python-virtualenv" "python-virtualenv"

    if ! pip list 2>/dev/null | grep -q "fastapi"; then
        run_command "pip install --break-system-packages fastapi uvicorn" "FastAPI and Uvicorn installed"
    else
        print_info "FastAPI and Uvicorn already installed"
    fi

    if command_exists leme; then
        print_info "Leme already installed ($(leme --version 2>&1))"
    else
        if command_exists pipx; then
            run_command "pipx install leme" "Leme DevOps CLI installed (pipx)"
        elif command_exists pip; then
            run_command "pip install --user --break-system-packages leme" "Leme DevOps CLI installed (pip)"
        else
            print_error "Neither pipx nor pip found - cannot install Leme"
        fi

        export PATH="$HOME/.local/bin:$PATH"

        if command_exists leme; then
            print_success "Leme verified: $(leme --version 2>&1)"
            log_action "Leme installed and verified ($(leme --version 2>&1))"
        else
            print_error "Leme was installed but isn't on PATH yet. Add \$HOME/.local/bin to your PATH (restart terminal), then re-run this option."
            log_action "Leme install completed but verification failed - PATH issue likely"
        fi
    fi

    log_action "Python environment configured"
}

install_nodejs_tools() {
    print_section "Installing Node.js Tools"

    if ! command_exists npm; then
        pacman_install "npm" "NPM"
    else
        print_info "NPM already installed ($(npm --version))"
    fi

    if ! command_exists pnpm; then
        run_command "sudo npm install -g pnpm" "PNPM installed"
    else
        print_info "PNPM already installed ($(pnpm --version))"
    fi

    print_info "NVM will be installed via Homebrew (option 20)"
}

install_browsers() {
    print_section "Installing Additional Browsers"

    if command_exists google-chrome-stable; then
        print_info "Google Chrome already installed ($(google-chrome-stable --version))"
        return 0
    fi

    print_info "Installing Google Chrome from AUR..."
    yay_install "google-chrome" "Google Chrome"
}

install_utility_tools() {
    print_section "Installing Utility Tools"

    yay_install "kdiskmark" "KDiskMark (disk benchmark tool)"
    # "balena-etcher-bin" doesn't exist; "etcher-bin" repackages the
    # official .deb without compiling anything.
    yay_install "etcher-bin" "Balena Etcher"
}

install_system_tools() {
    print_section "Installing System Tools"

    pacman_install "openssh" "SSH server"
    if systemctl is-enabled sshd.service &> /dev/null; then
        print_info "sshd service already enabled"
    else
        run_command "sudo systemctl enable sshd.service" "sshd service enabled"
    fi

    pacman_install "nano" "Nano"
    pacman_install "spectacle" "KDE Spectacle (screenshot tool)"
    pacman_install "cmake" "CMake"
    pacman_install "automake" "Automake"
    pacman_install "ninja" "Ninja build"
    pacman_install "clang" "Clang"
    pacman_install "base-devel" "base-devel (build tools group)"
    pacman_install "flatpak" "Flatpak"

    print_info "Nginx will be installed via Homebrew (option 20)"
}

install_databases() {
    print_section "Installing Databases"

    print_info "SQLite and MySQL will be installed via Homebrew (option 20)"
    print_info "Skipping pacman database installation..."
}
