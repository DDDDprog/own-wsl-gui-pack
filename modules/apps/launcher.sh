#!/bin/bash

# ===========================================================
# WSL GUI Pack - Application Launcher Module
# ===========================================================

# Function to show application launcher
show_app_launcher() {
    clear
    print_section_header "Application Launcher"
    
    # Load configuration
    load_config
    
    # Check if X server is running
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
            print_error "Cannot launch applications without X server."
            wait_for_keypress
            return 1
        fi
    fi
    
    # Set up environment
    export DISPLAY=$WINDOWS_IP:0
    export LIBGL_ALWAYS_INDIRECT=1
    
    # Show application categories
    while true; do
        clear
        print_section_header "Application Launcher"
        
        echo -e "${BOLD}Select a category:${RESET}"
        echo
        echo -e "${CYAN}1)${RESET} Internet"
        echo -e "${CYAN}2)${RESET} Development"
        echo -e "${CYAN}3)${RESET} Graphics & Multimedia"
        echo -e "${CYAN}4)${RESET} Office & Productivity"
        echo -e "${CYAN}5)${RESET} System Tools"
        echo -e "${CYAN}6)${RESET} Games"
        echo -e "${CYAN}7)${RESET} Education"
        echo -e "${CYAN}8)${RESET} Run Command"
        echo -e "${CYAN}9)${RESET} Installed Applications"
        echo -e "${CYAN}0)${RESET} Back to Main Menu"
        echo
        
        read -p "Enter your choice [0-9]: " choice
        
        case $choice in
            1)
                show_internet_apps
                ;;
            2)
                show_development_apps
                ;;
            3)
                show_multimedia_apps
                ;;
            4)
                show_office_apps
                ;;
            5)
                show_system_tools
                ;;
            6)
                show_games
                ;;
            7)
                show_education_apps
                ;;
            8)
                run_command
                ;;
            9)
                show_installed_apps
                ;;
            0)
                return
                ;;
            *)
                print_error "Invalid option. Press any key to continue..."
                read -n 1
                ;;
        esac
    done
}

# Function to show internet applications
show_internet_apps() {
    clear
    print_section_header "Internet Applications"
    
    echo -e "${BOLD}Select an application to launch:${RESET}"
    echo
    echo -e "${CYAN}1)${RESET} Firefox"
    echo -e "${CYAN}2)${RESET} Chromium"
    echo -e "${CYAN}3)${RESET} Thunderbird"
    echo -e "${CYAN}4)${RESET} FileZilla"
    echo -e "${CYAN}5)${RESET} Transmission"
    echo -e "${CYAN}6)${RESET} HexChat"
    echo -e "${CYAN}0)${RESET} Back to Categories"
    echo
    
    read -p "Enter your choice [0-6]: " choice
    
    case $choice in
        1)
            launch_app "firefox" "Firefox" "firefox"
            ;;
        2)
            launch_app "chromium-browser" "Chromium" "chromium-browser"
            ;;
        3)
            launch_app "thunderbird" "Thunderbird" "thunderbird"
            ;;
        4)
            launch_app "filezilla" "FileZilla" "filezilla"
            ;;
        5)
            launch_app "transmission-gtk" "Transmission" "transmission-gtk"
            ;;
        6)
            launch_app "hexchat" "HexChat" "hexchat"
            ;;
        0)
            return
            ;;
        *)
            print_error "Invalid option. Press any key to continue..."
            read -n 1
            ;;
    esac
    
    wait_for_keypress
}

# Function to show development applications
show_development_apps() {
    clear
    print_section_header "Development Applications"
    
    echo -e "${BOLD}Select an application to launch:${RESET}"
    echo
    echo -e "${CYAN}1)${RESET} Visual Studio Code"
    echo -e "${CYAN}2)${RESET} Sublime Text"
    echo -e "${CYAN}3)${RESET} GNOME Terminal"
    echo -e "${CYAN}4)${RESET} Geany"
    echo -e "${CYAN}5)${RESET} Eclipse"
    echo -e "${CYAN}6)${RESET} GitKraken"
    echo -e "${CYAN}7)${RESET} Meld"
    echo -e "${CYAN}0)${RESET} Back to Categories"
    echo
    
    read -p "Enter your choice [0-7]: " choice
    
    case $choice in
        1)
            launch_app "code" "Visual Studio Code" "code"
            ;;
        2)
            launch_app "subl" "Sublime Text" "subl"
            ;;
        3)
            launch_app "gnome-terminal" "GNOME Terminal" "gnome-terminal"
            ;;
        4)
            launch_app "geany" "Geany" "geany"
            ;;
        5)
            launch_app "eclipse" "Eclipse" "eclipse"
            ;;
        6)
            launch_app "gitkraken" "GitKraken" "gitkraken"
            ;;
        7)
            launch_app "meld" "Meld" "meld"
            ;;
        0)
            return
            ;;
        *)
            print_error "Invalid option. Press any key to continue..."
            read -n 1
            ;;
    esac
    
    wait_for_keypress
}

