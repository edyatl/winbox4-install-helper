# Mikrotik WinBox4 Install Helper

This is a Bash script to automate the installation of Mikrotik WinBox4 on Linux distributions. The script downloads the official WinBox4 binaries, sets up a symlink for easy access, creates a desktop entry, and attempts to migrate previous WinBox data if available.

## Features

- Downloads the official Mikrotik WinBox4 binaries.
- Unpacks the archive and installs it to `/opt/winbox4`.
- Creates a symlink to `winbox` in `/usr/local/bin` for easy terminal access.
- Adds a desktop entry in `/usr/share/applications` for launching from the application manager.
- Migrates previous `Addresses.cdb` data from older installations (if found).
- Automatically checks the Mikrotik download page for updated versions of WinBox4.
- Avoids overwriting existing symlinks, desktop entries, and data.

## Prerequisites

- Linux distribution.
- Must be run as `root` or with `sudo` privileges to modify system directories.
- `wget` and `unzip` must be installed on the system.

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/edyatl/winbox4-install-helper.git
   ```

2. Navigate to the repository directory:

   ```bash
   cd winbox4-install-helper
   ```

3. Make the script executable:

   ```bash
   chmod +x winbox4_install.sh
   ```

4. Run the script as root:

   ```bash
   sudo ./winbox4_install.sh
   ```

## Script Details

### What the script does:

1. **Download**: It downloads the official Mikrotik WinBox4 archive from the [Mikrotik website](https://mikrotik.com/download).
2. **Install**: Unpacks the downloaded archive and moves it to `/opt/winbox4`.
3. **Symlink**: Creates a symlink from `/opt/winbox4/WinBox` to `/usr/local/bin/winbox` for easy command-line access.
4. **Desktop Entry**: Adds a `.desktop` entry in `/usr/share/applications/winbox4.desktop` to allow launching WinBox from the application menu.
5. **Data Migration**: Attempts to find previous `Addresses.cdb` data in `~/.winbox/drive_c/users/<user>/AppData/Roaming/Mikrotik/Winbox/Addresses.cdb` and copies it to the new installation at `~/.local/share/MikroTik/WinBox/Addresses.cdb`.
6. **Version Check**: Automatically checks the Mikrotik download page for new versions of WinBox4 and updates the installation if a new version is found.
7. **Avoids Overwriting**: If any symlink, desktop file, or address database already exists, the script skips these steps.

## Uninstallation

To completely uninstall WinBox4, you can use the provided uninstall script `winbox4_uninstall.sh`:

1. Make the script executable:

   ```bash
   chmod +x winbox4_uninstall.sh
   ```

2. Run the script as root:

   ```bash
   sudo ./winbox4_uninstall.sh
   ```

### What the uninstall script does:

1. **Removes the symlink**: Deletes the symlink `/usr/local/bin/winbox` used to launch WinBox from the terminal.
2. **Removes the desktop entry**: Deletes the `.desktop` file at `/usr/share/applications/winbox4.desktop` used to launch WinBox from the application menu.
3. **Removes the installation directory**: Deletes the WinBox4 installation folder located at `/opt/winbox4`.
4. **Preserves user data**: The script does not automatically delete your saved `Addresses.cdb` file. It will notify you if the file is found at `$HOME/.local/share/MikroTik/WinBox/Addresses.cdb`, allowing you to decide if you want to remove it manually.

### Manual Removal of User Data

If you wish to remove your saved addresses and configuration data, you can manually delete the file:

```bash
rm -rf ~/.local/share/MikroTik/WinBox
```

After running the uninstall script and optionally removing user data, WinBox4 will be fully removed from your system.

### Manual Uninstallation

To uninstall WinBox4 without uninstall script, you can manually remove the following:

1. Remove the symlink:

   ```bash
   sudo rm /usr/local/bin/winbox
   ```

2. Remove the installation directory:

   ```bash
   sudo rm -rf /opt/winbox4
   ```

3. Remove the desktop entry:

   ```bash
   sudo rm /usr/share/applications/winbox4.desktop
   ```

## Changelog

- **2024-09-10:**
    - Improved handling of `$HOME` and user environment when running the script with `sudo`:
      - The script now correctly identifies the original user invoking `sudo` using the `SUDO_USER` environment variable.
      - Updated file paths for downloading WinBox4 and migrating `Addresses.cdb` to reflect the original user's home directory, ensuring correct ownership and avoiding root's home.
      - Adjusted the `xdg-user-dir` call to use the original user’s environment by running it with `sudo -u $ORIGINAL_USER`.
      - Ensured file operations like `wget`, `unzip`, `mkdir`, and `cp` are executed as the original user to avoid permission issues.
    - Applied similar changes to the uninstall script to handle user-specific data correctly during the uninstallation process.

- **2024-09-09:**
    - Added automatic checking of new WinBox4 versions from the Mikrotik download page.
    - Improved script to detect and update the latest download link.

- **2024-09-07:**
    - Initial release with features to automate WinBox4 installation.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributions

Contributions are welcome! Please open an issue or submit a pull request if you have suggestions or improvements.

