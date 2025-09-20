#!/bin/bash

echo "Installing packages from package lists..."

# Install official packages
sudo pacman -S --needed - < packages.txt

# Install AUR packages (requires yay)
if command -v yay &> /dev/null; then
    yay -S --needed - < aur-packages.txt
else
    echo "yay not found. Install AUR packages manually from aur-packages.txt"
fi

echo "Package installation complete!"
