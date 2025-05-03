#!/bin/bash

# ===========================================================
# WSL GUI Pack - System Operations Module
# ===========================================================

# Check if running in WSL environment
check_wsl() {
    if ! grep -q "Microsoft" /proc/version &> /dev/null && ! grep -q "microsoft" /proc/version &> /dev/null; then
        print_error "This script must be run within WSL (Windows Subsystem for Linux)"
        exit 1
    fi
    
    # Determine WSL version
    WSL_VERSION=$(get_wsl_version)
    log "Running in $WSL_VERSION environment" "INFO"
    
    # Store Windows username for later use
    WINDOWS_USER=$(get_windows_username)
    WINDOWS_USER_DIR=$(get_windows_user_dir)
    WINDOWS_IP=$(get_windows_ip)
    
    log "Windows User: $WINDOWS_USER" "INFO"
    log "Windows IP: $WINDOWS_IP" "INFO"
}

# Check dependencies and install if missing
check_dependencies() {
    print_section_header "Checking Dependencies"
    
    local missing_deps=()
    local deps=("wget" "curl" "xset" "dialog" "bc" "jq")
    
    for dep in "${deps[@]}"; do
        if ! command_exists "$dep"; then
            missing_deps+=("$dep")
            print_warning "$dep is not installed"
        else
            print_success "$dep is installed"
        fi
    done
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_info "Installing missing dependencies..."
        
        if confirm "Do you want to install the missing dependencies?"; then
            # Determine package manager
            if command_exists apt-get; then
                sudo apt-get update -qq && sudo apt-get install -y "${missing_deps[@]}" &
                show_progress $! "Installing dependencies"
                print_success "Dependencies installed successfully"
            elif command_exists yum; then
                sudo yum install -y "${missing_deps[@]}" &
                show_progress $! "Installing dependencies"
                print_success "Dependencies installed successfully"
            elif command_exists dnf; then
                sudo dnf install -y "${missing_deps[@]}" &
                show_progress $! "Installing dependencies"
                print_success "Dependencies installed successfully"
            elif command_exists pacman; then
                sudo pacman -S --noconfirm "${missing_deps[@]}" &
                show_progress $! "Installing dependencies"
                print_success "Dependencies installed successfully"
            else
                print_error "Unsupported package manager. Please install the following packages manually: ${missing_deps[*]}"
                return 1
            fi
        else
            print_warning "Some dependencies are missing. Functionality may be limited."
        fi
    fi
    
    return 0
}

# Function to setup .bashrc for X11 forwarding
setup_x11_env() {
    print_section_header "Setting up X11 Environment"
    
    local display_config="export DISPLAY=$WINDOWS_IP:0"
    local libgl_config="export LIBGL_ALWAYS_INDIRECT=1"
    
    # Add configuration to .bashrc if not already present
    if ! grep -q "DISPLAY=$WINDOWS_IP:0" "$HOME/.bashrc"; then
        print_info "Adding X11 configuration to .bashrc"
        
        # Backup .bashrc first
        backup_file "$HOME/.bashrc"
        
        # Add configuration lines
        cat >> "$HOME/.bashrc" << EOF

# WSL GUI Pack - X11 Configuration
$display_config
$libgl_config
EOF
        
        print_success "Added X11 configuration to .bashrc"
        
        # Export variables for current session
        export DISPLAY=$WINDOWS_IP:0
        export LIBGL_ALWAYS_INDIRECT=1
    else
        print_info "X11 configuration already exists in .bashrc"
    fi
    
    # Create Xresources file if it doesn't exist
    if [ ! -f "$HOME/.Xresources" ]; then
        cat > "$HOME/.Xresources" << EOF
! WSL GUI Pack - X resources configuration
! DPI Setting (96 is default)
Xft.dpi: 96
Xft.antialias: true
Xft.hinting: true
Xft.rgba: rgb
Xft.autohint: false
Xft.hintstyle: hintslight
Xft.lcdfilter: lcddefault
EOF
        print_success "Created .Xresources file"
    fi
}

