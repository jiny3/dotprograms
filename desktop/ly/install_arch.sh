#!/bin/bash
paru -S --noconfirm --needed ly
systemctl enable ly@tty2.service
systemctl disable getty@tty2.service
