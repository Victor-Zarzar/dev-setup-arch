#!/bin/bash

# ============================================
# Nvidia Driver Installation Functions
# ============================================

_has_nvidia_gpu() {
    lspci 2>/dev/null | grep -qi nvidia
}

_using_stock_kernel() {
    uname -r | grep -q -- '-arch'
}

install_nvidia_drivers() {
    print_section "Installing Nvidia Drivers"

    if ! _has_nvidia_gpu; then
        print_warning "No Nvidia GPU detected via lspci. Skipping."
        if ! confirm_action "Install Nvidia drivers anyway?"; then
            return 0
        fi
    fi

    if command_exists nvidia-smi; then
        print_info "Nvidia drivers already installed ($(nvidia-smi --query-gpu=driver_version --format=csv,noheader 2>/dev/null))"
        return 0
    fi

    echo "Select the Nvidia driver type:"
    echo "  1) Proprietary (nvidia, nvidia-utils, nvidia-settings) - stock Arch kernel"
    echo "  2) Proprietary DKMS (nvidia-dkms) - custom/LTS kernels"
    echo "  3) Open-source kernel modules (nvidia-open-dkms) - Turing+ GPUs"
    echo "  0) Cancel"
    echo -n "Option: "
    read -r nv_choice

    case "$nv_choice" in
        1)
            pacman_install "nvidia" "Nvidia proprietary driver"
            pacman_install "nvidia-utils" "Nvidia utils"
            pacman_install "nvidia-settings" "Nvidia settings"
            ;;
        2)
            pacman_install "nvidia-dkms" "Nvidia DKMS driver"
            pacman_install "nvidia-utils" "Nvidia utils"
            pacman_install "nvidia-settings" "Nvidia settings"
            pacman_install "linux-headers" "Linux headers (required for DKMS)"
            ;;
        3)
            pacman_install "nvidia-open-dkms" "Nvidia open-source DKMS driver"
            pacman_install "nvidia-utils" "Nvidia utils"
            pacman_install "nvidia-settings" "Nvidia settings"
            pacman_install "linux-headers" "Linux headers (required for DKMS)"
            ;;
        0)
            print_info "Nvidia driver installation cancelled"
            return 0
            ;;
        *)
            print_error "Invalid option"
            return 1
            ;;
    esac

    print_info "Enabling early KMS (mkinitcpio) if not already configured..."
    if [ -f /etc/mkinitcpio.conf ] && ! grep -q "nvidia" /etc/mkinitcpio.conf; then
        print_warning "Consider adding 'nvidia nvidia_modeset nvidia_uvm nvidia_drm' to MODULES in /etc/mkinitcpio.conf, then run: sudo mkinitcpio -P"
    fi

    print_warning "Reboot required for Nvidia drivers to take effect"
    log_action "Nvidia drivers installed (option $nv_choice)"
}
