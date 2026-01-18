#!/bin/bash
# Theme Selector with Preview logic

THEME_DIR="$HOME/dotfiles/hypr/themes"
CHOICE=$(ls $THEME_DIR | sed 's/\.conf//' | rofi -dmenu -p "Select Theme" -theme-str 'window {width: 30%;}')

if [ -n "$CHOICE" ]; then
    # 1. Update the symlink that Hyprland reads
    ln -sf "$THEME_DIR/$CHOICE.conf" "$HOME/.config/hypr/theme.conf"
    
    # 2. Source the new wallpaper (using swww)
    source "$HOME/.config/hypr/theme.conf"
    swww img "$wallpaper" --transition-type center
    
    # 3. Reload Ghostty (Omarchy uses SIGUSR2)
    # We update a dynamic config file for Ghostty
    echo "theme = $CHOICE" > ~/.config/ghostty/theme
    killall -SIGUSR2 ghostty
    
    # 4. Notify
    notify-send "Theme Applied" "Switched to $CHOICE" -i "color-management"
fi
