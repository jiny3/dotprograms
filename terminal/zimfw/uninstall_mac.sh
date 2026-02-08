#!/bin/bash
# Uninstall zimfw
rm -rf ~/.zim
# Remove zimfw lines from .zshrc if they exist (macOS sed syntax)
if [ -f ~/.zshrc ]; then
    sed -i '.bak' '/zimfw/d' ~/.zshrc 2>/dev/null || true
    rm -f ~/.zshrc.bak
fi
