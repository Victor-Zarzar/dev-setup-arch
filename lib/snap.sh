#!/bin/bash

# ============================================
# Snap Installation Functions
# ============================================
# Some apps either don't have a maintained AUR binary package (Trello) or
# their AUR package is broken/unreliable (WhatsApp), so they're installed
# via snap instead. ZAP (zaproxy) is also distributed here since its
# upstream-recommended install path on Linux is the classic snap.

setup_snapd() {
    print_section "Setting Up snapd"

    if command_exists snap; then
        print_info "snapd already installed"
    else
        if ! command_exists yay; then
            print_error "yay is not installed. Run option 3 (Setup yay) first."
            return 1
        fi

        yay_install "snapd" "snapd"

        if ! systemctl is-enabled snapd.socket &> /dev/null; then
            run_command "sudo systemctl enable --now snapd.socket" "snapd socket enabled"
        else
            print_info "snapd.socket already enabled"
        fi

        if [ ! -L /snap ]; then
            run_command "sudo ln -s /var/lib/snapd/snap /snap" "Classic snap support symlink created (/snap)"
        else
            print_info "/snap symlink already present"
        fi
    fi

    # snapd.socket needs a moment (and sometimes a new shell session) to be
    # fully ready right after first install; subsequent snap installs
    # calling this function first will just see it already up.
}

# Install a snap package if not already installed
# Usage: snap_install <pkg> <desc> [classic]
snap_install() {
    local pkg="$1"
    local desc="${2:-$1}"
    local classic="$3"

    if ! command_exists snap; then
        print_error "snap is not installed. Run setup_snapd first."
        return 1
    fi

    if snap list "$pkg" &> /dev/null; then
        print_info "$desc already installed"
        return 0
    fi

    if [ "$classic" = "classic" ]; then
        run_command "sudo snap install $pkg --classic" "$desc installed"
    else
        run_command "sudo snap install $pkg" "$desc installed"
    fi
}

install_snap_apps() {
    print_section "Installing Snap Applications"

    setup_snapd || return 1

    local apps=(
        "trello-desktop:Trello"
        "whatsapp-linux-desktop:WhatsApp"
    )

    for app in "${apps[@]}"; do
        IFS=':' read -r pkg desc <<< "$app"
        snap_install "$pkg" "$desc"
    done

    # zaproxy needs classic confinement (it needs broader filesystem access
    # than strict-confinement snaps allow).
    snap_install "zaproxy" "OWASP ZAP" "classic"
}
