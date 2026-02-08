#!/bin/bash
# 安装 flatpak
paru -S --noconfirm --needed flatpak

# 添加 Flathub 仓库（如果尚未添加）
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

