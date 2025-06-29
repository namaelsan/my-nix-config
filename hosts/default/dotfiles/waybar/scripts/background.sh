#!/usr/bin/env bash

# Paths
WALLPAPER_DIR="$HOME/Wallpapers"  # Change to your wallpapers folder
SELECTED_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)  # Select random wallpaper

# Set the wallpaper
swww img "$SELECTED_WALLPAPER" --transition-type random --transition-duration 3

# Generate colors using pywal
wal -n -e --cols16 darken -i "$SELECTED_WALLPAPER" 
cp $SELECTED_WALLPAPER ~/.cache/current_wp
