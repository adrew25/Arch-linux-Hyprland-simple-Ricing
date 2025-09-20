#!/bin/bash

# Update dotfiles from current system config

echo "Updating dotfiles from current configs..."

cp ~/.config/hypr/hyprland.conf hypr/
cp ~/.config/waybar/config waybar/
cp ~/.config/waybar/style.css waybar/
cp ~/.config/alacritty/alacritty.toml alacritty/

# Copy nvim config properly
mkdir -p nvim
cp ~/.config/nvim/init.lua nvim/ 2>/dev/null || echo "No init.lua found"
cp ~/.config/nvim/lazy-lock.json nvim/ 2>/dev/null || echo "No lazy-lock.json found"
cp -r ~/.config/nvim/lua nvim/ 2>/dev/null || echo "No lua directory found"

cp ~/.local/bin/power-menu.sh scripts/ 2>/dev/null || echo "No power-menu.sh found"

# Copy theme configs
cp ~/.config/mimeapps.list themes/ 2>/dev/null || echo "No mimeapps.list found"
cp ~/.config/gtk-3.0/settings.ini themes/gtk3-settings.ini 2>/dev/null || echo "No GTK3 settings found"
cp ~/.config/gtk-4.0/settings.ini themes/gtk4-settings.ini 2>/dev/null || echo "No GTK4 settings found"

# Update package lists
pacman -Qqe > packages.txt
pacman -Qqm > aur-packages.txt

echo "Dotfiles updated! Don't forget to commit and push changes."
