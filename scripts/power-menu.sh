#!/bin/bash
# Power actions in the same themed Rofi panel as app search.
set -euo pipefail
choice=$(printf '%s\n' '󰐥  Shutdown' '󰜉  Reboot' '󰤄  Suspend' '󰌾  Lock' '󰍃  Logout' |
    rofi -config "$HOME/.config/rofi/config.rasi" -dmenu -i -no-custom \
        -p Power -format i -theme-str 'listview { columns: 1; lines: 5; } entry { placeholder: "Choose an action…"; } textbox { str: "↑↓ navigate · Enter select · Esc cancel"; }') || exit 0
case "$choice" in
    0) systemctl poweroff ;;
    1) systemctl reboot ;;
    2) systemctl suspend ;;
    3) hyprlock ;;
    4) hyprctl dispatch 'hl.dsp.exit()' ;;
esac
