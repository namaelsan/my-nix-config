#!/usr/bin/env bash

pkill waybar

$HOME/nixos/hosts/default/dotfiles/waybar/scripts/background.sh
waybar -c ~/nixos/hosts/default/dotfiles/waybar/config -s ~/nixos/hosts/default/dotfiles/waybar/style.css