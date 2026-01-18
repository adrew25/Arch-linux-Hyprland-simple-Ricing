#!/bin/bash
THEME_DIR="/home/adrew25/.config/hypr/themes"
CHOICE=$(ls $THEME_DIR | sed 's/\.conf//' | rofi -dmenu -p "Select Style")

if [ -n "$CHOICE" ]; then
    # 1. Update Hyprland Bridge
    ln -sf "$THEME_DIR/$CHOICE.conf" "/home/adrew25/.config/hypr/theme.conf"
    
    # 2. Update Ghostty Bridge
    # Ensure $CHOICE matches a valid Ghostty theme name (e.g., "tokyo-night")
    echo "theme = $CHOICE" > "/home/adrew25/.config/ghostty/current-theme"
    
    # 3. Reload everything
    hyprctl reload
    # Ghostty will reload automatically if it's running
    
    # 4. Set Wallpaper (Make sure $wallpaper is defined in your theme files)
    source "$THEME_DIR/$CHOICE.conf"
    swww img "$wallpaper" --transition-type center
fi
