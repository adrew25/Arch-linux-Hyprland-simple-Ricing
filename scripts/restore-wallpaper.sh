#!/bin/bash

# Restore last wallpaper on Hyprland startup

# Start swww daemon
swww-daemon &
sleep 1

# Restore last wallpaper
if [ -f ~/.cache/current_wallpaper ]; then
    WALLPAPER=$(cat ~/.cache/current_wallpaper)
    if [ -f "$WALLPAPER" ]; then
        swww img "$WALLPAPER" --transition-type fade --transition-duration 1
    else
        # If saved wallpaper doesn't exist, use first available
        FIRST_WALL=$(find ~/Pictures/wallpapers -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | head -1)
        if [ -n "$FIRST_WALL" ]; then
            swww img "$FIRST_WALL" --transition-type fade --transition-duration 1
            echo "$FIRST_WALL" > ~/.cache/current_wallpaper
        fi
    fi
else
    # First time - set first wallpaper
    FIRST_WALL=$(find ~/Pictures/wallpapers -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | head -1)
    if [ -n "$FIRST_WALL" ]; then
        swww img "$FIRST_WALL" --transition-type fade --transition-duration 1
        echo "$FIRST_WALL" > ~/.cache/current_wallpaper
    fi
fi