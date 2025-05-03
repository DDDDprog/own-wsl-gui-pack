#!/bin/bash

# ===========================================================
# WSL GUI Pack - Installation Module
# ===========================================================

# Function to run the installation process
run_installation() {
    clear
    print_section_header "Installation Wizard"
    
    print_info "This wizard will help you install all necessary components for WSL GUI Pack."
    print_info "The installation process includes several steps:"
    echo "  1. Checking system requirements"
    echo "  2. Installing dependencies"
    echo "  3. Setting up X Server configuration"
    echo "  4. Installing desktop environment (optional)"
    echo "  5. Configuring audio (optional)"
    echo "  6. Setting up clipboard sharing (optional)"
    echo
    
    if ! confirm "Do you want to proceed with the installation?"; then
        print_info "Installation cancelled."
        return 1
    fi
    
    # Check if running in WSL
    check_wsl
    
    # Check and install dependencies
    check_dependencies
    
    # Setup X11 environment
    setup_x11_env
    
    # Install X server
    install_x_server
    
    # Offer to install desktop environment
    install_desktop_environment
    
    # Setup audio
    setup_audio
    
    # Setup clipboard
    setup_clipboard
    
    # Add script to path
    add_to_path
    
    # First-time setup complete
    print_section_header "Installation Complete"
    print_success "WSL GUI Pack has been successfully installed!"
    print_info "You can now start using it by running: wsl-gui-pack"
    
    # Set first_run to false in config
    FIRST_RUN=false
    save_config
    
    wait_for_keypress
    return 0
}

# Function to install X server components
install_x_server() {
    print_section_header "X Server Setup"
    
    print_info "WSL requires an X server running on Windows to display GUI applications."
    print_info "Popular options include:"
    echo "  1. VcXsrv (Free, open-source)"
    echo "  2. X410 (Paid, available from Microsoft Store)"
    echo "  3. Xming (Free, basic functionality)"
    echo
    
    # Create directory for X server scripts
    mkdir -p "$SCRIPTS_DIR/x_server"
    
    # Create VcXsrv starter script
    cat > "$SCRIPTS_DIR/x_server/start-vcxsrv.sh" << 'EOF'
#!/bin/bash
# Script to start VcXsrv on Windows
powershell.exe "Start-Process 'C:\Program Files\VcXsrv\vcxsrv.exe' -ArgumentList '-multiwindow -clipboard -wgl -ac'"
EOF
    chmod +x "$SCRIPTS_DIR/x_server/start-vcxsrv.sh"
    
    # Create X410 starter script
    cat > "$SCRIPTS_DIR/x_server/start-x410.sh" << 'EOF'
#!/bin/bash
# Script to start X410 on Windows
powershell.exe "Start-Process x410://"
EOF
    chmod +x "$SCRIPTS_DIR/x_server/start-x410.sh"
    
    # Create testing script
    cat > "$SCRIPTS_DIR/x_server/test-x11.sh" << 'EOF'
#!/bin/bash
# Script to test X11 connection
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
export LIBGL_ALWAYS_INDIRECT=1

echo "Testing X11 connection to $DISPLAY..."
if xset q &>/dev/null; then
    echo "Success! X11 connection established."
    
    # Try to run xeyes if available
    if command -v xeyes &>/dev/null; then
        echo "Running xeyes as a test application..."
        xeyes &
    elif command -v xclock &>/dev/null; then
        echo "Running xclock as a test application..."
        xclock &
    else
        echo "No test applications available. Please install x11-apps package."
    fi
else
    echo "Failed to connect to X server. Please make sure X server is running on Windows."
fi
EOF
    chmod +x "$SCRIPTS_DIR/x_server/test-x11.sh"
    
    print_info "X Server setup scripts have been created in $SCRIPTS_DIR/x_server/"
    print_info "Now you need to install an X Server on Windows."
    
    # Ask user if they want to open X Server download page
    if confirm "Do you want to open the VcXsrv download page in your browser?"; then
        powershell.exe "Start-Process 'https://sourceforge.net/projects/vcxsrv/'"
    fi
    
    # Set the default X server in config
    X_SERVER="vcxsrv"
    save_config
    
    print_info "After installing the X Server on Windows, you can test the connection by running:"
    echo "  $SCRIPTS_DIR/x_server/test-x11.sh"
    echo
    
    wait_for_keypress "Press any key to continue installation..."
    return 0
}

