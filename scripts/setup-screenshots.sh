#!/bin/bash

# Screenshot tool setup for Hyprland
# Uses grimblast - the easiest screenshot tool for Hyprland

echo "=========================================="
echo "Installing Screenshot Tools"
echo "=========================================="
echo ""

# Install grimblast (best for Hyprland)
echo "Installing grimblast..."
yay -S grimblast-git

# Install dependencies
sudo pacman -S grim slurp wl-clipboard

echo ""
echo "✓ Screenshot tools installed!"
echo ""
echo "Usage:"
echo "  Super + S           - Select area to screenshot"
echo "  Super + Shift + S   - Screenshot current window"
echo "  Super + Alt + S     - Screenshot entire screen"
echo ""
echo "Screenshots will be saved to ~/Pictures/screenshots/"
echo "and automatically copied to clipboard!"