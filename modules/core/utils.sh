#!/bin/bash

# ===========================================================
# WSL GUI Pack - Utility Functions Module
# ===========================================================

# Function to log messages
log() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local level=${2:-"INFO"}
    echo "[$timestamp] [$level] $1" >> "$LOGS_DIR/wsl-gui-pack.log"
}

# Function to print success message and log it
print_success() {
    echo -e "${GREEN}✓ $1${RESET}"
    log "$1" "SUCCESS"
}

# Function to print error message and log it
print_error() {
    echo -e "${RED}✗ $1${RESET}"
    log "$1" "ERROR"
}

# Function to print info message and log it
print_info() {
    echo -e "${BLUE}ℹ $1${RESET}"
    log "$1" "INFO"
}

# Function to print warning message and log it
print_warning() {
    echo -e "${YELLOW}⚠ $1${RESET}"
    log "$1" "WARNING"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to check if a package is installed
package_installed() {
    dpkg -l "$1" &> /dev/null
}

# Function to backup a file before modifying it
backup_file() {
    local file=$1
    local backup="$file.bak.$(date +%Y%m%d%H%M%S)"
    
    if [ -f "$file" ]; then
        cp "$file" "$backup"
        log "Backed up $file to $backup" "INFO"
        return 0
    else
        log "Could not backup $file, file does not exist" "WARNING"
        return 1
    fi
}

# Function to restore a file from backup
restore_file() {
    local file=$1
    local backup=$(ls -t "$file.bak."* 2>/dev/null | head -1)
    
    if [ -n "$backup" ] && [ -f "$backup" ]; then
        cp "$backup" "$file"
        log "Restored $file from $backup" "INFO"
        return 0
    else
        log "Could not restore $file, no backup found" "ERROR"
        return 1
    fi
}

# Function to check WSL version
get_wsl_version() {
    if grep -q "microsoft-standard" /proc/version 2>/dev/null; then
        echo "WSL2"
    elif grep -q "Microsoft" /proc/version 2>/dev/null; then
        echo "WSL1"
    else
        echo "Not WSL"
    fi
}

# Function to get Windows username
get_windows_username() {
    powershell.exe '$env:USERNAME' 2>/dev/null | tr -d '\r'
}

# Function to get Windows user directory
get_windows_user_dir() {
    powershell.exe '$env:USERPROFILE' 2>/dev/null | tr -d '\r'
}

# Function to get IP address of Windows host
get_windows_ip() {
    cat /etc/resolv.conf | grep nameserver | awk '{print $2}'
}

# Function to check if X server is running
check_x_server() {
    # Try to connect to X server to see if it's running
    xset -q &>/dev/null
    return $?
}

# Function to open Windows browser to a URL
open_windows_browser() {
    local url=$1
    powershell.exe "Start-Process '$url'"
}

# Function to check Linux distribution
get_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif type lsb_release >/dev/null 2>&1; then
        lsb_release -si | tr '[:upper:]' '[:lower:]'
    else
        echo "unknown"
    fi
}

# Function to get distro version
get_distro_version() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$VERSION_ID"
    elif type lsb_release >/dev/null 2>&1; then
        lsb_release -sr
    else
        echo "unknown"
    fi
}

# Function to add a line to a file if it doesn't exist
add_line_if_not_exists() {
    local line=$1
    local file=$2
    
    if [ ! -f "$file" ]; then
        echo "$line" > "$file"
        return
    fi
    
    grep -qF -- "$line" "$file" || echo "$line" >> "$file"
}

# Function to get system resources information
get_system_resources() {
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    local mem_info=$(free -m | grep Mem)
    local mem_total=$(echo $mem_info | awk '{print $2}')
    local mem_used=$(echo $mem_info | awk '{print $3}')
    local mem_used_percent=$(echo "scale=2; $mem_used * 100 / $mem_total" | bc)
    local disk_info=$(df -h / | grep -v Filesystem)
    local disk_total=$(echo $disk_info | awk '{print $2}')
    local disk_used=$(echo $disk_info | awk '{print $3}')
    local disk_used_percent=$(echo $disk_info | awk '{print $5}')
    
    echo "CPU Usage: ${cpu_usage}%"
    echo "Memory Usage: ${mem_used}MB / ${mem_total}MB (${mem_used_percent}%)"
    echo "Disk Usage: ${disk_used} / ${disk_total} (${disk_used_percent})"
}

# Function to check if a port is in use
check_port() {
    local port=$1
    netstat -tuln | grep -q ":$port "
    return $?
}

# Function to find a free port starting from a base port
find_free_port() {
    local base_port=${1:-8000}
    local port=$base_port
    
    while check_port $port; do
        port=$((port + 1))
    done
    
    echo $port
}

# Create a simple menu with options and return the selected option
create_menu() {
    local title=$1
    shift
    local options=("$@")
    
    echo -e "${BOLD}$title${RESET}"
    echo
    
    for i in "${!options[@]}"; do
        echo -e "${CYAN}$((i+1))${RESET}) ${options[$i]}"
    done
    
    echo
    read -p "Enter your choice [1-${#options[@]}]: " choice
    
    if [[ $choice -ge 1 && $choice -le ${#options[@]} ]]; then
        echo $((choice-1))  # Return zero-based index
    else
        return 255  # Invalid choice
    fi
}

# Wait for keypress with custom message
wait_for_keypress() {
    local message=${1:-"Press any key to continue..."}
    echo -e "${YELLOW}$message${RESET}"
    read -n 1
}