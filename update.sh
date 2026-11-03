#!/bin/bash
# Update dotfiles from current system config

echo "=========================================="
echo "Updating dotfiles from system"
echo "=========================================="
echo ""

# Create directory structure
mkdir -p {hypr,waybar,ghostty,nvim,scripts,themes,screenshots}

# Hyprland
echo "  → Hyprland config"
# The live Lua config may already link into this repository.
for config in hyprland.lua hyprland.conf; do
    src="$HOME/.config/hypr/$config"
    dst="hypr/$config"
    if [ -f "$src" ] && ! [ "$src" -ef "$dst" ]; then
        cp "$src" "$dst"
    fi
done

# App launcher (skip files already linked into dotfiles).
mkdir -p rofi
for name in config.rasi apps.rasi; do
    src="$HOME/.config/rofi/$name"
    dst="rofi/$name"
    if [ -f "$src" ] && ! [ "$src" -ef "$dst" ]; then cp "$src" "$dst"; fi
done
cp ~/.local/bin/app-launcher.sh scripts/ 2>/dev/null || true
cp ~/.local/bin/reload-desktop.sh scripts/ 2>/dev/null || true

# Waybar (minimal style)
echo "  → Waybar config & style"
for name in config style.css colors.css; do
    src="$HOME/.config/waybar/$name"
    dst="waybar/$name"
    if [ -f "$src" ] && ! [ "$src" -ef "$dst" ]; then cp "$src" "$dst"; fi
done

# Ghostty (terminal)
echo "  → Ghostty config"
if [ -f ~/.config/ghostty/config ]; then
    cp ~/.config/ghostty/config ghostty/
else
    echo "    No ghostty config found"
fi

# Keep alacritty as backup if it exists
if [ -f ~/.config/alacritty/alacritty.toml ]; then
    echo "  → Alacritty config (backup)"
    mkdir -p alacritty
    cp ~/.config/alacritty/alacritty.toml alacritty/
fi

# Neovim config
echo "  → Neovim config"
cp ~/.config/nvim/init.lua nvim/ 2>/dev/null || echo "    No init.lua found"
cp ~/.config/nvim/lazy-lock.json nvim/ 2>/dev/null || echo "    No lazy-lock.json found"
cp -r ~/.config/nvim/lua nvim/ 2>/dev/null || echo "    No lua directory found"

# Scripts (including wallpaper scripts)
echo "  → Scripts"
cp ~/.local/bin/power-menu.sh scripts/ 2>/dev/null || echo "    No power-menu.sh found"
cp ~/.local/bin/wallpaper-switcher.sh scripts/ 2>/dev/null || echo "    No wallpaper-switcher.sh found"
cp ~/.local/bin/restore-wallpaper.sh scripts/ 2>/dev/null || echo "    No restore-wallpaper.sh found"
cp ~/.local/bin/random-wallpaper.sh scripts/ 2>/dev/null || echo "    No random-wallpaper.sh found"

# Preserve selected and imported desktop palettes for future restoration.
mkdir -p themes/omarchy-custom
if [ -d ~/.config/desktop-theme/custom ]; then
    cp ~/.config/desktop-theme/custom/*.json themes/omarchy-custom/ 2>/dev/null || true
fi
if [ -f ~/.config/desktop-theme/current.json ]; then
    /usr/bin/python3 -c 'import json, pathlib; p = pathlib.Path.home() / ".config/desktop-theme/current.json"; print(json.dumps({"name": json.loads(p.read_text())["name"]}, indent=2))' > themes/desktop-current.json
fi
for name in desktop-theme.py desktop-bar.sh theme-selector.sh theme-switcher.sh; do
    if [ -f "$HOME/.local/bin/$name" ]; then cp "$HOME/.local/bin/$name" scripts/; fi
done

# Theme configs
echo "  → Theme configs"
cp ~/.config/mimeapps.list themes/ 2>/dev/null || echo "    No mimeapps.list found"
cp ~/.config/gtk-3.0/settings.ini themes/gtk3-settings.ini 2>/dev/null || echo "    No GTK3 settings found"
cp ~/.config/gtk-4.0/settings.ini themes/gtk4-settings.ini 2>/dev/null || echo "    No GTK4 settings found"

# Copy latest screenshots (max 5)
echo "  → Screenshots"
if [ -d ~/Pictures/screenshots ]; then
    # Copy the 5 most recent screenshots
    find ~/Pictures/screenshots -type f \( -name "*.png" -o -name "*.jpg" \) -printf '%T@ %p\n' | \
    sort -rn | head -5 | cut -d' ' -f2- | \
    while read file; do
        cp "$file" screenshots/
    done
    echo "    Copied latest screenshots"
else
    echo "    No screenshots directory found"
fi

# Update package lists
echo "  → Package lists"
pacman -Qqe > packages.txt
pacman -Qqm > aur-packages.txt

echo ""
echo "=========================================="
echo "✓ Dotfiles updated successfully!"
echo "=========================================="
echo ""
echo "Summary:"
echo "  ✓ Hyprland config (with wallpaper & screenshot support)"
echo "  ✓ Waybar (dark glass theme)"
echo "  ✓ Ghostty terminal config"
echo "  ✓ Wallpaper scripts"
echo "  ✓ Latest screenshots"
echo "  ✓ Theme configs"
echo "  ✓ Package lists"
echo ""
echo "Next steps:"
echo "  git add ."
echo "  git commit -m 'Update configs'"
echo "  git push"
echo ""