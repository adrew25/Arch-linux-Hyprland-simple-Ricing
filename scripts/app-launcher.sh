#!/bin/bash
# Native Wayland Rofi 2: search immediately, or browse the icon grid.
set -euo pipefail
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/app-launcher-${UID}.lock"
flock -n 9 || exit 0
args=(-config "$HOME/.config/rofi/config.rasi" -show drun)
if [[ "${1:-}" == "browse" ]]; then
    args+=(-theme-str 'listview { columns: 4; lines: 3; } element { orientation: vertical; spacing: 8px; } element-icon { size: 44px; horizontal-align: 0.5; } element-text { horizontal-align: 0.5; }')
fi
rofi "${args[@]}"
