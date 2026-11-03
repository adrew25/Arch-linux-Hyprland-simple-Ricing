#!/bin/bash
# Start reliably on login/reload; restart explicitly after a theme change.
set -euo pipefail
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/desktop"
mkdir -p "$state_dir"
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/desktop-bar-${UID}.lock"
flock -w 5 9 || exit 1
mode="${1:-ensure}"
fingerprint=$(sha256sum "$HOME/.config/waybar/config" "$HOME/.config/waybar/style.css" "$HOME/.config/waybar/colors.css" | sha256sum | cut -d ' ' -f 1)
if [[ "$mode" == ensure || "$mode" == start ]] && pgrep -u "$UID" -x waybar > /dev/null; then
    if [[ -f "$state_dir/waybar-config.sha256" ]] && [[ "$(<"$state_dir/waybar-config.sha256")" == "$fingerprint" ]]; then
        exit 0
    fi
    mode=restart
fi
case "$mode" in
    restart)
        pkill -u "$UID" -x waybar || true
        for attempt in {1..20}; do
            pgrep -u "$UID" -x waybar > /dev/null || break
            sleep 0.1
        done
        if pgrep -u "$UID" -x waybar > /dev/null; then
            echo 'Waybar did not exit; check the existing process.' >&2
            exit 1
        fi
        ;;
    ensure|start) ;;
    *) echo 'Usage: desktop-bar.sh [ensure|restart]' >&2; exit 2 ;;
esac
pgrep -u "$UID" -x waybar > /dev/null && exit 0
# Force the native Wayland backend rather than falling back to an X display.
GDK_BACKEND=wayland nohup waybar -c "$HOME/.config/waybar/config" -s "$HOME/.config/waybar/style.css" \
    9>&- > "$state_dir/waybar.log" 2>&1 < /dev/null &
bar_pid=$!
sleep 1
if ! kill -0 "$bar_pid" 2>/dev/null; then
    echo "Waybar failed to start. Log: $state_dir/waybar.log" >&2
    cat "$state_dir/waybar.log" >&2
    exit 1
fi
printf '%s\n' "$fingerprint" > "$state_dir/waybar-config.sha256"
echo "Waybar running (PID $bar_pid). Log: $state_dir/waybar.log"
