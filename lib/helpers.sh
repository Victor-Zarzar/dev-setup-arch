#!/bin/bash

# ============================================
# Helper Functions (Maintenance)
# ============================================

print_header() {
    local free_space
    free_space=$(get_disk_usage)
    local current_date
    current_date=$(date '+%Y-%m-%d %H:%M:%S')
    local username
    username=$(whoami)
    local os_version
    os_version=$(get_os_version)
    local kernel_version
    kernel_version=$(uname -r)

    echo -e "${CYAN}"
    echo '  ███████╗███████╗████████╗██╗   ██╗██████╗ '
    echo '  ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗'
    echo '  ███████╗█████╗     ██║   ██║   ██║██████╔╝'
    echo '  ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ '
    echo '  ███████║███████╗   ██║   ╚██████╔╝██║     '
    echo '  ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     '
    echo ''
    echo '   █████╗ ██████╗  ██████╗██╗  ██╗'
    echo '  ██╔══██╗██╔══██╗██╔════╝██║  ██║'
    echo '  ███████║██████╔╝██║     ███████║'
    echo '  ██╔══██║██╔══██╗██║     ██╔══██║'
    echo '  ██║  ██║██║  ██║╚██████╗██║  ██║'
    echo '  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝'
    echo ''
    echo '██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗'
    echo '██║     ██║████╗  ██║██║   ██║╚██╗██╔╝'
    echo '██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ '
    echo '██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ '
    echo '███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗'
    echo '╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝'
    echo -e "${NC}"
    echo -e "  ${CYAN}──────────────────────────────────────────────────────────${NC}"
    echo -e "  ${CYAN}✦ User:${NC}        $username"
    echo -e "  ${CYAN}✦ System:${NC}      $os_version"
    echo -e "  ${CYAN}✦ Kernel:${NC}      $kernel_version"
    echo -e "  ${CYAN}✦ Free Space:${NC}  $free_space"
    echo -e "  ${CYAN}✦ Date:${NC}        $current_date"
    echo -e "  ${CYAN}──────────────────────────────────────────────────────────${NC}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${PURPLE}$1${NC}"
    echo "────────────────────────────────────────"
}

print_success() {
    echo -e "${GREEN}SUCCESS:${NC} $1"
}

print_error() {
    echo -e "${RED}ERROR:${NC} $1"
}

print_info() {
    echo -e "${BLUE}INFO:${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}WARNING:${NC} $1"
}

log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

get_folder_size() {
    local path="$1"
    if [ -d "$path" ]; then
        du -sk "$path" 2>/dev/null | awk '{print $1}'
    else
        echo "0"
    fi
}

format_bytes() {
    local bytes=$1
    if [ "$bytes" -ge 1073741824 ]; then
        echo "$(echo "scale=2; $bytes/1073741824" | bc) GB"
    elif [ "$bytes" -ge 1048576 ]; then
        echo "$(echo "scale=2; $bytes/1048576" | bc) MB"
    elif [ "$bytes" -ge 1024 ]; then
        echo "$(echo "scale=2; $bytes/1024" | bc) KB"
    else
        echo "${bytes} B"
    fi
}

show_progress() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))

    printf "\r${CYAN}["
    printf "%${filled}s" | tr ' ' '='
    printf "%${empty}s" | tr ' ' ' '
    printf "] %d%%${NC}" $percentage
}

get_disk_usage() {
    df -h / | tail -1 | awk '{print $4}'
}

# ============================================
# Arch Linux OS version detection
# ============================================
get_os_version() {
    if [ -f /etc/os-release ]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        echo "${PRETTY_NAME:-$NAME $VERSION}"
    elif command -v lsb_release >/dev/null 2>&1; then
        lsb_release -ds
    else
        echo "Unknown Arch-based system"
    fi
}

# ============================================
# Command Execution Helper
# ============================================

run_command() {
    local cmd="$1"
    local msg="$2"

    echo -e "${YELLOW}→${NC} Executing: $cmd"
    if eval "$cmd" >> "$LOG_FILE" 2>&1; then
        print_success "$msg"
        ((TOTAL_INSTALLED++))
    else
        print_error "Failed: $msg"
    fi
}
