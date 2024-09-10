#!/bin/bash

# Mikrotik WinBox4 Install Helper
# This script downloads and installs Mikrotik WinBox4, sets up a symlink, 
# creates a desktop entry, and migrates previous WinBox data.

# Function to print error message and exit
handle_error() {
    echo "An error occurred during the installation process. Exiting."
    exit 1
}

# Exit on any non-zero command and handle errors
set -e
trap 'handle_error' ERR

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root to install WinBox4."
    exit 1
fi

# Check if 'unzip' is installed
if ! command -v unzip &> /dev/null; then
    echo "'unzip' command could not be found. Please install 'unzip' and try again."
    exit 1
fi

# Variables
# Get the actual user who invoked sudo
if [ -n "$SUDO_USER" ]; then
    ORIGINAL_USER="$SUDO_USER"
    ORIGINAL_HOME="/home/$SUDO_USER"
else
    ORIGINAL_USER=$(whoami)
    ORIGINAL_HOME="$HOME"
fi
DOWNLOAD_URL="https://download.mikrotik.com/routeros/winbox/4.0beta4/WinBox_Linux.zip"
DOWNLOAD_DIR=$(sudo -u "$ORIGINAL_USER" xdg-user-dir DOWNLOAD)  # Using xdg-user-dir to ensure localization support
WINBOX_DIR="winbox4"
WINBOX_INSTALL_DIR="/opt/$WINBOX_DIR"
SYMLINK_PATH="/usr/local/bin/winbox"
DESKTOP_FILE_PATH="/usr/share/applications/winbox4.desktop"
PREVIOUS_ADDRESSES_PATH="$ORIGINAL_HOME/.winbox/drive_c/users/$ORIGINAL_USER/AppData/Roaming/Mikrotik/Winbox/Addresses.cdb"
MIKROTIK_DATA_PATH="$ORIGINAL_HOME/.local/share/MikroTik"
NEW_ADDRESSES_PATH="$ORIGINAL_HOME/.local/share/MikroTik/WinBox/Addresses.cdb"
NEW_DOWNLOAD_URL=$(wget --https-only -qO- https://mikrotik.com/download | grep 'Linux</a></li>' | grep -oP 'href="\K[^"]+')

# Step 0: Check if download URL is changed
if [ "$DOWNLOAD_URL" != "$NEW_DOWNLOAD_URL" ]; then
    echo "Download URL has changed from $DOWNLOAD_URL to $NEW_DOWNLOAD_URL. Updating..."
    DOWNLOAD_URL="$NEW_DOWNLOAD_URL"
fi

# Step 1: Download the official archive
echo "Downloading WinBox4 archive..."
cd "$DOWNLOAD_DIR" || exit 1
wget "$DOWNLOAD_URL" -O WinBox_Linux.zip || exit 1
# change the ownership to the original user
chown "$ORIGINAL_USER":"$ORIGINAL_USER" WinBox_Linux.zip || exit 1

# Step 2: Unpack archive to 'winbox4'
echo "Unpacking WinBox4 archive..."
unzip WinBox_Linux.zip -d "$WINBOX_DIR" || exit 1

# Step 3: Move 'winbox4' to /opt/ (skip if already exists)
if [ -d "$WINBOX_INSTALL_DIR" ]; then
    echo "Directory $WINBOX_INSTALL_DIR already exists, skipping move."
else
    echo "Moving WinBox4 to /opt/..."
    mv "$WINBOX_DIR" "$WINBOX_INSTALL_DIR" || exit 1
fi

# Step 4: Create symlink to /usr/local/bin (skip if already exists)
if [ -L "$SYMLINK_PATH" ]; then
    echo "Symlink $SYMLINK_PATH already exists, skipping creation."
else
    echo "Creating symlink for WinBox..."
    ln -s "$WINBOX_INSTALL_DIR/WinBox" "$SYMLINK_PATH" || exit 1
fi

# Step 5: Create desktop file (skip if already exists)
if [ -f "$DESKTOP_FILE_PATH" ]; then
    echo "Desktop entry $DESKTOP_FILE_PATH already exists, skipping creation."
else
    echo "Creating desktop entry for WinBox4..."
    cat > "$DESKTOP_FILE_PATH" <<EOL
[Desktop Entry]
Type=Application
Name=WinBox4
Icon=$WINBOX_INSTALL_DIR/assets/img/winbox.png
Exec=$WINBOX_INSTALL_DIR/WinBox
Comment=Mikrotik WinBox GUI for Router Management
Categories=Network;System;
EOL
fi

# Step 6: Notify about successful installation
echo "Installation completed successfully. WinBox4 has been installed."
echo "Now attempting to locate and migrate previous WinBox data..."

# Step 7: Try to find and migrate 'Addresses.cdb'
if [ -f "$PREVIOUS_ADDRESSES_PATH" ]; then
    echo "Previous WinBox data found. Migrating Addresses.cdb..."
    if [ -f "$NEW_ADDRESSES_PATH" ]; then
        echo "Addresses.cdb already exists at $NEW_ADDRESSES_PATH, skipping migration."
    else
        sudo -u "$ORIGINAL_USER" mkdir -p "$(dirname "$NEW_ADDRESSES_PATH")" || exit 1
        cp "$PREVIOUS_ADDRESSES_PATH" "$NEW_ADDRESSES_PATH" || exit 1
        # change the ownership to the original user
        chown "$ORIGINAL_USER":"$ORIGINAL_USER" "$NEW_ADDRESSES_PATH" || exit 1
        echo "Addresses.cdb has been successfully migrated to the new installation."
    fi
else
    echo "No previous Addresses.cdb found."
fi

# Step 8: Notify about result
echo "WinBox4 is ready to use."

