![image](https://github.com/user-attachments/assets/79d4ef18-b5b5-43a8-b5e6-5384a0f5b98e)# WSL GUI Pack - Professional Edition

A comprehensive solution for running GUI applications in Windows Subsystem for Linux.

![WSL GUI Pack Logo](https://pics.craiyon.com/2023-11-04/57324fe7d7cc405b938239013874cebe.webp)


## Features

- **Easy Installation**: Simple setup of X11 server and required dependencies
- **Desktop Environment Support**: Install and manage multiple desktop environments (XFCE, MATE, KDE, GNOME)
- **Application Launcher**: Categorized launcher for common Linux GUI applications
- **Display Configuration**: Support for multi-monitor setups and resolution management
- **Audio Forwarding**: Configure audio to work between WSL and Windows
- **Clipboard Sharing**: Seamless copy & paste between Windows and Linux
- **Theme & Appearance**: Customize your Linux desktop experience
- **System Monitoring**: Monitor resource usage of GUI applications

## Installation

### Quick Install

```bash
./installer.sh
```

### Manual Installation

1. Clone the repository:

```bash
git clone https://github.com/DDDDprog/own-wsl-gui-pack.git
cd wsl-gui-pack
```

2. Run the installer:

```bash
./installer.sh
```

3. Add to your PATH (if not done by installer):

```bash
echo 'export PATH="$PATH:$HOME/.wsl-gui-pack"' >> ~/.bashrc
source ~/.bashrc
```

## Usage

### Basic Commands

- Start WSL GUI Pack:

```bash
wsl-gui-pack
```

- Install necessary components:

```bash
wsl-gui-pack install
```

- Start a desktop environment:

```bash
wsl-gui-pack start
```

- Stop a running desktop environment:

```bash
wsl-gui-pack stop
```

- View help:

```bash
wsl-gui-pack help
```

### Desktop Environments

WSL GUI Pack supports the following desktop environments:

- XFCE (lightweight, recommended for WSL)
- MATE (modern fork of GNOME 2)
- KDE Plasma (feature-rich, modern interface)
- GNOME (full-featured)

### X Server Setup

For GUI applications to work, you'll need an X Server running on Windows:

1. Install an X Server on Windows:
   - [VcXsrv](https://sourceforge.net/projects/vcxsrv/) (Free, open-source)
   - [X410](https://x410.dev/) (Paid, available from Microsoft Store)

2. Configure it to accept connections from WSL (disable access control)

3. Start the X Server before launching GUI applications

## Requirements

- Windows 10 version 1809 or later
- WSL 1 or 2
- X Server for Windows
- Bash shell

## Troubleshooting

### Common Issues

- **X Server Connection Failed**: Make sure your X Server is running on Windows and configured to allow connections.

- **Audio Not Working**: Verify that PulseAudio is correctly configured on both WSL and Windows.

- **Missing Dependencies**: Run `wsl-gui-pack install` to install required dependencies.

### Logs

Logs are stored in `~/.wsl-gui-pack/logs/` and can help diagnose issues.

## Acknowledgements

- The WSL team at Microsoft
- The X.Org Foundation
- All desktop environment developers
