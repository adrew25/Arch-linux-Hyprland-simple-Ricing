#!/bin/bash
# Run from a terminal inside Hyprland. A reload failure must not skip bar startup.
set -uo pipefail
hyprctl reload || printf 'Hyprland reload failed; attempting to start the bar anyway.\n' >&2
hyprctl configerrors || true
exec "$HOME/.local/bin/desktop-bar.sh" restart
