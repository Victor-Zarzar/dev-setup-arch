#!/bin/bash

# ============================================
# Git Configuration Functions
# ============================================

configure_git() {
    print_section "Configuring Git"

    if ! command_exists git; then
        print_error "Git is not installed. Run option 5 first."
        return 1
    fi

    local current_name
    current_name=$(git config --global user.name 2>/dev/null)
    local current_email
    current_email=$(git config --global user.email 2>/dev/null)

    if [ -n "$current_name" ] && [ -n "$current_email" ]; then
        print_info "Git already configured for: $current_name <$current_email>"
        if ! confirm_action "Do you want to reconfigure it?"; then
            return 0
        fi
    fi

    echo -n "Enter your Git user.name: "
    read -r git_name
    echo -n "Enter your Git user.email: "
    read -r git_email

    if [ -n "$git_name" ]; then
        git config --global user.name "$git_name"
        print_success "user.name set to: $git_name"
    fi

    if [ -n "$git_email" ]; then
        git config --global user.email "$git_email"
        print_success "user.email set to: $git_email"
    fi

    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global core.editor "nano"
    git config --global credential.helper "cache --timeout=3600"

    print_success "Git sensible defaults configured (init.defaultBranch=main, pull.rebase=false, credential cache)"
    log_action "Git configured for $git_name <$git_email>"
}
