#!/bin/bash

# WinBox4 Uninstall Script
# This script completely removes WinBox4, including the symlink, installation directory, and desktop entry.

# Function to print error message and exit
handle_error() {
    echo "An error occurred during the uninstallation process. Exiting."
    exit 1
}

# Exit on any non-zero command and handle errors
set -e
trap 'handle_error' ERR

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root to uninstall WinBox4."
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
WINBOX_INSTALL_DIR="/opt/winbox4"
SYMLINK_PATH="/usr/local/bin/winbox"
DESKTOP_FILE_PATH="/usr/share/applications/winbox4.desktop"
DATA_PATH="$ORIGINAL_HOME/.local/share/MikroTik/WinBox/Addresses.cdb"

# Step 1: Remove the symlink (if exists)
if [ -L "$SYMLINK_PATH" ]; then
    echo "Removing symlink $SYMLINK_PATH..."
    rm "$SYMLINK_PATH" || exit 1
else
    echo "Symlink $SYMLINK_PATH not found, skipping."
fi

# Step 2: Remove the desktop entry (if exists)
if [ -f "$DESKTOP_FILE_PATH" ]; then
    echo "Removing desktop entry $DESKTOP_FILE_PATH..."
    rm "$DESKTOP_FILE_PATH" || exit 1
else
    echo "Desktop entry $DESKTOP_FILE_PATH not found, skipping."
fi

# Step 3: Remove the WinBox4 installation directory (if exists)
if [ -d "$WINBOX_INSTALL_DIR" ]; then
    echo "Removing installation directory $WINBOX_INSTALL_DIR..."
    rm -rf "$WINBOX_INSTALL_DIR" || exit 1
else
    echo "Installation directory $WINBOX_INSTALL_DIR not found, skipping."
fi

# Step 4: Notify about the removal of user data
if [ -f "$DATA_PATH" ]; then
    echo "User data found at $DATA_PATH. You may want to remove it manually if no longer needed."
else
    echo "No user data found at $DATA_PATH."
fi

# Step 5: Final notification
echo "WinBox4 has been successfully uninstalled."