# Function to install desktop environment
install_desktop_environment() {
    print_section_header "Desktop Environment Installation"
    
    print_info "You can install a desktop environment for a complete GUI experience."
    print_info "Available options:"
    echo "  1. XFCE    (Lightweight, recommended for WSL)"
    echo "  2. MATE    (Modern fork of GNOME 2)"
    echo "  3. KDE Plasma (Feature-rich, modern interface)"
    echo "  4. GNOME   (Full-featured, resource intensive)"
    echo "  5. None    (Skip desktop environment installation)"
    echo
    
    read -p "Enter your choice [1-5]: " de_choice
    
    # Create directory for desktop environment scripts
    mkdir -p "$SCRIPTS_DIR/desktop"
    
    case $de_choice in
        1)
            print_info "Installing XFCE Desktop Environment..."
            sudo apt-get update && sudo apt-get install -y xfce4 xfce4-terminal &
            show_progress $! "Installing XFCE"
            
            # Create starter script
            cat > "$SCRIPTS_DIR/desktop/start-xfce.sh" << 'EOF'
#!/bin/bash
# Script to start XFCE desktop environment
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
export LIBGL_ALWAYS_INDIRECT=1
startxfce4
EOF
            chmod +x "$SCRIPTS_DIR/desktop/start-xfce.sh"
            
            # Create stop script
            cat > "$SCRIPTS_DIR/desktop/stop-xfce.sh" << 'EOF'
#!/bin/bash
# Script to stop XFCE desktop environment
pkill -f xfce4-session
EOF
            chmod +x "$SCRIPTS_DIR/desktop/stop-xfce.sh"
            
            # Update desktop config
            cat > "$DESKTOP_CONFIG" << EOF
# Desktop Environment Configuration
installed=true
current=xfce
autostart=false
EOF
            
            print_success "XFCE installed. Run $SCRIPTS_DIR/desktop/start-xfce.sh to launch."
            ;;
        2)
            print_info "Installing MATE Desktop Environment..."
            sudo apt-get update && sudo apt-get install -y mate-desktop-environment mate-terminal &
            show_progress $! "Installing MATE"
            
            # Create starter script
            cat > "$SCRIPTS_DIR/desktop/start-mate.sh" << 'EOF'
#!/bin/bash
# Script to start MATE desktop environment
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
export LIBGL_ALWAYS_INDIRECT=1
mate-session
EOF
            chmod +x "$SCRIPTS_DIR/desktop/start-mate.sh"
            
            # Create stop script
            cat > "$SCRIPTS_DIR/desktop/stop-mate.sh" << 'EOF'
#!/bin/bash
# Script to stop MATE desktop environment
pkill -f mate-session
EOF
            chmod +x "$SCRIPTS_DIR/desktop/stop-mate.sh"
            
            # Update desktop config
            cat > "$DESKTOP_CONFIG" << EOF
# Desktop Environment Configuration
installed=true
current=mate
autostart=false
EOF
            
            print_success "MATE installed. Run $SCRIPTS_DIR/desktop/start-mate.sh to launch."
            ;;
        3)
            print_info "Installing KDE Plasma Desktop Environment..."
            sudo apt-get update && sudo apt-get install -y kde-plasma-desktop konsole &
            show_progress $! "Installing KDE Plasma"
            
            # Create starter script
            cat > "$SCRIPTS_DIR/desktop/start-kde.sh" << 'EOF'
#!/bin/bash
# Script to start KDE Plasma desktop environment
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
export LIBGL_ALWAYS_INDIRECT=1
startplasma-x11
EOF
            chmod +x "$SCRIPTS_DIR/desktop/start-kde.sh"
            
            # Create stop script
            cat > "$SCRIPTS_DIR/desktop/stop-kde.sh" << 'EOF'
#!/bin/bash
# Script to stop KDE Plasma desktop environment
pkill -f "startplasma-x11|kwin|plasmashell"
EOF
            chmod +x "$SCRIPTS_DIR/desktop/stop-kde.sh"
            
            # Update desktop config
            cat > "$DESKTOP_CONFIG" << EOF
