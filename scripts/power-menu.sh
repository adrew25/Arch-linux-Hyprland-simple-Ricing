#!/bin/bash

# Power menu using wofi
# Make sure wofi is installed: sudo pacman -S wofi

# Define options
options="⏻ Shutdown\n⏻ Reboot\n⏸ Suspend\n🔒 Lock\n🚪 Logout"

# Show menu and get choice
chosen=$(echo -e "$options" | wofi --dmenu --prompt="Power Menu" --width=300 --height=200)

# Execute based on choice
case $chosen in
    "⏻ Shutdown")
        systemctl poweroff
        ;;
    "⏻ Reboot")
        systemctl reboot
        ;;
    "⏸ Suspend")
        systemctl suspend
        ;;
    "🔒 Lock")
        hyprlock
        ;;
    "🚪 Logout")
        hyprctl dispatch exit
        ;;
esac
