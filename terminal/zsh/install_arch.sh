#!/bin/bash
paru -S --noconfirm --needed zsh

ZSH_PATH=$(which zsh)
if ! grep -qxF "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
fi

chsh -s "$ZSH_PATH"
