#!/bin/bash

# ============================================
# Flatpak Package Installation Functions
# ============================================

install_flatpak_apps() {
    print_section "Installing Flatpak Applications"

    if ! command_exists flatpak; then
        print_warning "Flatpak is not installed. Installing it now..."
        pacman_install "flatpak" "Flatpak"
    fi

    print_info "Adding Flathub repository (system-wide)..."
    if flatpak remote-list --system | grep -q "flathub"; then
        print_info "Flathub repository already added (system)"
    else
        sudo flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo >> "$LOG_FILE" 2>&1
        print_success "Flathub repository added (system)"
    fi

    local apps=(
        "org.libreoffice.LibreOffice:LibreOffice"
        "io.github.thetumultuousunicornofdarkness.cpu-x:CPU-X"
        "com.github.jeromerobert.pdfarranger:PDF Arranger"
        "org.gnome.Boxes:Boxes"
    )

    for app in "${apps[@]}"; do
        IFS=':' read -r pkg desc <<< "$app"
        if flatpak list --system | grep -q "$pkg"; then
            print_info "$desc already installed"
        else
            # --system and --noninteractive avoid the "found in multiple
            # installations (system/user)" ambiguity prompt seen when both
            # scopes have a flathub remote registered.
            run_command "sudo flatpak install -y --noninteractive --system flathub $pkg" "$desc"
        fi
    done
}
