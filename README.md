# Arch Linux Final Setup Script

This is a post-installation script for Arch Linux. It automates the installation of common packages, fonts, and optional themes for SDDM and Grub.

## Features

- Enables `multilib` and `extra` repositories (prompted during execution)
- Updates system packages
- Installs essential packages including Steam, git, thunar, linux-firmwares, and multimedia tools
- Installs non essential packages but here for my own pleasure including deezer, Lutris (optionnal)
- Installs AUR packages like `ttf-twemoji-color`, `Visual Studio Code`, and `Teams`
- Configures emoji and flag fonts
- Optional: install [SDDM Astronaut themes](https://github.com/HANTALE-59/sddm-astronaut-random-theme)
- Optional: install [Elegant Grub themes](https://github.com/vinceliuice/Elegant-grub2-themes)
- Optional: install Lutris with dependencies
- Give tips to properly install lutris games and patch for sddm issue regarding nvidia GPU things

## Requirements

- Arch Linux installed and booted into a live environment or user account
- Internet connection

## Usage

1. Make the script executable and run it:
2. 

```bash
cd
git clone https://github.com/HANTALE-59/Arch-after-install.git
cd Arch-after-install
chmod +x arch-final-setup.sh
```
Run the script:
```
./arch-final-setup.sh
```
Follow the prompts for optional installations (SDDM themes, Grub, Lutris, etc.)

## Notes

- yay (AUR helper) is required. If not installed, the script can install it automatically.
- The script configures your fonts for proper emoji and flag display in the terminal.
- After running, restart your terminal to apply font changes.

This script is provided as-is. Use at your own risk.