# Function to show multimedia applications
show_multimedia_apps() {
    clear
    print_section_header "Graphics & Multimedia Applications"
    
    echo -e "${BOLD}Select an application to launch:${RESET}"
    echo
    echo -e "${CYAN}1)${RESET} GIMP"
    echo -e "${CYAN}2)${RESET} Inkscape"
    echo -e "${CYAN}3)${RESET} VLC Media Player"
    echo -e "${CYAN}4)${RESET} Audacity"
    echo -e "${CYAN}5)${RESET} Blender"
    echo -e "${CYAN}6)${RESET} OBS Studio"
    echo -e "${CYAN}7)${RESET} Kdenlive"
    echo -e "${CYAN}0)${RESET} Back to Categories"
    echo
    
    read -p "Enter your choice [0-7]: " choice
    
    case $choice in
        1)
            launch_app "gimp" "GIMP" "gimp"
            ;;
        2)
            launch_app "inkscape" "Inkscape" "inkscape"
            ;;
        3)
            launch_app "vlc" "VLC Media Player" "vlc"
            ;;
        4)
            launch_app "audacity" "Audacity" "audacity"
            ;;
        5)
            launch_app "blender" "Blender" "blender"
            ;;
        6)
            launch_app "obs" "OBS Studio" "obs"
            ;;
        7)
            launch_app "kdenlive" "Kdenlive" "kdenlive"
            ;;
        0)
            return
            ;;
        *)
            print_error "Invalid option. Press any key to continue..."
            read -n 1
            ;;
    esac
    
    wait_for_keypress
}

# Function to show office applications
show_office_apps() {
    clear
    print_section_header "Office & Productivity Applications"
    
    echo -e "${BOLD}Select an application to launch:${RESET}"
    echo
    echo -e "${CYAN}1)${RESET} LibreOffice Writer"
    echo -e "${CYAN}2)${RESET} LibreOffice Calc"
    echo -e "${CYAN}3)${RESET} LibreOffice Impress"
    echo -e "${CYAN}4)${RESET} LibreOffice Draw"
    echo -e "${CYAN}5)${RESET} Evince Document Viewer"
    echo -e "${CYAN}6)${RESET} Okular"
    echo -e "${CYAN}7)${RESET} Calibre"
    echo -e "${CYAN}0)${RESET} Back to Categories"
    echo
    
    read -p "Enter your choice [0-7]: " choice
    
    case $choice in
        1)
            launch_app "libreoffice --writer" "LibreOffice Writer" "libreoffice"
            ;;
        2)
            launch_app "libreoffice --calc" "LibreOffice Calc" "libreoffice"
            ;;
        3)
            launch_app "libreoffice --impress" "LibreOffice Impress" "libreoffice"
            ;;
        4)
            launch_app "libreoffice --draw" "LibreOffice Draw" "libreoffice"
            ;;
        5)
            launch_app "evince" "Evince Document Viewer" "evince"
            ;;
        6)
            launch_app "okular" "Okular" "okular"
            ;;
        7)
            launch_app "calibre" "Calibre" "calibre"
            ;;
        0)
            return
            ;;
        *)
            print_error "Invalid option. Press any key to continue..."
            read -n 1
            ;;
    esac
    
    wait_for_keypress
}