# Function to check for and kill running X clients
kill_x_clients() {
    print_section_header "Checking for Running X Clients"
    
    # List of common X client processes
    local x_clients=("xfce4-session" "mate-session" "startkde" "gnome-session" "startlxde")
    local killed=false
    
    for client in "${x_clients[@]}"; do
        if pgrep -f "$client" > /dev/null; then
            print_warning "Found running $client process"
            
            if confirm "Do you want to kill the running $client process?"; then
                pkill -f "$client"
                sleep 1
                
                # Force kill if still running
                if pgrep -f "$client" > /dev/null; then
                    pkill -9 -f "$client"
                fi
                
                print_success "Killed $client process"
                killed=true
            else
                print_warning "Process not killed. This may cause conflicts."
            fi
        fi
    done
    
    if [ "$killed" = true ]; then
        # Give processes time to clean up
        sleep 2
    else
        print_info "No running X clients found"
    fi
}

# Function to add script to path
add_to_path() {
    # Check if already in PATH
    if echo "$PATH" | grep -q "$SCRIPT_DIR"; then
        print_info "WSL GUI Pack is already in PATH"
        return 0
    fi
    
    # Add to .bashrc
    if ! grep -q "wsl-gui-pack" "$HOME/.bashrc"; then
        print_info "Adding WSL GUI Pack to PATH"
        
        # Backup .bashrc first
        backup_file "$HOME/.bashrc"
        
        # Add PATH export
        cat >> "$HOME/.bashrc" << EOF

# WSL GUI Pack - Add to PATH
export PATH="\$PATH:$SCRIPT_DIR"
EOF
        
        print_success "Added WSL GUI Pack to PATH"
        
        # Export for current session
        export PATH="$PATH:$SCRIPT_DIR"
        
        # Create symlink in /usr/local/bin for system-wide access
        if confirm "Do you want to create a system-wide symlink for wsl-gui-pack?"; then
            sudo ln -sf "$SCRIPT_DIR/wsl-gui-pack.sh" /usr/local/bin/wsl-gui-pack
            print_success "Created symlink in /usr/local/bin"
        fi
    else
        print_info "WSL GUI Pack is already configured in .bashrc"
    fi
}

# Function to check for updates
check_for_updates() {
    print_section_header "Checking for Updates"
    
    # This is a placeholder for actual update checking logic
    # In a real implementation, this would check a remote repository or server
    
    print_info "Current version: $VERSION"
    print_info "Checking for updates..."
    
    # Simulate update check
    echo "No updates available at this time."
    
    wait_for_keypress
}

# Function to get running processes
get_running_processes() {
    local filter=${1:-""}
    
    if [ -z "$filter" ]; then
        ps aux
    else
        ps aux | grep "$filter" | grep -v grep
    fi
}

# Function to monitor system resources
monitor_system_resources() {
    local interval=${1:-5}
    local iterations=${2:-0}  # 0 means infinite
    
    clear
    print_section_header "System Resource Monitor"
    
    echo -e "${BOLD}Press Ctrl+C to exit${RESET}"
    echo
    
    local count=0
    while [ $iterations -eq 0 ] || [ $count -lt $iterations ]; do
        clear
        print_section_header "System Resource Monitor"
        echo -e "${BOLD}Press Ctrl+C to exit${RESET}"
        echo
        
        echo -e "${BOLD}Date & Time:${RESET} $(date)"
        echo -e "${BOLD}Uptime:${RESET} $(uptime -p)"
        echo
        
        echo -e "${BOLD}CPU Usage:${RESET}"
        top -bn1 | head -n 12 | tail -n 5
        echo
        
        echo -e "${BOLD}Memory Usage:${RESET}"
        free -h
        echo
        
        echo -e "${BOLD}Disk Usage:${RESET}"
        df -h /
        echo
        
        echo -e "${BOLD}GUI Processes:${RESET}"
        ps aux | grep -E 'X|x11|xorg|xfce|mate|kde|gnome' | grep -v grep
        
        sleep $interval
        count=$((count + 1))
    done
}