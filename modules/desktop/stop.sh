#!/bin/bash

# ===========================================================
# WSL GUI Pack - Desktop Environment Stop Module
# ===========================================================

# Function to stop the desktop environment
stop_desktop_environment() {
    clear
    print_section_header "Stop Desktop Environment"
    
    # Load configuration
    load_config
    
    # Check if desktop environment is configured
    if [ ! -f "$DESKTOP_CONFIG" ]; then
        print_error "No desktop environment configuration found."
        wait_for_keypress
        return 1
    fi
    
    # Source desktop configuration
    source "$DESKTOP_CONFIG"
    
    if [ "$installed" != "true" ]; then
        print_error "No desktop environment installed."
        wait_for_keypress
        return 1
    fi
    
    # Check if desktop environment is running
    print_info "Checking for running desktop environment..."
    
    local running=false
    case "$current" in
        xfce)
            if pgrep -f xfce4-session > /dev/null; then
                running=true
            fi
            ;;
        mate)
            if pgrep -f mate-session > /dev/null; then
                running=true
            fi
            ;;
        kde)
            if pgrep -f "startplasma-x11|plasmashell" > /dev/null; then
                running=true
            fi
            ;;
        gnome)
            if pgrep -f "gnome-session|gnome-shell" > /dev/null; then
                running=true
            fi
            ;;
        *)
            print_error "Unknown desktop environment: $current"
            wait_for_keypress
            return 1
            ;;
    esac
    
    if [ "$running" = false ]; then
        print_warning "No running desktop environment detected."
        wait_for_keypress
        return 1
    fi
    
    # Stop desktop environment based on configuration
    print_info "Stopping $current desktop environment..."
    
    case "$current" in
        xfce)
            pkill -f xfce4-session
            ;;
        mate)
            pkill -f mate-session
            ;;
        kde)
            pkill -f "startplasma-x11|kwin|plasmashell"
            ;;
        gnome)
            pkill -f "gnome-session|gnome-shell"
            ;;
    esac
    
    # Give some time for processes to terminate
    sleep 2
    
    # Force kill if necessary
    case "$current" in
        xfce)
            if pgrep -f xfce4-session > /dev/null; then
                print_warning "Forcing termination of XFCE processes..."
                pkill -9 -f xfce4
            fi
            ;;
        mate)
            if pgrep -f mate-session > /dev/null; then
                print_warning "Forcing termination of MATE processes..."
                pkill -9 -f mate
            fi
            ;;
        kde)
            if pgrep -f "startplasma-x11|plasmashell" > /dev/null; then
                print_warning "Forcing termination of KDE processes..."
                pkill -9 -f "plasma|kwin"
            fi
            ;;
        gnome)
            if pgrep -f "gnome-session|gnome-shell" > /dev/null; then
                print_warning "Forcing termination of GNOME processes..."
                pkill -9 -f gnome
            fi
            ;;
    esac
    
    # Check if desktop was stopped successfully
    sleep 2
    running=false
    
    case "$current" in
        xfce)
            if pgrep -f xfce4-session > /dev/null; then
                running=true
            fi
            ;;
        mate)
            if pgrep -f mate-session > /dev/null; then
                running=true
            fi
            ;;
        kde)
            if pgrep -f "startplasma-x11|plasmashell" > /dev/null; then
                running=true
            fi
            ;;
        gnome)
            if pgrep -f "gnome-session|gnome-shell" > /dev/null; then
                running=true
            fi
            ;;
    esac
    
    if [ "$running" = true ]; then
        print_error "Failed to stop all desktop processes."
        print_info "Some processes may still be running."
    else
        print_success "Desktop environment stopped successfully."
    fi
    
    # Cleanup X resources
    if check_x_server; then
        print_info "Cleaning up X resources..."
        xset q > /dev/null 2>&1
    fi
    
    wait_for_keypress
    return 0
}