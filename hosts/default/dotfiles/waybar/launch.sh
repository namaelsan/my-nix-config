#!/usr/bin/env bash

pkill waybar

source ~/nixos/hosts/default/dotfiles/waybar/scripts/background.sh
waybar -c ~/nixos/hosts/default/dotfiles/waybar/config -s ~/nixos/hosts/default/dotfiles/waybar/style.css
notify-send -t 2500 "Waybar Launched"

# Restart Hyprland to apply the changes
hyprctl reload