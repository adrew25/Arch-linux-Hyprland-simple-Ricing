# My Arch Linux Dotfiles

Personal configuration files for Arch Linux with Hyprland.

## Setup Overview
- **WM**: Hyprland
- **Bar**: Waybar with Catppuccin theme
- **Terminal**: Alacritty
- **File Manager**: Thunar
- **Theme**: Catppuccin Mocha

## Installation

1. Clone this repository:
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

2. Install packages:

```bash
    ./install-packages.sh
```

3. Install dotfiles:

```bash
    ./install.sh
```

3. Reload Hyprland:
```bash
    hyprctl reload
```

## Manual Setup Required

1. Configure Qt6 applications:

```bash
    qt6ct
    # Set style to "breeze6" and icon theme to "Papirus-Dark"
```

2. Set up Kvantum theme (optional):

```bash
    kvantummanager
    # Select Catppuccin theme
```

## File Structure

hypr/ - Hyprland configuration
waybar/ - Waybar configuration and styling
alacritty/ - Terminal configuration
nvim/ - Neovim configuration
scripts/ - Custom scripts
themes/ - GTK and application themes

## Key Bindings

Super + T - Terminal
Super + E - File Manager
Super + R - App Launcher
Super + X - Power Menu
Alt + Shift - Switch Keyboard Layout (EN/GR)


## Update Script for Future Changes

```bash
cat > ~/dotfiles/update.sh << 'EOF'
    #!/bin/bash

    # Update dotfiles from current system config

    echo "Updating dotfiles from current configs..."

    cp ~/.config/hypr/hyprland.conf hypr/
    cp ~/.config/waybar/config waybar/
    cp ~/.config/waybar/style.css waybar/
    cp ~/.config/alacritty/alacritty.toml alacritty/
    cp -r ~/.config/nvim/* nvim/ 2>/dev/null || echo "No nvim config found"
    cp ~/.local/bin/power-menu.sh scripts/

    # Update package lists
    pacman -Qqe > packages.txt
    pacman -Qqm > aur-packages.txt

    echo "Dotfiles updated! Don't forget to commit and push changes."
    EOF

    chmod +x ~/dotfiles/update.sh
```


