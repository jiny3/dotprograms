#!/bin/bash
# Install paru from AUR (requires base-devel and git)
sudo pacman -S --noconfirm --needed base-devel git
git clone https://aur.archlinux.org/paru.git /tmp/paru-install
cd /tmp/paru-install
makepkg -si --noconfirm --needed
cd -
rm -rf /tmp/paru-install
