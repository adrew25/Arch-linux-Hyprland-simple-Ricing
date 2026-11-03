# My Arch Linux Dotfiles

Personal configuration files for Arch Linux with Hyprland - **minimal, modern, and beautiful**.

![Screenshot](screenshots/desktop.png)

## 🎨 Setup Overview

- **WM**: Hyprland with smooth animations
- **Bar**: Minimal Waybar with volume slider
- **Terminal**: Ghostty with transparency
- **Launcher**: Rofi app search and icon grid
- **File Manager**: Thunar
- **Theme**: Gruvbox by default, with six switchable Omarchy palettes
- **Font**: JetBrainsMono Nerd Font
- **Wallpapers**: Dynamic switching with awww

## ✨ Features

- 🌑 **Minimal desktop bar** - Compact layout with useful system status
- 🎨 **Dynamic wallpapers** - Smooth transitions with keyboard shortcuts
- 💎 **App search and browsing** - Fuzzy search, app icons and a grid view
- 🔄 **Persistent wallpapers** - Automatically restore on login
- 📊 **System monitoring** - CPU, RAM, network and volume slider
- ⌨️ **Greek/English keyboard** - Easy switching with Alt+Shift
- 🎭 **Shared theme palettes** - Coordinated bar, launcher, window borders and terminal

## 📦 Installation

### 1. Clone this repository

```bash
git clone https://github.com/adrew25/Arch-linux-Hyprland-simple-Ricing.git ~/dotfiles
cd ~/dotfiles
```

### 2. Install required packages

```bash
# Core packages
sudo pacman -S hyprland waybar ghostty rofi wofi wlogout awww \
               wireplumber pamixer networkmanager nm-connection-editor \
               ttf-jetbrains-mono-nerd pavucontrol thunar \
               hyprlock brightnessctl polkit-gnome python btop playerctl

# Screenshot helper (AUR, if using yay)
yay -S grimblast-git
```

### 3. Install dotfiles

```bash
# Installs configs, launcher scripts and palettes, and creates backups.
# Optional SDDM theme installation is prompted separately.
./install.sh
```

### 4. Add wallpapers

```bash
# Create wallpaper directory
mkdir -p ~/Pictures/wallpapers

# Add your wallpapers here
cp /path/to/your/wallpapers/* ~/Pictures/wallpapers/
```

### 5. Reload Hyprland

```bash
hyprctl reload
# Or logout and login again
```

## Hyprland 0.57 recovery (November 2026)

The active configuration is now `hypr/hyprland.lua`. The `.conf` is retained as a legacy reference; Hyprland 0.57 uses Lua. This migration preserves the newer local HDMI mapping, EN/GR keyboard toggle, Catppuccin borders, gaps, animations, audio startup, and the personal shortcuts (the unused Super + M shortcut was subsequently removed).

Validate before installing or reloading:

```bash
Hyprland --verify-config -c "$HOME/dotfiles/hypr/hyprland.lua"
hyprctl reload
hyprctl configerrors
```

`install.sh` installs the Lua config; `update.sh` saves it back to the repository. Wallpaper scripts use `awww`, the installed successor to `swww`. On the restored machine, `hyprlock` and `brightnessctl` are missing: install them with `sudo pacman -S hyprlock brightnessctl`. Hyprlock also needs a personal `~/.config/hypr/hyprlock.conf` before the lock shortcut can work.

Additional recovered shortcuts:

| Keys | Action |
| --- | --- |
| Super + Shift + S / A / D | Screenshot area / active window / all screens; save and copy |
| Super + Shift + F | Fullscreen (Super + F maximizes) |
| Super + grave | Toggle scratchpad `magic` |
| Super + Shift + grave | Move window to scratchpad |
| Alt + Tab | Wofi window picker (existing command retained) |
| Super + arrows | Focus window in that direction |
| Super + 0 / Shift + 0 | Workspace 10 / move window there |
| Super + left / right mouse drag | Move / resize window |

Suggested next improvements: configure a working lock screen and idle locking; replace the Wofi window picker if your Wofi build lacks that mode. The theme-selector scripts now open the shared Rofi theme picker.

## 🎮 Key Bindings

### General

