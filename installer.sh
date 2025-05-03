#!/bin/bash

# ===========================================================
# WSL GUI Pack - Installer Script
# ===========================================================

# Set terminal colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Current directory
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Show banner
echo -e "${BLUE}${BOLD}"
echo '██╗    ██╗███████╗██╗          ██████╗ ██╗   ██╗██╗    ██████╗  █████╗  ██████╗██╗  ██╗'
echo '██║    ██║██╔════╝██║         ██╔════╝ ██║   ██║██║    ██╔══██╗██╔══██╗██╔════╝██║ ██╔╝'
echo '██║ █╗ ██║███████╗██║         ██║  ███╗██║   ██║██║    ██████╔╝███████║██║     █████╔╝ '
echo '██║███╗██║╚════██║██║         ██║   ██║██║   ██║██║    ██╔═══╝ ██╔══██║██║     ██╔═██╗ '
echo '╚███╔███╔╝███████║███████╗    ╚██████╔╝╚██████╔╝██║    ██║     ██║  ██║╚██████╗██║  ██╗'
echo ' ╚══╝╚══╝ ╚══════╝╚══════╝     ╚═════╝  ╚═════╝ ╚═╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝'
echo -e "${RESET}${CYAN}${BOLD}                           Professional Edition Installer${RESET}"
echo
echo -e "${YELLOW}A comprehensive solution for running GUI applications in WSL${RESET}"
echo -e "${YELLOW}===============================================================${RESET}"
echo

# Check if running in WSL
if ! grep -q "Microsoft" /proc/version &> /dev/null && ! grep -q "microsoft" /proc/version &> /dev/null; then
    echo -e "${RED}Error: This script must be run within WSL (Windows Subsystem for Linux)${RESET}"
    exit 1
fi

echo -e "${GREEN}✓${RESET} Running in WSL environment"

# Create directory structure
echo -e "${BLUE}Creating directory structure...${RESET}"

# Define installation directory
INSTALL_DIR="/usr/local/share/wsl-gui-pack"

# Create main directories with sudo
sudo mkdir -p "$INSTALL_DIR"
sudo mkdir -p "$INSTALL_DIR/modules"
sudo mkdir -p "$INSTALL_DIR/modules/core"
sudo mkdir -p "$INSTALL_DIR/modules/install"
sudo mkdir -p "$INSTALL_DIR/modules/desktop"
sudo mkdir -p "$INSTALL_DIR/modules/apps"
sudo mkdir -p "$INSTALL_DIR/modules/display"
sudo mkdir -p "$INSTALL_DIR/modules/audio"
sudo mkdir -p "$INSTALL_DIR/modules/themes"
sudo mkdir -p "$INSTALL_DIR/modules/monitor"
sudo mkdir -p "$INSTALL_DIR/modules/config"

echo -e "${GREEN}✓${RESET} Directory structure created"

# Copy files to installation directory
echo -e "${BLUE}Installing WSL GUI Pack...${RESET}"

# Copy main script and modules with sudo
sudo cp "$CURRENT_DIR/wsl-gui-pack.sh" "$INSTALL_DIR/"
sudo cp -r "$CURRENT_DIR/modules/"* "$INSTALL_DIR/modules/"

# Set correct permissions
sudo chmod +x "$INSTALL_DIR/wsl-gui-pack.sh"
sudo find "$INSTALL_DIR" -name "*.sh" -exec chmod +x {} \;

echo -e "${GREEN}✓${RESET} WSL GUI Pack files installed"

# Create symlink in /usr/local/bin for system-wide access
echo -e "${BLUE}Creating system-wide symlink...${RESET}"
sudo ln -sf "$INSTALL_DIR/wsl-gui-pack.sh" /usr/local/bin/wsl-gui-pack
echo -e "${GREEN}✓${RESET} Created symlink in /usr/local/bin"

# Installation complete
echo
echo -e "${GREEN}${BOLD}Installation Complete!${RESET}"
echo
echo -e "You can now use WSL GUI Pack by running: ${CYAN}wsl-gui-pack${RESET}"
echo -e "To access it in the current session, run: ${CYAN}source ~/.bashrc${RESET}"
echo
echo -e "For more information, run: ${CYAN}wsl-gui-pack help${RESET}"
echo

# Ask to run now
read -p "Do you want to run WSL GUI Pack now? (y/n): " choice
case "$choice" in
    y|Y)
        exec "$INSTALL_DIR/wsl-gui-pack.sh"
        ;;
    *)
        echo -e "${YELLOW}You can run WSL GUI Pack later with the 'wsl-gui-pack' command.${RESET}"
        ;;
esac

exit 0