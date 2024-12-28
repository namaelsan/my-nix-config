#!/usr/bin/env bash

pkill waybar

waybar -c ~/nixos/hosts/default/dotfiles/config & -s ~/nixos/hosts/default/dotfiles/style.css