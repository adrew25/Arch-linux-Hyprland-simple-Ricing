#!/bin/bash

# Wallpaper Switcher for Hyprland using swww
# Shows wallpapers in wofi and applies with smooth transitions

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Check if swww daemon is running
if ! pgrep -x swww-daemon > /dev/null; then
    swww-daemon &
    sleep 1
fi

# Create wallpaper directory if it doesn't exist
mkdir -p "$WALLPAPER_DIR"

# Check if there are wallpapers
if [ -z "$(ls -A $WALLPAPER_DIR/*.{jpg,jpeg,png,webp} 2>/dev/null)" ]; then
    notify-send "No Wallpapers" "Add wallpapers to ~/Pictures/wallpapers/" -u critical
    exit 1
fi

# Get list of wallpapers and show in wofi
cd "$WALLPAPER_DIR" || exit 1
WALLPAPER=$(ls *.{jpg,jpeg,png,webp} 2>/dev/null | wofi --dmenu --prompt "Select Wallpaper" --width 600 --height 400)

if [ -n "$WALLPAPER" ]; then
    # Apply wallpaper with smooth transition
    swww img "$WALLPAPER_DIR/$WALLPAPER" \
        --transition-type wipe \
        --transition-duration 2 \
        --transition-fps 60 \
        --transition-angle 30
    
    # Save current wallpaper for persistence
    echo "$WALLPAPER_DIR/$WALLPAPER" > ~/.cache/current_wallpaper
    
    # Send notification
    notify-send "Wallpaper Changed" "$WALLPAPER" -i "$WALLPAPER_DIR/$WALLPAPER" -t 3000
fi