# Desktop Environment Configuration
installed=true
current=kde
autostart=false
EOF
            
            print_success "KDE Plasma installed. Run $SCRIPTS_DIR/desktop/start-kde.sh to launch."
            ;;
        4)
            print_info "Installing GNOME Desktop Environment..."
            sudo apt-get update && sudo apt-get install -y gnome-session gnome-terminal &
            show_progress $! "Installing GNOME"
            
            # Create starter script
            cat > "$SCRIPTS_DIR/desktop/start-gnome.sh" << 'EOF'
#!/bin/bash
# Script to start GNOME desktop environment
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
export LIBGL_ALWAYS_INDIRECT=1
gnome-session
EOF
            chmod +x "$SCRIPTS_DIR/desktop/start-gnome.sh"
            
            # Create stop script
            cat > "$SCRIPTS_DIR/desktop/stop-gnome.sh" << 'EOF'
#!/bin/bash
# Script to stop GNOME desktop environment
pkill -f "gnome-session|gnome-shell"
EOF
            chmod +x "$SCRIPTS_DIR/desktop/stop-gnome.sh"
            
            # Update desktop config
            cat > "$DESKTOP_CONFIG" << EOF
# Desktop Environment Configuration
installed=true
current=gnome
autostart=false
EOF
            
            print_success "GNOME installed. Run $SCRIPTS_DIR/desktop/start-gnome.sh to launch."
            ;;
        5)
            print_info "Skipping desktop environment installation."
            
            # Update desktop config
            cat > "$DESKTOP_CONFIG" << EOF
# Desktop Environment Configuration
installed=false
current=none
autostart=false
EOF
            ;;
        *)
            print_warning "Invalid choice. Skipping desktop environment installation."
            ;;
    esac
    
    # Update desktop in main config
    if [ "$de_choice" -ge 1 ] && [ "$de_choice" -le 4 ]; then
        case $de_choice in
            1) DESKTOP="xfce" ;;
            2) DESKTOP="mate" ;;
            3) DESKTOP="kde" ;;
            4) DESKTOP="gnome" ;;
        esac
        save_config
    fi
    
    wait_for_keypress "Press any key to continue installation..."
    return 0
}

# Function to setup audio
setup_audio() {
    print_section_header "Audio Setup"
    
    print_info "WSL does not natively support audio, but it can be configured to forward audio to Windows."
    print_info "The most common method is using PulseAudio:"
    echo
    
    if confirm "Do you want to configure audio support?"; then
        print_info "Installing PulseAudio..."
        sudo apt-get update && sudo apt-get install -y pulseaudio pulseaudio-utils &
        show_progress $! "Installing PulseAudio"
        
        # Create directory for audio scripts
        mkdir -p "$SCRIPTS_DIR/audio"
        
        # Create audio configuration
        cat > "$CONFIG_DIR/audio.conf" << EOF
# Audio Configuration
enabled=true
type=pulseaudio
server=$WINDOWS_IP
EOF
        
        # Create PulseAudio configuration script
        cat > "$SCRIPTS_DIR/audio/setup-pulseaudio.sh" << EOF
#!/bin/bash
# Script to configure PulseAudio for WSL

# Create PulseAudio client configuration
mkdir -p ~/.config/pulse
cat > ~/.config/pulse/client.conf << EOL
default-server = tcp:$WINDOWS_IP
# Prevent auto-connection to the local PulseAudio server
autospawn = no
daemon-binary = /bin/true
# Fix for potential playback issues
enable-memfd = no
EOL

echo "PulseAudio client configuration created."
echo "Now you need to install and run PulseAudio on Windows."
echo "1. Download PulseAudio for Windows from https://www.freedesktop.org/wiki/Software/PulseAudio/Ports/Windows/Support/"
echo "2. Configure it to accept connections from WSL."
echo "3. Start the PulseAudio server on Windows."
EOF
        chmod +x "$SCRIPTS_DIR/audio/setup-pulseaudio.sh"
        
        # Create test audio script
        cat > "$SCRIPTS_DIR/audio/test-audio.sh" << 'EOF'
#!/bin/bash
# Script to test audio in WSL

if command -v pactl &>/dev/null; then
    echo "Testing PulseAudio connection..."
    if pactl info &>/dev/null; then
        echo "Success! PulseAudio connection established."
        
        # Try to play a test sound
        if command -v paplay &>/dev/null; then
            # Generate a simple test tone using SoX if available
            if command -v sox &>/dev/null; then
                echo "Playing test tone..."
                sox -n -t pulseaudio default synth 3 sine 440
            else
                echo "SoX not found. Please install it with: sudo apt-get install sox"
                echo "Alternatively, you can play an audio file with paplay"
            fi
        else
            echo "paplay not found. Please install pulseaudio-utils."
        fi
    else
        echo "Failed to connect to PulseAudio server."
        echo "Please make sure PulseAudio is running on Windows and properly configured."
    fi
else
    echo "PulseAudio tools not found. Please install pulseaudio and pulseaudio-utils."
fi
EOF
        chmod +x "$SCRIPTS_DIR/audio/test-audio.sh"
        
        # Execute the audio setup script
        "$SCRIPTS_DIR/audio/setup-pulseaudio.sh"
        
        print_success "Audio configuration complete."
        print_info "After setting up PulseAudio on Windows, you can test audio with:"
        echo "  $SCRIPTS_DIR/audio/test-audio.sh"
        
        # Set the audio configuration in main config
        SOUND="pulseaudio"
        save_config
    else
        print_info "Skipping audio configuration."
        
        # Create audio configuration
        cat > "$CONFIG_DIR/audio.conf" << EOF
# Audio Configuration
enabled=false
type=none
server=none
EOF
        
        # Set the audio configuration in main config
        SOUND="none"
        save_config
    fi
    
    wait_for_keypress "Press any key to continue installation..."
    return 0
}