# Function to show system tools
show_system_tools() {
    clear
    print_section_header "System Tools"
    
    echo -e "${BOLD}Select an application to launch:${RESET}"
    echo
    echo -e "${CYAN}1)${RESET} File Manager"
    echo -e "${CYAN}2)${RESET} System Monitor"
    echo -e "${CYAN}3)${RESET} Disk Usage Analyzer"
    echo -e "${CYAN}4)${RESET} GParted"
    echo -e "${CYAN}5)${RESET} Terminal"
    echo -e "${CYAN}6)${RESET} Synaptic Package Manager"
    echo -e "${CYAN}7)${RESET} Wireshark"
    echo -e "${CYAN}0)${RESET} Back to Categories"
    echo
    
    read -p "Enter your choice [0-7]: " choice
    
    case $choice in
        1)
            # Try various file managers in order
            if command_exists "nautilus"; then
                launch_app "nautilus" "Nautilus File Manager" "nautilus"
            elif command_exists "thunar"; then
                launch_app "thunar" "Thunar File Manager" "thunar"
            elif command_exists "pcmanfm"; then
                launch_app "pcmanfm" "PCManFM File Manager" "pcmanfm"
            else
                print_error "No supported file manager found."
            fi
            ;;
        2)
            # Try various system monitors in order
            if command_exists "gnome-system-monitor"; then
                launch_app "gnome-system-monitor" "GNOME System Monitor" "gnome-system-monitor"
            elif command_exists "xfce4-taskmanager"; then
                launch_app "xfce4-taskmanager" "XFCE Task Manager" "xfce4-taskmanager"
            else
                print_error "No supported system monitor found."
            fi
            ;;
        3)
            launch_app "baobab" "Disk Usage Analyzer" "baobab"
            ;;
        4)
            launch_app "gparted" "GParted" "gparted"
            ;;
        5)
            # Try various terminals in order
            if command_exists "gnome-terminal"; then
                launch_app "gnome-terminal" "GNOME Terminal" "gnome-terminal"
            elif command_exists "xfce4-terminal"; then
                launch_app "xfce4-terminal" "XFCE Terminal" "xfce4-terminal"
            elif command_exists "konsole"; then
                launch_app "konsole" "Konsole" "konsole"
            else
                launch_app "x-terminal-emulator" "Terminal" "x-terminal-emulator"
            fi
            ;;
        6)
            launch_app "synaptic" "Synaptic Package Manager" "synaptic"
            ;;
        7)
            launch_app "wireshark" "Wireshark" "wireshark"
            ;;
        0)
            return
            ;;
        *)
            print_error "Invalid option. Press any key to continue..."
            read -n 1
            ;;
    esac
    
    wait_for_keypress
}

# Function to show games
show_games() {
    clear
    print_section_header "Games"
    
    echo -e "${BOLD}Select a game to launch:${RESET}"
    echo
    echo -e "${CYAN}1)${RESET} SuperTuxKart"
    echo -e "${CYAN}2)${RESET} Frozen Bubble"
    echo -e "${CYAN}3)${RESET} Battle for Wesnoth"
    echo -e "${CYAN}4)${RESET} 0 A.D."
    echo -e "${CYAN}5)${RESET} Hedgewars"
    echo -e "${CYAN}6)${RESET} SuperTux"
    echo -e "${CYAN}0)${RESET} Back to Categories"
    echo
    
    read -p "Enter your choice [0-6]: " choice
    
    case $choice in
        1)
            launch_app "supertuxkart" "SuperTuxKart" "supertuxkart"
            ;;
        2)
            launch_app "frozen-bubble" "Frozen Bubble" "frozen-bubble"
            ;;
        3)
            launch_app "wesnoth" "Battle for Wesnoth" "wesnoth"
            ;;
        4)
            launch_app "0ad" "0 A.D." "0ad"
            ;;
        5)
            launch_app "hedgewars" "Hedgewars" "hedgewars"
            ;;
        6)
            launch_app "supertux2" "SuperTux" "supertux2"
            ;;
        0)
            return
            ;;
        *)
            print_error "Invalid option. Press any key to continue..."
            read -n 1
            ;;
    esac
    
    wait_for_keypress
}

# Function to show education applications
show_education_apps() {
    clear
    print_section_header "Education Applications"
    
    echo -e "${BOLD}Select an application to launch:${RESET}"
    echo
    echo -e "${CYAN}1)${RESET} GCompris"
    echo -e "${CYAN}2)${RESET} Stellarium"
    echo -e "${CYAN}3)${RESET} Tux Paint"
    echo -e "${CYAN}4)${RESET} KGeography"
    echo -e "${CYAN}5)${RESET} Marble"
    echo -e "${CYAN}0)${RESET} Back to Categories"
    echo
    
    read -p "Enter your choice [0-5]: " choice
    
    case $choice in
        1)
            launch_app "gcompris-qt" "GCompris" "gcompris-qt"
            ;;
        2)
            launch_app "stellarium" "Stellarium" "stellarium"
            ;;
        3)
            launch_app "tuxpaint" "Tux Paint" "tuxpaint"
            ;;
        4)
            launch_app "kgeography" "KGeography" "kgeography"
            ;;
        5)
            launch_app "marble" "Marble" "marble"
            ;;
        0)
            return
            ;;
        *)
            print_error "Invalid option. Press any key to continue..."
            read -n 1
            ;;
    esac
    
    wait_for_keypress
}

# Function to run a custom command
run_command() {
    clear
    print_section_header "Run Command"
    
    echo -e "${BOLD}Enter the command to run:${RESET}"
    echo
    read -p "> " command
    
    if [ -z "$command" ]; then
        print_warning "No command entered."
        wait_for_keypress
        return
    fi
    
    print_info "Running command: $command"
    echo
    
    # Run the command and detach
    eval "$command" &
    disown
    
    wait_for_keypress
}

