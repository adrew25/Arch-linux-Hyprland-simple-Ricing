#!/bin/bash

# Set random wallpaper from wallpapers directory

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Check if swww daemon is running
if ! pgrep -x swww-daemon > /dev/null; then
    swww-daemon &
    sleep 1
fi

# Get random wallpaper
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | shuf -n 1)

if [ -n "$WALLPAPER" ]; then
    # Apply with random transition
    TRANSITIONS=("wipe" "wave" "grow" "outer" "random")
    RANDOM_TRANSITION=${TRANSITIONS[$RANDOM % ${#TRANSITIONS[@]}]}
    
    swww img "$WALLPAPER" \
        --transition-type "$RANDOM_TRANSITION" \
        --transition-duration 2 \
        --transition-fps 60
    
    # Save current wallpaper
    echo "$WALLPAPER" > ~/.cache/current_wallpaper
    
    # Notify
    WALLPAPER_NAME=$(basename "$WALLPAPER")
    notify-send "Random Wallpaper" "$WALLPAPER_NAME" -i "$WALLPAPER" -t 3000
fi