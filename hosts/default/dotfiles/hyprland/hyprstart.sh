#!/usr/bin/env bash

# run clipboard listener on startup
clipse -listen 
# wallpaper
swww-daemon &
swww img ~/Wallpapers/wp9223560-4k-night-hd-wallpapers.jpg &
# network applet
nm-applet --indicator & 


$terminal & 
~/nixos/hosts/default/dotfiles/waybar/launch.sh
mako 