# Function to show installed applications
show_installed_apps() {
    clear
    print_section_header "Installed Applications"
    
    print_info "Searching for installed applications..."
    
    # Get installed applications from .desktop files
    local desktop_files=()
    local desktop_names=()
    local desktop_execs=()
    
    # Search in standard locations
    for dir in /usr/share/applications /usr/local/share/applications ~/.local/share/applications; do
        if [ -d "$dir" ]; then
            while IFS= read -r -d '' file; do
                # Extract name and exec command
                local name=$(grep -m 1 "^Name=" "$file" | cut -d'=' -f2)
                local exec=$(grep -m 1 "^Exec=" "$file" | cut -d'=' -f2 | sed 's/%[fFuU]//g')
                local nodisplay=$(grep -m 1 "^NoDisplay=" "$file" | cut -d'=' -f2)
                
                # Skip entries with NoDisplay=true
                if [ "$nodisplay" != "true" ] && [ -n "$name" ] && [ -n "$exec" ]; then
                    desktop_files+=("$file")
                    desktop_names+=("$name")
                    desktop_execs+=("$exec")
                fi
            done < <(find "$dir" -name "*.desktop" -print0)
        fi
    done
    
    if [ ${#desktop_names[@]} -eq 0 ]; then
        print_warning "No applications found."
        wait_for_keypress
        return
    fi
    
    # Display applications in pages
    local per_page=10
    local total_pages=$(( (${#desktop_names[@]} + per_page - 1) / per_page ))
    local current_page=1
    
    while true; do
        clear
        print_section_header "Installed Applications (Page $current_page/$total_pages)"
        
        local start_idx=$(( (current_page - 1) * per_page ))
        local end_idx=$(( start_idx + per_page - 1 ))
        
        if [ $end_idx -ge ${#desktop_names[@]} ]; then
            end_idx=$(( ${#desktop_names[@]} - 1 ))
        fi
        
        for i in $(seq $start_idx $end_idx); do
            echo -e "${CYAN}$((i - start_idx + 1))${RESET}) ${desktop_names[$i]}"
        done
        
        echo
        echo -e "${CYAN}n${RESET}) Next Page"
        echo -e "${CYAN}p${RESET}) Previous Page"
        echo -e "${CYAN}q${RESET}) Back to Categories"
        echo
        
        read -p "Enter your choice: " choice
        
        case $choice in
            [0-9]|[0-9][0-9])
                local idx=$(( start_idx + choice - 1 ))
                if [ $idx -ge $start_idx ] && [ $idx -le $end_idx ]; then
                    launch_app "${desktop_execs[$idx]}" "${desktop_names[$idx]}" "${desktop_execs[$idx]}"
                    wait_for_keypress
                else
                    print_error "Invalid option. Press any key to continue..."
                    read -n 1
                fi
                ;;
            n|N)
                if [ $current_page -lt $total_pages ]; then
                    current_page=$((current_page + 1))
                else
                    print_warning "Already at the last page."
                    wait_for_keypress
                fi
                ;;
            p|P)
                if [ $current_page -gt 1 ]; then
                    current_page=$((current_page - 1))
                else
                    print_warning "Already at the first page."
                    wait_for_keypress
                fi
                ;;
            q|Q)
                return
                ;;
            *)
                print_error "Invalid option. Press any key to continue..."
                read -n 1
                ;;
        esac
    done
}

# Function to launch an application
launch_app() {
    local app_command=$1
    local app_name=$2
    local app_package=${3:-$1}
    
    # Check if the application is installed
    if ! command_exists "$app_package"; then
        print_warning "$app_name is not installed."
        
        if confirm "Do you want to install $app_name now?"; then
            print_info "Installing $app_name..."
            
            # Determine package manager
            if command_exists apt-get; then
                sudo apt-get update && sudo apt-get install -y "$app_package" &
                show_progress $! "Installing $app_name"
            elif command_exists yum; then
                sudo yum install -y "$app_package" &
                show_progress $! "Installing $app_name"
            elif command_exists dnf; then
                sudo dnf install -y "$app_package" &
                show_progress $! "Installing $app_name"
            elif command_exists pacman; then
                sudo pacman -S --noconfirm "$app_package" &
                show_progress $! "Installing $app_name"
            else
                print_error "Unsupported package manager. Please install $app_name manually."
                return 1
            fi
            
            # Check if installation was successful
            if command_exists "$app_package"; then
                print_success "$app_name has been installed successfully."
            else
                print_error "Failed to install $app_name."
                return 1
            fi
        else
            return 1
        fi
    fi
    
    # Launch the application
    print_info "Launching $app_name..."
    eval "$app_command" &>/dev/null &
    disown
    
    return 0
}