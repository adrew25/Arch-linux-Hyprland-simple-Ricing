#!/bin/bash
# Dotfiles installation script - Complete setup

set -e

echo "=========================================="
echo "Installing Dotfiles - Dark Glass Rice"
echo "=========================================="
echo ""

# Create necessary directories
echo "Creating directories..."
mkdir -p ~/.config/{hypr,waybar,ghostty,nvim,gtk-3.0,gtk-4.0}
mkdir -p ~/.local/bin
mkdir -p ~/Pictures/{wallpapers,screenshots}

# Backup existing configs
backup_dir="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

echo "Backing up existing configs to $backup_dir"
[ -d ~/.config/hypr ] && cp -r ~/.config/hypr "$backup_dir/" 2>/dev/null || true
[ -d ~/.config/waybar ] && cp -r ~/.config/waybar "$backup_dir/" 2>/dev/null || true
[ -d ~/.config/ghostty ] && cp -r ~/.config/ghostty "$backup_dir/" 2>/dev/null || true
[ -d ~/.config/alacritty ] && cp -r ~/.config/alacritty "$backup_dir/" 2>/dev/null || true
[ -d ~/.config/nvim ] && cp -r ~/.config/nvim "$backup_dir/" 2>/dev/null || true

echo ""
echo "=========================================="
echo "Installing Configurations"
echo "=========================================="
echo ""

# Install Hyprland config
echo "→ Installing Hyprland config..."
if [ -f hypr/hyprland.conf ]; then
    cp hypr/hyprland.conf ~/.config/hypr/
    echo "  ✓ Hyprland config installed"
else
    echo "  ✗ hypr/hyprland.conf not found!"
fi

# Install Waybar config
echo "→ Installing Waybar config (dark glass theme)..."
if [ -f waybar/config ] && [ -f waybar/style.css ]; then
    cp waybar/config ~/.config/waybar/
    cp waybar/style.css ~/.config/waybar/
    echo "  ✓ Waybar config installed"
else
    echo "  ✗ Waybar configs not found!"
fi

# Install Ghostty config
echo "→ Installing Ghostty config..."
if [ -f ghostty/config ]; then
    cp ghostty/config ~/.config/ghostty/
    echo "  ✓ Ghostty config installed"
else
    echo "  ⚠ ghostty/config not found (skipping)"
fi

# Install Alacritty config (backup)
if [ -f alacritty/alacritty.toml ]; then
    echo "→ Installing Alacritty config (backup)..."
    mkdir -p ~/.config/alacritty
    cp alacritty/alacritty.toml ~/.config/alacritty/
    echo "  ✓ Alacritty config installed"
fi

# Install Neovim config
echo "→ Installing Neovim config..."
if [ -f nvim/init.lua ]; then
    mkdir -p ~/.config/nvim
    cp nvim/init.lua ~/.config/nvim/
    [ -f nvim/lazy-lock.json ] && cp nvim/lazy-lock.json ~/.config/nvim/
    [ -d nvim/lua ] && cp -r nvim/lua ~/.config/nvim/
    echo "  ✓ Neovim config installed"
else
    echo "  ⚠ Neovim config not found (skipping)"
fi

# Install scripts
echo "→ Installing scripts..."
if [ -d scripts ]; then
    cp scripts/* ~/.local/bin/ 2>/dev/null || true
    chmod +x ~/.local/bin/* 2>/dev/null || true
    echo "  ✓ Scripts installed to ~/.local/bin/"
    
    # List installed scripts
    if [ -f ~/.local/bin/wallpaper-switcher.sh ]; then
        echo "    - wallpaper-switcher.sh"
    fi
    if [ -f ~/.local/bin/restore-wallpaper.sh ]; then
        echo "    - restore-wallpaper.sh"
    fi
    if [ -f ~/.local/bin/random-wallpaper.sh ]; then
        echo "    - random-wallpaper.sh"
    fi
    if [ -f ~/.local/bin/power-menu.sh ]; then
        echo "    - power-menu.sh"
    fi
else
    echo "  ⚠ scripts/ directory not found (skipping)"
fi

# Install theme configs
echo "→ Installing theme configs..."
[ -f themes/mimeapps.list ] && cp themes/mimeapps.list ~/.config/
[ -f themes/gtk3-settings.ini ] && cp themes/gtk3-settings.ini ~/.config/gtk-3.0/settings.ini
[ -f themes/gtk4-settings.ini ] && cp themes/gtk4-settings.ini ~/.config/gtk-4.0/settings.ini
echo "  ✓ Theme configs installed"

# Set GTK theme
echo "→ Setting GTK theme..."
gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-mocha-blue-standard+default' 2>/dev/null || true
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark' 2>/dev/null || true
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
echo "  ✓ GTK theme configured"

# SDDM theme installation (optional)
echo ""
read -p "Install SDDM astronaut theme? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "→ Installing SDDM astronaut theme..."
    
    # Install gum dependency
    sudo pacman -S --needed gum
    
    # Install astronaut theme
    if [ ! -d /usr/share/sddm/themes/sddm-astronaut-theme ]; then
        echo "  Downloading astronaut theme..."
        git clone https://github.com/Keyitdev/sddm-astronaut-theme.git /tmp/sddm-astronaut-theme
        sudo cp -r /tmp/sddm-astronaut-theme /usr/share/sddm/themes/sddm-astronaut-theme
        sudo rm -rf /tmp/sddm-astronaut-theme
    fi
    
    # Install SDDM config
    if [ -f sddm/sddm.conf ]; then
        sudo cp sddm/sddm.conf /etc/sddm.conf
    fi
    echo "  ✓ SDDM theme installed"
fi

echo ""
echo "=========================================="
echo "✓ Installation Complete!"
echo "=========================================="
echo ""
echo "Installed components:"
echo "  ✓ Hyprland config with wallpaper & screenshot support"
echo "  ✓ Waybar with dark glass theme"
echo "  ✓ Ghostty terminal config"
echo "  ✓ Wallpaper scripts (switcher, random, restore)"
echo "  ✓ GTK themes and configs"
echo "  ✓ Custom scripts"
echo ""
echo "Backup location: $backup_dir"
echo ""
echo "=========================================="
echo "Next Steps"
echo "=========================================="
echo ""
echo "1. Add wallpapers:"
echo "   cp your-wallpapers/* ~/Pictures/wallpapers/"
echo ""
echo "2. Reload Hyprland:"
echo "   hyprctl reload"
echo "   # Or logout and login again"
echo ""
echo "3. Test keybindings:"
echo "   Super + Space    - App launcher (wofi)"
echo "   Super + Return   - Terminal (ghostty)"
echo "   Super + B        - Wallpaper switcher"
echo "   Super + S        - Screenshot (area)"
echo ""
echo "4. Optional: Logout to see SDDM theme"
echo ""
echo "Enjoy your dark glass rice! 🚀"
echo ""