| Keys                | Action                  |
| ------------------- | ----------------------- |
| `Super + Return`    | Terminal (ghostty)      |
| `Super + E`         | File Manager (Thunar)   |
| `Super + Space`     | App Launcher (Rofi)     |
| `Super + X`         | Power Menu              |
| `Super + Shift + L` | Lock Screen             |
| `Alt + Shift`       | Switch Keyboard (EN/GR) |

### Wallpapers

| Keys                | Action                     |
| ------------------- | -------------------------- |
| `Super + B`         | Choose wallpaper from menu |
| `Super + Shift + B` | Random wallpaper           |

### Window Management

| Keys        | Action          |
| ----------- | --------------- |
| `Super + W` | Close window    |
| `Super + V` | Toggle floating |
| `Super + F` | Maximize      |
| `Super + C` | Center window   |
| `Super + P` | Pseudo-tile     |
| `Super + J` | Toggle split    |

### Workspaces

| Keys                  | Action                   |
| --------------------- | ------------------------ |
| `Super + 1-9`         | Switch to workspace      |
| `Super + Shift + 1-9` | Move window to workspace |

## 📁 File Structure

```
.
├── hypr/                      # Hyprland configuration
│   └── hyprland.lua          # Active Hyprland 0.57+ Lua config
├── waybar/                    # Waybar configuration
│   ├── config                # Module configuration
│   └── style.css             # Dark glass theme
├── ghostty/                   # Ghostty terminal
│   └── config                # Terminal configuration
├── nvim/                      # Neovim configuration
│   ├── init.lua
│   └── lua/
├── scripts/                   # Custom scripts
│   ├── power-menu.sh         # Power menu
│   ├── wallpaper-switcher.sh # Wallpaper selector
│   ├── restore-wallpaper.sh  # Restore on login
│   └── random-wallpaper.sh   # Random wallpaper
├── themes/                    # GTK and application themes
│   ├── gtk3-settings.ini
│   ├── gtk4-settings.ini
│   └── mimeapps.list
├── update.sh                  # Update dotfiles from system
├── install.sh                 # Install dotfiles to system
└── README.md
```

## 🎨 Waybar Modules

**Left:** Launcher icon → Workspaces 1-5

**Center:** Date & Time (format: `23 13:00`)

**Right:**

- System Tray
- 💠 Disk usage
- 🟠 RAM usage
- 🔵 Network (shows up/down speeds & IP)
- 🟢 Audio (click for pavucontrol)
- 🔴 Power menu

## 🖼️ Wallpaper System

### Features

- **Dynamic switching** with wofi selector
- **Smooth transitions** (wipe, wave, grow effects)
- **Auto-restore** on login
- **Random wallpaper** option
- **Persistent** across reboots

### Supported Formats

`.jpg`, `.jpeg`, `.png`, `.webp`

### Adding Wallpapers

```bash
# Just drop images into the wallpapers folder
cp your-image.jpg ~/Pictures/wallpapers/

# Then press Super+B to select it!
```

## 🎨 Customization

### Adjust Waybar Transparency

Edit `~/.config/waybar/style.css`:

```css
window#waybar {
  background-color: rgba(11, 11, 17, 0.75); /* Change 0.75 */
}
```

### Adjust Ghostty Transparency

Edit `~/.config/ghostty/config`:

```
background-opacity = 0.85  # 0.0 = invisible, 1.0 = opaque
background-blur-radius = 30  # Blur amount
```

### Change Waybar Module Colors

Each module in `style.css` has a gradient - adjust the RGBA values:

```css
#memory {
  background: linear-gradient(135deg, rgba(250, 179, 135, 0.2), ...);
}
```

## 🔄 Updating Dotfiles

After making changes to your configs:

```bash
cd ~/dotfiles

# Update from system configs
./update.sh

# Commit changes
git add .
git commit -m "Update configs"
git push
```

## 🛠️ Manual Setup

### Qt6 Applications

```bash
qt6ct
# Set style to "breeze6" and icon theme to "Papirus-Dark"
```

### Kvantum Theme (Optional)

```bash
kvantummanager
# Select Catppuccin theme
```

### GTK Theme

The GTK theme is automatically set via `gsettings` in the install script.

