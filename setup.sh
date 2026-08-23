#!/bin/bash

# ============================================
# Arch Linux Development Environment Setup
# Main Entry Point
# ============================================

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/helpers.sh"
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/lib/fonts.sh"
source "$SCRIPT_DIR/lib/system.sh"
source "$SCRIPT_DIR/lib/pacman.sh"
source "$SCRIPT_DIR/lib/aur.sh"
source "$SCRIPT_DIR/lib/flatpak.sh"
source "$SCRIPT_DIR/lib/brew.sh"
source "$SCRIPT_DIR/lib/manual.sh"
source "$SCRIPT_DIR/lib/docker.sh"
source "$SCRIPT_DIR/lib/devops.sh"
source "$SCRIPT_DIR/lib/git.sh"
source "$SCRIPT_DIR/lib/nvidia.sh"

# ============================================
# Interactive Menu
# ============================================

# Global variables
TOTAL_INSTALLED=0
LOG_FILE="$HOME/arch_setup_$(date +%Y%m%d_%H%M%S).log"

show_menu() {
    clear
    print_header
    echo "1)  Run complete setup"
    echo "2)  Update system"
    echo "3)  Setup yay (AUR helper)"
    echo "4)  Setup directories"
    echo "5)  Install Git"
    echo "6)  Install text editors (Zed, Sublime)"
    echo "7)  Install security tools"
    echo "8)  Install Python environment"
    echo "9)  Install AUR applications"
    echo "10) Install Node.js tools"
    echo "11) Install Docker"
    echo "12) Install DevOps tools (Prometheus, Terraform, AWS CLI, Azure CLI, Ansible, kubectl, Minikube, eksctl)"
    echo "13) Install browsers"
    echo "14) Install fonts"
    echo "15) Install system tools"
    echo "16) Install utility tools"
    echo "17) Install Flatpak applications"
    echo "18) Install databases"
    echo "19) Install Homebrew"
    echo "20) Install Homebrew packages"
    echo "21) Install Zsh"
    echo "22) Configure Git"
    echo "23) Install Bun"
    echo "24) Install Nvidia drivers"
    echo "25) View installation log"
    echo "0)  Exit"
    echo ""
    echo -n "Choose an option: "
}

run_full_setup() {
    print_header
    echo -e "${YELLOW}Starting complete setup...${NC}\n"

    update_system
    setup_yay
    setup_directories
    install_git
    install_editors
    install_security_tools
    install_utility_tools
    install_devops_tools
    install_python_env
    install_aur_apps
    install_nodejs_tools
    install_docker
    install_browsers
    install_fonts
    install_system_tools
    install_flatpak_apps
    install_databases
    install_homebrew
    install_brew_packages
    install_zsh
    configure_git
    install_bun
    install_nvidia_drivers

    echo ""
    print_section "Setup Summary"
    echo -e "${GREEN}Total operations completed:${NC} $TOTAL_INSTALLED"
    echo -e "${GREEN}Log file:${NC} $LOG_FILE"
    echo ""
    print_success "Setup complete!"
    print_warning "Please log out and back in for all changes to take effect"
    print_warning "Run 'chsh -s \$(which zsh)' to set Zsh as default shell"
    echo ""

    log_action "Complete setup finished - Total operations: $TOTAL_INSTALLED"
}

# ============================================
# Main Loop
# ============================================

main() {
    if [ ! -f /etc/arch-release ]; then
        print_error "This script is for Arch Linux (and Arch-based distros) only!"
        exit 1
    fi

    touch "$LOG_FILE"
    log_action "Starting setup script"

    while true; do
        show_menu
        read -r option

        case $option in
            1) run_full_setup ;;
            2) update_system ;;
            3) setup_yay ;;
            4) setup_directories ;;
            5) install_git ;;
            6) install_editors ;;
            7) install_security_tools ;;
            8) install_python_env ;;
            9) install_aur_apps ;;
            10) install_nodejs_tools ;;
            11) install_docker ;;
            12) install_devops_tools ;;
            13) install_browsers ;;
            14) install_fonts ;;
            15) install_system_tools ;;
            16) install_utility_tools ;;
            17) install_flatpak_apps ;;
            18) install_databases ;;
            19) install_homebrew ;;
            20) install_brew_packages ;;
            21) install_zsh ;;
            22) configure_git ;;
            23) install_bun ;;
            24) install_nvidia_drivers ;;
            25) cat "$LOG_FILE" | less ;;
            0)
                print_success "Goodbye!"
                log_action "Script finished"
                exit 0
                ;;
            *)
                print_error "Invalid option!"
                ;;
        esac

        echo ""
        read -p "Press ENTER to continue..."
    done
}

main