# Function to setup clipboard sharing
setup_clipboard() {
    print_section_header "Clipboard Setup"
    
    print_info "WSL can share clipboard with Windows for easy copy and paste between systems."
    echo
    
    if confirm "Do you want to enable clipboard sharing?"; then
        # Create directory for clipboard scripts
        mkdir -p "$SCRIPTS_DIR/clipboard"
        
        # VcXsrv and X410 automatically handle clipboard sharing when properly configured
        print_info "Clipboard sharing is handled by your X server."
        print_info "For VcXsrv, make sure to use the -clipboard option when starting."
        print_info "For X410, clipboard integration is enabled by default."
        
        # Create clipboard configuration
        cat > "$CONFIG_DIR/clipboard.conf" << EOF
# Clipboard Configuration
enabled=true
sync_direction=both
EOF
        
        # Create clipboard test script
        cat > "$SCRIPTS_DIR/clipboard/test-clipboard.sh" << 'EOF'
#!/bin/bash
# Script to test clipboard in WSL

if command -v xclip &>/dev/null; then
    echo "Testing clipboard..."
    echo "WSL Clipboard Test" | xclip -selection clipboard
    echo "Text 'WSL Clipboard Test' copied to clipboard."
    echo "Please try pasting in Windows now."
    
    echo
    echo "Now copy some text in Windows and press Enter to view it here..."
    read
    
    echo "Clipboard content from Windows:"
    xclip -o -selection clipboard
else
    echo "xclip not found. Installing..."
    sudo apt-get update && sudo apt-get install -y xclip
    
    echo "Please run this script again after installation."
fi
EOF
        chmod +x "$SCRIPTS_DIR/clipboard/test-clipboard.sh"
        
        # Install xclip for clipboard operations
        print_info "Installing xclip for clipboard operations..."
        sudo apt-get update && sudo apt-get install -y xclip &
        show_progress $! "Installing xclip"
        
        print_success "Clipboard integration configured."
        print_info "You can test clipboard sharing with:"
        echo "  $SCRIPTS_DIR/clipboard/test-clipboard.sh"
        
        # Set the clipboard configuration in main config
        CLIPBOARD="enabled"
        save_config
    else
        print_info "Skipping clipboard configuration."
        
        # Create clipboard configuration
        cat > "$CONFIG_DIR/clipboard.conf" << EOF
# Clipboard Configuration
enabled=false
sync_direction=none
EOF
        
        # Set the clipboard configuration in main config
        CLIPBOARD="disabled"
        save_config
    fi
    
    wait_for_keypress "Press any key to continue installation..."
    return 0
}