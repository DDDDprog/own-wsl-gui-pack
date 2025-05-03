#!/bin/bash

# ===========================================================
# WSL GUI Pack - UI Module
# ===========================================================

# Terminal colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
BLINK='\033[5m'
RESET='\033[0m'

# Function to display the logo
show_logo() {
    clear
    echo -e "${BLUE}${BOLD}"
    echo '██╗    ██╗███████╗██╗          ██████╗ ██╗   ██╗██╗    ██████╗  █████╗  ██████╗██╗  ██╗'
    echo '██║    ██║██╔════╝██║         ██╔════╝ ██║   ██║██║    ██╔══██╗██╔══██╗██╔════╝██║ ██╔╝'
    echo '██║ █╗ ██║███████╗██║         ██║  ███╗██║   ██║██║    ██████╔╝███████║██║     █████╔╝ '
    echo '██║███╗██║╚════██║██║         ██║   ██║██║   ██║██║    ██╔═══╝ ██╔══██║██║     ██╔═██╗ '
    echo '╚███╔███╔╝███████║███████╗    ╚██████╔╝╚██████╔╝██║    ██║     ██║  ██║╚██████╗██║  ██╗'
    echo ' ╚══╝╚══╝ ╚══════╝╚══════╝     ╚═════╝  ╚═════╝ ╚═╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝'
    echo -e "${RESET}${CYAN}${BOLD}                           Professional Edition v$VERSION${RESET}"
    echo
    echo -e "${YELLOW}A comprehensive solution for running GUI applications in WSL${RESET}"
    echo -e "${YELLOW}===============================================================${RESET}"
    echo
}

# Function to show the main menu
show_main_menu() {
    while true; do
        clear
        show_logo
        
        echo -e "${BOLD}Main Menu${RESET}"
        echo
        echo -e "${CYAN}1)${RESET} Install Components"
        echo -e "${CYAN}2)${RESET} Start Desktop Environment"
        echo -e "${CYAN}3)${RESET} Launch Applications"
        echo -e "${CYAN}4)${RESET} Display Configuration"
        echo -e "${CYAN}5)${RESET} Audio Settings"
        echo -e "${CYAN}6)${RESET} Theme & Appearance"
        echo -e "${CYAN}7)${RESET} System Monitoring"
        echo -e "${CYAN}8)${RESET} Settings & Configuration"
        echo -e "${CYAN}9)${RESET} Help & Documentation"
        echo -e "${CYAN}0)${RESET} Exit"
        echo
        
        read -p "Enter your choice [0-9]: " choice
        
        case $choice in
            1)
                # Source and run the installation module
                source "$SCRIPT_DIR/modules/install/install.sh"
                run_installation
                ;;
            2)
                # Source and run the desktop module
                source "$SCRIPT_DIR/modules/desktop/start.sh"
                start_desktop_environment
                ;;
            3)
                # Source and run the applications module
                source "$SCRIPT_DIR/modules/apps/launcher.sh"
                show_app_launcher
                ;;
            4)
                # Source and run the display module
                source "$SCRIPT_DIR/modules/display/config.sh"
                configure_display
                ;;
            5)
                # Source and run the audio module
                source "$SCRIPT_DIR/modules/audio/config.sh"
                configure_audio
                ;;
            6)
                # Source and run the theme module
                source "$SCRIPT_DIR/modules/themes/manager.sh"
                manage_themes
                ;;
            7)
                # Source and run the monitoring module
                source "$SCRIPT_DIR/modules/monitor/system.sh"
                monitor_system
                ;;
            8)
                # Show the configuration menu
                show_config_menu
                ;;
            9)
                # Show help and documentation
                show_help_docs
                ;;
            0)
                clear
                echo -e "${GREEN}Thank you for using WSL GUI Pack!${RESET}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Press any key to continue...${RESET}"
                read -n 1
                ;;
        esac
    done
}

# Function to show configuration menu
show_config_menu() {
    while true; do
        clear
        print_section_header "Configuration Menu"
        
        echo -e "${CYAN}1)${RESET} General Settings"
        echo -e "${CYAN}2)${RESET} X Server Configuration"
        echo -e "${CYAN}3)${RESET} Desktop Environment Settings"
        echo -e "${CYAN}4)${RESET} Display Settings"
        echo -e "${CYAN}5)${RESET} Audio Settings"
        echo -e "${CYAN}6)${RESET} Application Settings"
        echo -e "${CYAN}7)${RESET} Startup Options"
        echo -e "${CYAN}8)${RESET} Advanced Settings"
        echo -e "${CYAN}9)${RESET} Backup & Restore"
        echo -e "${CYAN}0)${RESET} Back to Main Menu"
        echo
        
        read -p "Enter your choice [0-9]: " choice
        
        case $choice in
            1)
                # Source and run general settings
                source "$SCRIPT_DIR/modules/config/general.sh"
                manage_general_settings
                ;;
            2)
                # Source and run X server configuration
                source "$SCRIPT_DIR/modules/config/x_server.sh"
                configure_x_server
                ;;
            3)
                # Source and run desktop environment settings
                source "$SCRIPT_DIR/modules/config/desktop.sh"
                configure_desktop
                ;;
            4)
                # Source and run display settings
                source "$SCRIPT_DIR/modules/display/config.sh"
                configure_display
                ;;
            5)
                # Source and run audio settings
                source "$SCRIPT_DIR/modules/audio/config.sh"
                configure_audio
                ;;
            6)
                # Source and run application settings
                source "$SCRIPT_DIR/modules/apps/config.sh"
                configure_applications
                ;;
            7)
                # Source and run startup options
                source "$SCRIPT_DIR/modules/config/startup.sh"
                configure_startup
                ;;
            8)
                # Source and run advanced settings
                source "$SCRIPT_DIR/modules/config/advanced.sh"
                configure_advanced
                ;;
            9)
                # Source and run backup & restore
                source "$SCRIPT_DIR/modules/config/backup.sh"
                manage_backup
                ;;
            0)
                return
                ;;
            *)
                echo -e "${RED}Invalid option. Press any key to continue...${RESET}"
                read -n 1
                ;;
        esac
    done
}

