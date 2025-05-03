#!/bin/bash

# ===========================================================
# WSL GUI Pack - Desktop Environment Start Module
# ===========================================================

# Function to start the desktop environment
start_desktop_environment() {
    clear
    print_section_header "Start Desktop Environment"
    
    # Load configuration
    load_config
    
    # Check if desktop environment is installed
    if [ ! -f "$DESKTOP_CONFIG" ]; then
        print_error "No desktop environment configuration found."
        print_info "Please run the installation first."
        wait_for_keypress
        return 1
    fi
    
    # Source desktop configuration
    source "$DESKTOP_CONFIG"
    
    if [ "$installed" != "true" ]; then
        print_error "No desktop environment installed."
        
        if confirm "Do you want to install a desktop environment now?"; then
            source "$SCRIPT_DIR/modules/install/install.sh"
            install_desktop_environment
            
            # Reload desktop configuration
            source "$DESKTOP_CONFIG"
            
            if [ "$installed" != "true" ]; then
                print_error "Desktop environment installation failed."
                wait_for_keypress
                return 1
            fi
        else
            wait_for_keypress
            return 1
        fi
    fi
    
    # Check if X server is running
    print_info "Checking if X server is running..."
    if ! check_x_server; then
        print_warning "X server does not appear to be running."
        
        if confirm "Do you want to start the X server now?"; then
            # Start X server based on config
            case "$X_SERVER" in
                vcxsrv)
                    "$SCRIPTS_DIR/x_server/start-vcxsrv.sh"
                    ;;
                x410)
                    "$SCRIPTS_DIR/x_server/start-x410.sh"
                    ;;
                *)
                    print_error "Unknown X server: $X_SERVER"
                    print_info "Please start your X server manually."
                    ;;
            esac
            
            # Wait for X server to start
            print_info "Waiting for X server to start..."
            sleep 3
            
            # Check again
            if ! check_x_server; then
                print_error "Failed to connect to X server."
                print_info "Please start your X server manually and try again."
                wait_for_keypress
                return 1
            else
                print_success "X server is running."
            fi
        else
            print_error "Cannot start desktop environment without X server."
            wait_for_keypress
            return 1
        fi
    else
        print_success "X server is running."
    fi
    
    # Kill any existing X clients
    kill_x_clients
    
    # Set up environment
    export DISPLAY=$WINDOWS_IP:0
    export LIBGL_ALWAYS_INDIRECT=1
    
    # Start desktop environment based on configuration
    print_info "Starting $current desktop environment..."
    
    case "$current" in
        xfce)
            startxfce4 &
            ;;
        mate)
            mate-session &
            ;;
        kde)
            startplasma-x11 &
            ;;
        gnome)
            gnome-session &
            ;;
        *)
            print_error "Unknown desktop environment: $current"
            wait_for_keypress
            return 1
            ;;
    esac
    
    # Check if desktop started successfully
    sleep 5
    
    case "$current" in
        xfce)
            if pgrep -f xfce4-session > /dev/null; then
                print_success "XFCE desktop started successfully."
            else
                print_error "Failed to start XFCE desktop."
                return 1
            fi
            ;;
        mate)
            if pgrep -f mate-session > /dev/null; then
                print_success "MATE desktop started successfully."
            else
                print_error "Failed to start MATE desktop."
                return 1
            fi
            ;;
        kde)
            if pgrep -f "startplasma-x11|plasmashell" > /dev/null; then
                print_success "KDE Plasma desktop started successfully."
            else
                print_error "Failed to start KDE Plasma desktop."
                return 1
            fi
            ;;
        gnome)
            if pgrep -f "gnome-session|gnome-shell" > /dev/null; then
                print_success "GNOME desktop started successfully."
            else
                print_error "Failed to start GNOME desktop."
                return 1
            fi
            ;;
    esac
    
    print_info "Desktop environment is now running."
    print_info "To stop it, use the 'wsl-gui-pack stop' command."
    
    # Detach from console to allow desktop to run in background
    disown
    
    # Return to allow user to continue using terminal
    return 0
}