## 📦 Package List

### Official Repos

```bash
hyprland waybar ghostty wofi wlogout
wireplumber pamixer networkmanager nm-connection-editor
ttf-jetbrains-mono-nerd pavucontrol thunar
hyprlock polkit-gnome
```

### AUR

```bash
awww  # Wallpaper daemon
```

## 🐛 Troubleshooting

### Waybar icons not showing

```bash
sudo pacman -S ttf-jetbrains-mono-nerd
fc-cache -fv
killall waybar && waybar &
```

### Wallpapers not working

```bash
# Check awww is running
pgrep awww-daemon

# Start it manually
awww-daemon &

# Test wallpaper
awww img ~/Pictures/wallpapers/yourimage.jpg
```

## 🙏 Credits

- Waybar style inspired by [RUNFUNRUN's dotfiles](https://github.com/RUNFUNRUN/dotfiles)
- [Catppuccin](https://github.com/catppuccin/catppuccin) theme
- [Hyprland](https://hyprland.org/) community
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com/)

## 📄 License

Feel free to use and modify these dotfiles for your own setup!

---

**Enjoy your minimal and beautiful Hyprland rice! 🚀**

## Minimal bar and app launcher

Super + Space opens a centered Rofi app palette with fuzzy search, icons and launch history. Open it without typing to browse installed apps. Super + Alt + Space opens a larger four-column icon grid. Clicking the Arch icon in the bar opens search; right-clicking opens the grid. Required package: `rofi` (2.x with native Wayland support). This is an Omarchy-inspired appearance using Waybar/Rofi; Omarchy 4 itself uses its own Quickshell desktop.

The 32px bar shows workspaces, the active window, date/time, CPU/RAM, EN/GR layout, network, volume with a slider, keep-awake toggle, tray and power. Click CPU/RAM for btop, network for connections, audio for sound settings; right-click audio to mute. Scroll over audio to adjust volume. Click EN/GR to switch layouts. Hover for detailed status.

Sources: `waybar/config`, `waybar/style.css`, `rofi/config.rasi`, `rofi/apps.rasi`, `scripts/app-launcher.sh`. Local launcher config links to this repository.

Mattermost launch shortcuts, wrappers and package-list entries have been removed. Local app data was moved into the desktop recovery backup. To uninstall the system package from a normal terminal: `sudo pacman -Rns mattermost-desktop`. A local hidden desktop entry excludes it from launchers until uninstall.

Apply changes from a Hyprland terminal: `~/.local/bin/reload-desktop.sh`. The script reloads Hyprland, restarts Waybar, and saves the bar log in `~/.local/state/desktop/waybar.log`.

## Omarchy palettes and reliable bar startup

`Super + Ctrl + T` opens the theme picker (also middle-click the Arch icon). Six official Omarchy palettes are bundled: Catppuccin, Tokyo Night, Osaka Jade, Kanagawa, Gruvbox and Matte Black. The picker updates Waybar, Rofi, Hyprland borders and Ghostty together. These are adapted color palettes; Omarchy 4's full Quickshell desktop, GTK themes, wallpapers, and editor integrations are separate.

Use `~/.local/bin/desktop-theme.py --list`, `--apply tokyo-night`, or `--import /path/to/colors.toml --name custom-name`. Imported themes stay in `~/.config/desktop-theme/custom/`; generated files and the selected theme live in `~/.config/desktop-theme/`. Ghostty reloads colors after selection. Theme sources and upstream license are under `themes/omarchy/`.

Waybar now starts both on login and on config reload if it is missing, with a lock to prevent duplicate starts. `~/.local/bin/reload-desktop.sh` restarts it even if the Hyprland reload fails, waits for startup, and reports errors from `~/.local/state/desktop/waybar.log`. The bar explicitly uses native Wayland. Run this reload command in a terminal in your desktop if changes have not appeared yet.

The saved theme in `themes/desktop-current.json` is Gruvbox. Fresh installations restore it automatically.

Wallpaper selection (`Super + B`) and power actions (`Super + X`) use the same Rofi theme as the app launcher. Wallpaper entries show image thumbnails; all menus follow the selected Omarchy palette.
