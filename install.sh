#!/bin/bash

# Dotfiles installation script

echo "Installing dotfiles..."

# Create necessary directories
mkdir -p ~/.config/{hypr,waybar,alacritty,nvim,gtk-3.0,gtk-4.0}
mkdir -p ~/.local/bin

# Backup existing configs
backup_dir="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

echo "Backing up existing configs to $backup_dir"
[ -f ~/.config/hypr/hyprland.conf ] && cp ~/.config/hypr/hyprland.conf "$backup_dir/"
[ -f ~/.config/waybar/config ] && cp ~/.config/waybar/config "$backup_dir/"
[ -f ~/.config/waybar/style.css ] && cp ~/.config/waybar/style.css "$backup_dir/"
[ -f ~/.config/alacritty/alacritty.toml ] && cp ~/.config/alacritty/alacritty.toml "$backup_dir/"

# Install configs
echo "Installing Hyprland config..."
cp hypr/hyprland.conf ~/.config/hypr/

echo "Installing Waybar config..."
cp waybar/config ~/.config/waybar/
cp waybar/style.css ~/.config/waybar/

echo "Installing Alacritty config..."
cp alacritty/alacritty.toml ~/.config/alacritty/

echo "Installing Neovim config..."
cp -r nvim/* ~/.config/nvim/ 2>/dev/null || echo "No nvim config to install"

echo "Installing scripts..."
cp scripts/* ~/.local/bin/
chmod +x ~/.local/bin/*

echo "Installing theme configs..."
cp themes/mimeapps.list ~/.config/
cp themes/gtk3-settings.ini ~/.config/gtk-3.0/settings.ini
cp themes/gtk4-settings.ini ~/.config/gtk-4.0/settings.ini

echo "Setting GTK theme..."
gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-mocha-blue-standard+default'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

echo "Installation complete!"
echo "You may need to reload Hyprland: hyprctl reload"
