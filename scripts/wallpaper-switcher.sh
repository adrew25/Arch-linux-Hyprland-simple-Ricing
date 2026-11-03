#!/bin/bash
# Wallpaper picker using the same Rofi palette as app search.
set -euo pipefail
wallpaper_dir="$HOME/Pictures/wallpapers"
mkdir -p "$wallpaper_dir"
mapfile -d '' -t wallpapers < <(find "$wallpaper_dir" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.gif' \) -print0 | sort -z)
if (( ${#wallpapers[@]} == 0 )); then
    notify-send 'No wallpapers' 'Add images to ~/Pictures/wallpapers/'
    exit 0
fi
# Select by index, so filenames are never interpreted as shell commands.
choice=$(
    for wallpaper in "${wallpapers[@]}"; do
        printf '%s\0icon\x1f%s\n' "${wallpaper##*/}" "$wallpaper"
    done | rofi -config "$HOME/.config/rofi/config.rasi" -dmenu -i -no-custom \
        -p Wallpaper -format i -show-icons \
        -theme-str 'entry { placeholder: "Search wallpapers…"; } textbox { str: "↑↓ navigate · Enter apply · Esc cancel"; }'
) || exit 0
[[ "$choice" =~ ^[0-9]+$ ]] || exit 0
(( choice < ${#wallpapers[@]} )) || exit 0
wallpaper="${wallpapers[choice]}"
if ! awww query > /dev/null 2>&1; then
    awww-daemon > /dev/null 2>&1 &
    for attempt in {1..20}; do
        awww query > /dev/null 2>&1 && break
        sleep 0.1
    done
fi
awww img "$wallpaper" --transition-type wipe --transition-duration 2 --transition-fps 60 --transition-angle 30
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}"
mkdir -p "$cache_dir"
printf '%s\n' "$wallpaper" > "$cache_dir/current_wallpaper"
notify-send 'Wallpaper changed' "${wallpaper##*/}" -i "$wallpaper" -t 3000
