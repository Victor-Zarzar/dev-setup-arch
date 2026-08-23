#!/bin/bash

# ============================================
# Manual Installation Functions (curl-based)
# ============================================

install_bun() {
    print_section "Installing Bun"

    if command_exists bun; then
        print_info "Bun already installed ($(bun --version))"
        return 0
    fi

    print_info "Installing Bun..."
    if curl -fsSL https://bun.sh/install | bash >> "$LOG_FILE" 2>&1; then
        print_success "Bun installed successfully"
        ((TOTAL_INSTALLED++))

        if ! grep -q 'BUN_INSTALL' "$HOME/.bashrc"; then
            cat >> "$HOME/.bashrc" << 'EOF'

# Bun configuration
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
EOF
            print_success "Bun added to .bashrc"
        fi

        log_action "Bun installed"
    else
        print_error "Failed to install Bun"
        log_action "ERROR: Bun installation failed"
    fi
}

install_zed() {
    if command_exists zed; then
        print_info "Zed Editor already installed"
        return 0
    fi

    print_info "Installing Zed Editor..."
    if curl -fsSL https://zed.dev/install.sh | sh >> "$LOG_FILE" 2>&1; then
        print_success "Zed Editor installed successfully"
        ((TOTAL_INSTALLED++))
        log_action "Zed Editor installed"
    else
        print_error "Failed to install Zed Editor"
    fi
}
