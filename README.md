# Mikrotik WinBox4 Install Helper

This is a Bash script to automate the installation of Mikrotik WinBox4 on Linux distributions. The script downloads the official WinBox4 binaries, sets up a symlink for easy access, creates a desktop entry, and attempts to migrate previous WinBox data if available.

## Features

- Downloads the official Mikrotik WinBox4 binaries.
- Unpacks the archive and installs it to `/opt/winbox4`.
- Creates a symlink to `winbox` in `/usr/local/bin` for easy terminal access.
- Adds a desktop entry in `/usr/share/applications` for launching from the application manager.
- Migrates previous `Addresses.cdb` data from older installations (if found).
- Avoids overwriting existing symlinks, desktop entries, and data.

## Prerequisites

- Linux distribution.
- Must be run as `root` or with `sudo` privileges to modify system directories.
- `wget` and `unzip` must be installed on the system.

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com:edyatl/winbox4-install-helper.git
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

1. **Download**: It downloads the official Mikrotik WinBox4 archive from the [Mikrotik website](https://download.mikrotik.com/routeros/winbox/4.0beta4/WinBox_Linux.zip).
2. **Install**: Unpacks the downloaded archive and moves it to `/opt/winbox4`.
3. **Symlink**: Creates a symlink from `/opt/winbox4/WinBox` to `/usr/local/bin/winbox` for easy command-line access.
4. **Desktop Entry**: Adds a `.desktop` entry in `/usr/share/applications/winbox4.desktop` to allow launching WinBox from the application menu.
5. **Data Migration**: Attempts to find previous `Addresses.cdb` data in `~/.winbox/drive_c/users/<user>/AppData/Roaming/Mikrotik/Winbox/Addresses.cdb` and copies it to the new installation at `~/.local/share/MikroTik/WinBox/Addresses.cdb`.
6. **Avoids Overwriting**: If any symlink, desktop file, or address database already exists, the script skips these steps.

## Uninstallation

To uninstall WinBox4, you can manually remove the following:

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

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributions

Contributions are welcome! Please open an issue or submit a pull request if you have suggestions or improvements.