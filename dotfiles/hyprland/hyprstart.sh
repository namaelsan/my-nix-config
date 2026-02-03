#!/usr/bin/env bash

# run clipboard listener on startup
clipse -listen
# # wallpaper
swww-daemon &
# swww img ~/Wallpapers/wp9223560-4k-night-hd-wallpapers.jpg & ## unnecessary launch.sh launches background.sh
# network applet
nm-applet --indicator &
systemctl --user start hyprpolkitagent 
blueman-applet &
qbittorrent &
mako &