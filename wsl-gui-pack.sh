#!/bin/bash

# ========================================================
# WSL GUI Pack - Professional GUI Setup for WSL
# ========================================================

# Source required modules
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source core modules
source "$SCRIPT_DIR/modules/core/config.sh"
source "$SCRIPT_DIR/modules/core/ui.sh"
source "$SCRIPT_DIR/modules/core/utils.sh"
source "$SCRIPT_DIR/modules/core/system.sh"

# Initialize configuration
setup_directories

# Show welcome banner
show_logo

# Check if running in WSL
check_wsl

# Parse command line arguments
parse_arguments "$@"

# If no arguments provided, show main menu
if [ -z "$1" ]; then
    show_main_menu
fi

exit 0