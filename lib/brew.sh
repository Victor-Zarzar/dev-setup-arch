#!/bin/bash

# ============================================
# Homebrew Installation Functions
# ============================================

install_homebrew() {
    print_section "Installing Homebrew"

    if command_exists brew; then
        print_info "Homebrew already installed ($(brew --version | head -n 1))"
        return 0
    fi

    print_info "Installing Homebrew build prerequisites..."
    run_command "sudo pacman -S --noconfirm --needed base-devel procps-ng curl file git" "Homebrew prerequisites installed"

    print_info "Installing Homebrew..."

    if NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" >> "$LOG_FILE" 2>&1; then
        print_success "Homebrew installed successfully"

        if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

            if ! grep -q 'linuxbrew' "$HOME/.bashrc"; then
                echo '' >> "$HOME/.bashrc"
                echo '# Homebrew configuration' >> "$HOME/.bashrc"
                echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.bashrc"
                print_success "Homebrew added to .bashrc"
            fi
        fi

        log_action "Homebrew installed"
        return 0
    else
        print_error "Failed to install Homebrew"
        log_action "ERROR: Homebrew installation failed"
        return 1
    fi
}

install_brew_packages() {
    print_section "Installing Homebrew Packages"

    if ! command_exists brew; then
        print_warning "Homebrew not found, skipping brew packages"
        return 1
    fi

    if brew list pyenv &> /dev/null; then
        print_info "Pyenv already installed"
    else
        run_command "brew install pyenv" "Pyenv installed"
    fi

    if brew list nvm &> /dev/null; then
        print_info "NVM already installed"
    else
        run_command "brew install nvm" "NVM installed"
    fi

    if brew list openjdk@21 &> /dev/null; then
        print_info "OpenJDK 21 already installed"
    else
        run_command "brew install openjdk@21" "OpenJDK 21 installed"
    fi

    if brew list nginx &> /dev/null; then
        print_info "Nginx already installed"
    else
        run_command "brew install nginx" "Nginx installed"
    fi

    if brew list sqlite &> /dev/null; then
        print_info "SQLite already installed"
    else
        run_command "brew install sqlite" "SQLite installed"
    fi

    if brew list mysql &> /dev/null; then
        print_info "MySQL already installed"
    else
        run_command "brew install mysql" "MySQL installed"
    fi

    if brew list postgresql@17 &> /dev/null; then
        print_info "PostgreSQL already installed"

        if [ ! -f "/home/linuxbrew/.linuxbrew/var/postgresql@17/PG_VERSION" ]; then
            print_warning "PostgreSQL package is installed, but the database cluster wasn't initialized (known Homebrew postinstall issue)"
            print_warning "Run manually: initdb --locale=en_US.UTF-8 -E UTF-8 /home/linuxbrew/.linuxbrew/var/postgresql@17"
        fi
    else
        run_command "brew install postgresql@17" "PostgreSQL installed"

        if [ ! -f "/home/linuxbrew/.linuxbrew/var/postgresql@17/PG_VERSION" ]; then
            print_warning "PostgreSQL package installed, but the database cluster wasn't initialized (known Homebrew postinstall issue)"
            print_warning "Run manually: initdb --locale=en_US.UTF-8 -E UTF-8 /home/linuxbrew/.linuxbrew/var/postgresql@17"
        fi
    fi

    if brew list redis &> /dev/null; then
        print_info "Redis already installed"
    else
        run_command "brew install redis" "Redis installed"
    fi

    if brew list starship &> /dev/null; then
        print_info "Starship already installed"
    else
        run_command "brew install starship" "Starship prompt installed"
    fi

    if brew list zsh-autosuggestions &> /dev/null; then
        print_info "Zsh autosuggestions already installed"
    else
        run_command "brew install zsh-autosuggestions" "Zsh autosuggestions installed"
    fi

    if brew list fvm &> /dev/null; then
        print_info "FVM already installed"
    else
        run_command "brew tap leoafarias/fvm" "FVM tap added"
        run_command "brew install fvm" "FVM installed"
    fi

    if brew list alembic &> /dev/null; then
        print_info "Alembic already installed"
    else
        run_command "brew install alembic" "Alembic installed"
    fi

    if brew list eza &> /dev/null; then
        print_info "Eza already installed"
    else
        run_command "brew install eza" "Eza installed"
    fi

    if brew list bat &> /dev/null; then
        print_info "Bat already installed"
    else
        run_command "brew install bat" "Bat installed"
    fi

    if brew list zoxide &> /dev/null; then
        print_info "Zoxide already installed"
    else
        run_command "brew install zoxide" "Zoxide installed"
    fi

    if ! grep -q 'NVM_DIR' "$HOME/.bashrc"; then
        cat >> "$HOME/.bashrc" << 'EOF'

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm"
EOF
        print_success "NVM added to .bashrc"
    else
        print_info "NVM already configured in .bashrc"
    fi

    if ! grep -q 'pyenv init' "$HOME/.bashrc"; then
        cat >> "$HOME/.bashrc" << 'EOF'

# Pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
EOF
        print_success "Pyenv added to .bashrc"
    else
        print_info "Pyenv already configured in .bashrc"
    fi

    if ! grep -q 'starship init' "$HOME/.bashrc"; then
        echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
        print_success "Starship added to .bashrc"
    else
        print_info "Starship already configured in .bashrc"
    fi

    if ! grep -q 'zoxide init' "$HOME/.bashrc"; then
        echo 'eval "$(zoxide init bash)"' >> "$HOME/.bashrc"
        print_success "Zoxide added to .bashrc"
    else
        print_info "Zoxide already configured in .bashrc"
    fi

    if ! grep -q 'zsh-autosuggestions' "$HOME/.zshrc" 2>/dev/null; then
        echo 'source /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> "$HOME/.zshrc"
        print_success "Zsh autosuggestions added to .zshrc"
    else
        print_info "Zsh autosuggestions already configured in .zshrc"
    fi

    print_info "MySQL service: brew services start mysql"
    print_info "Nginx service: brew services start nginx"
}
