#!/bin/bash
paru -S --noconfirm --needed qemu-full libvirt virt-manager dnsmasq

usermod -aG libvirt "${USER}"
systemctl enable --now libvirtd
