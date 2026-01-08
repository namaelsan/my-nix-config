#!/usr/bin/env bash
pkill waybar

source ~/nixos/dotfiles/waybar/scripts/background.sh
waybar -c ~/nixos/dotfiles/waybar/config -s ~/nixos/dotfiles/waybar/style.css &
notify-send -t 2500 "Waybar Launched"