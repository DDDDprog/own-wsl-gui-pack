#!/bin/bash

# ===========================================================
# WSL GUI Pack - Configuration Module
# ===========================================================

# Version information
VERSION="1.0.0"
RELEASE_DATE="2025-05-01"

# Directories
INSTALL_DIR="$HOME/.wsl-gui-pack"
CONFIG_DIR="$INSTALL_DIR/config"
LOGS_DIR="$INSTALL_DIR/logs"
THEMES_DIR="$INSTALL_DIR/themes"
SCRIPTS_DIR="$INSTALL_DIR/scripts"
CACHE_DIR="$INSTALL_DIR/cache"
BACKUP_DIR="$INSTALL_DIR/backups"

# Configuration files
MAIN_CONFIG="$CONFIG_DIR/settings.conf"
DISPLAY_CONFIG="$CONFIG_DIR/display.conf"
DESKTOP_CONFIG="$CONFIG_DIR/desktop.conf"
APPS_CONFIG="$CONFIG_DIR/applications.conf"
THEME_CONFIG="$CONFIG_DIR/theme.conf"

# Default settings
DEFAULT_THEME="modern-dark"
DEFAULT_X_SERVER="vcxsrv"
DEFAULT_DESKTOP="xfce"
DEFAULT_SOUND="pulseaudio"
DEFAULT_CLIPBOARD="enabled"

# Setup directories and default configurations
setup_directories() {
    # Create all necessary directories
    mkdir -p "$INSTALL_DIR" "$CONFIG_DIR" "$LOGS_DIR" "$THEMES_DIR" "$SCRIPTS_DIR" "$CACHE_DIR" "$BACKUP_DIR"
    
    # Create default configuration files if they don't exist
    if [ ! -f "$MAIN_CONFIG" ]; then
        cat > "$MAIN_CONFIG" << EOF
# WSL GUI Pack Main Configuration
version=$VERSION
theme=$DEFAULT_THEME
x_server=$DEFAULT_X_SERVER
desktop=$DEFAULT_DESKTOP
sound=$DEFAULT_SOUND
clipboard=$DEFAULT_CLIPBOARD
first_run=true
EOF
    fi
    
    # Create display configuration if it doesn't exist
    if [ ! -f "$DISPLAY_CONFIG" ]; then
        cat > "$DISPLAY_CONFIG" << EOF
# Display Configuration
auto_detect=true
resolution=auto
dpi=96
refresh_rate=60
multi_monitor=true
primary_display=0
EOF
    fi
    
    # Create desktop environment configuration if it doesn't exist
    if [ ! -f "$DESKTOP_CONFIG" ]; then
        cat > "$DESKTOP_CONFIG" << EOF
# Desktop Environment Configuration
installed=false
current=$DEFAULT_DESKTOP
autostart=false
EOF
    fi
    
    # Make sure logs directory exists and create initial log
    touch "$LOGS_DIR/wsl-gui-pack.log"
}

# Load configuration settings
load_config() {
    # Source the configuration file
    if [ -f "$MAIN_CONFIG" ]; then
        source "$MAIN_CONFIG"
    else
        print_error "Configuration file not found. Using defaults."
    fi
    
    # Set global variables based on config
    THEME=${theme:-$DEFAULT_THEME}
    X_SERVER=${x_server:-$DEFAULT_X_SERVER}
    DESKTOP=${desktop:-$DEFAULT_DESKTOP}
    SOUND=${sound:-$DEFAULT_SOUND}
    CLIPBOARD=${clipboard:-$DEFAULT_CLIPBOARD}
    FIRST_RUN=${first_run:-true}
}

# Save configuration settings
save_config() {
    cat > "$MAIN_CONFIG" << EOF
# WSL GUI Pack Main Configuration
version=$VERSION
theme=$THEME
x_server=$X_SERVER
desktop=$DESKTOP
sound=$SOUND
clipboard=$CLIPBOARD
first_run=false
EOF

    # Make sure permissions are correct
    chmod 644 "$MAIN_CONFIG"
}

# Parse command line arguments
parse_arguments() {
    COMMAND=""
    
    while [ "$#" -gt 0 ]; do
        case "$1" in
            install)
                COMMAND="install"
                shift
                ;;
            start)
                COMMAND="start"
                shift
                ;;
            stop)
                COMMAND="stop"
                shift
                ;;
            config)
                COMMAND="config"
                shift
                ;;
            status)
                COMMAND="status"
                shift
                ;;
            help)
                COMMAND="help"
                shift
                ;;
            --version)
                echo "WSL GUI Pack version $VERSION"
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Execute the command if provided
    if [ ! -z "$COMMAND" ]; then
        case "$COMMAND" in
            install)
                source "$SCRIPT_DIR/modules/install/install.sh"
                run_installation
                ;;
            start)
                source "$SCRIPT_DIR/modules/desktop/start.sh"
                start_desktop_environment
                ;;
            stop)
                source "$SCRIPT_DIR/modules/desktop/stop.sh"
                stop_desktop_environment
                ;;
            config)
                show_config_menu
                ;;
            status)
                show_status
                ;;
            help)
                show_help
                ;;
        esac
    fi
}

# Show help text
show_help() {
    echo "WSL GUI Pack - Professional GUI Manager for WSL"
    echo ""
    echo "Usage: wsl-gui-pack [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  install    Install necessary components"
    echo "  start      Start desktop environment"
    echo "  stop       Stop desktop environment"
    echo "  config     Configure settings"
    echo "  status     Show current status"
    echo "  help       Show this help message"
    echo ""
    echo "Options:"
    echo "  --version  Show version information"
}