# Function to print a section header
print_section_header() {
    echo
    echo -e "${MAGENTA}${BOLD}$1${RESET}"
    echo -e "${MAGENTA}$(printf '=%.0s' $(seq 1 ${#1}))${RESET}"
}

# Function to show help documentation
show_help_docs() {
    clear
    print_section_header "Help & Documentation"
    
    echo -e "${BOLD}WSL GUI Pack Documentation${RESET}"
    echo
    echo "This tool helps you set up and manage GUI applications in WSL."
    echo
    echo -e "${BOLD}Getting Started:${RESET}"
    echo "1. Install the required components using the 'Install Components' option"
    echo "2. Configure your X Server to allow connections from WSL"
    echo "3. Start your preferred desktop environment"
    echo
    echo -e "${BOLD}Key Features:${RESET}"
    echo "- Easy setup of X Server for WSL GUI applications"
    echo "- Multiple desktop environment options (XFCE, MATE, KDE, GNOME)"
    echo "- Application launcher for common Linux GUI apps"
    echo "- Multi-display support and configuration"
    echo "- Audio forwarding from WSL to Windows"
    echo "- System resource monitoring for GUI applications"
    echo
    echo -e "${BOLD}Troubleshooting:${RESET}"
    echo "- Check that your X Server is running on Windows"
    echo "- Verify that DISPLAY environment variable is set correctly"
    echo "- Review logs in $LOGS_DIR for detailed error information"
    echo
    
    echo -e "${YELLOW}Press any key to return to the main menu...${RESET}"
    read -n 1
}

# Function to display notification
show_notification() {
    local message=$1
    local type=${2:-"info"}  # Default to info
    
    case "$type" in
        "success")
            echo -e "${GREEN}✓ $message${RESET}"
            ;;
        "error")
            echo -e "${RED}✗ $message${RESET}"
            ;;
        "warning")
            echo -e "${YELLOW}⚠ $message${RESET}"
            ;;
        "info"|*)
            echo -e "${BLUE}ℹ $message${RESET}"
            ;;
    esac
}

# Show progress indicator
show_progress() {
    local pid=$1
    local message=$2
    local spin='-\|/'
    local i=0
    
    echo -ne "${CYAN}$message...  ${RESET}"
    
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) % 4 ))
        echo -ne "\b${spin:$i:1}"
        sleep .1
    done
    
    echo -ne "\b "
    echo
}

# Function for user confirmation
confirm() {
    local message=$1
    
    echo -ne "${YELLOW}$message (y/n): ${RESET}"
    read -r response
    
    case "$response" in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Display current status
show_status() {
    clear
    print_section_header "System Status"
    
    # Load configuration
    load_config
    
    echo -e "${BOLD}WSL GUI Pack Status${RESET}"
    echo
    echo -e "${BOLD}Version:${RESET} $VERSION"
    echo -e "${BOLD}Installation Directory:${RESET} $INSTALL_DIR"
    
    # Check if X Server is running
    if check_x_server; then
        echo -e "${BOLD}X Server:${RESET} ${GREEN}Running${RESET} ($X_SERVER)"
    else
        echo -e "${BOLD}X Server:${RESET} ${RED}Not Running${RESET}"
    fi
    
    # Check if desktop environment is installed
    if [ -f "$DESKTOP_CONFIG" ]; then
        source "$DESKTOP_CONFIG"
        if [ "$installed" = "true" ]; then
            echo -e "${BOLD}Desktop Environment:${RESET} ${GREEN}Installed${RESET} ($current)"
            
            # Check if desktop is running
            if pgrep -f "$current" > /dev/null; then
                echo -e "${BOLD}Desktop Status:${RESET} ${GREEN}Running${RESET}"
            else
                echo -e "${BOLD}Desktop Status:${RESET} ${YELLOW}Not Running${RESET}"
            fi
        else
            echo -e "${BOLD}Desktop Environment:${RESET} ${YELLOW}Not Installed${RESET}"
        fi
    else
        echo -e "${BOLD}Desktop Environment:${RESET} ${YELLOW}Not Configured${RESET}"
    fi
    
    # Check audio configuration
    if [ -f "$CONFIG_DIR/audio.conf" ]; then
        source "$CONFIG_DIR/audio.conf"
        if [ "$enabled" = "true" ]; then
            echo -e "${BOLD}Audio:${RESET} ${GREEN}Configured${RESET} ($type)"
        else
            echo -e "${BOLD}Audio:${RESET} ${YELLOW}Disabled${RESET}"
        fi
    else
        echo -e "${BOLD}Audio:${RESET} ${YELLOW}Not Configured${RESET}"
    fi
    
    # Display configuration
    if [ -f "$DISPLAY_CONFIG" ]; then
        source "$DISPLAY_CONFIG"
        echo -e "${BOLD}Display:${RESET} $resolution @ ${dpi}dpi"
        if [ "$multi_monitor" = "true" ]; then
            echo -e "${BOLD}Multi-Monitor:${RESET} ${GREEN}Enabled${RESET}"
        else
            echo -e "${BOLD}Multi-Monitor:${RESET} ${YELLOW}Disabled${RESET}"
        fi
    fi
    
    echo
    echo -e "${YELLOW}Press any key to return to the main menu...${RESET}"
    read -n 1
}