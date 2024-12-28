#!/usr/bin/env bash

# Paths
WALLPAPER_DIR="$HOME/Wallpapers"  # Change to your wallpapers folder
SELECTED_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)  # Select random wallpaper
HYPR_CONFIG="$HOME/nixos/hosts/default/dotfiles/hyprland/hyprland.conf"
WAYBAR_STYLE="$HOME/nixos/hosts/default/dotfiles/waybar/style.css"

# Set the wallpaper
swww img "$SELECTED_WALLPAPER" --transition-type random --transition-duration 3

# Generate colors using pywal
wal -i "$SELECTED_WALLPAPER" -q -n

# Update Hyprland colors
# Replace colors in your Hyprland config using pywal colors
sed -i "s/^col.active_border = .*/col.active_border = $(cat ~/.cache/wal/colors | sed -n '2p');/" "$HYPR_CONFIG"
sed -i "s/^col.inactive_border = .*/col.inactive_border = $(cat ~/.cache/wal/colors | sed -n '3p');/" "$HYPR_CONFIG"
sed -i "s/^col.background = .*/col.background = $(cat ~/.cache/wal/colors | sed -n '1p');/" "$HYPR_CONFIG"

# # Update Waybar colors
# # Replace @define-color values in your Waybar style.css file
# sed -i "s/@define-color backgrounddark .*/@define-color backgrounddark $(cat ~/.cache/wal/colors | sed -n '1p');/" "$WAYBAR_STYLE"
# sed -i "s/@define-color backgroundlight .*/@define-color backgroundlight $(cat ~/.cache/wal/colors | sed -n '2p');/" "$WAYBAR_STYLE"
# sed -i "s/@define-color workspacesbackground1 .*/@define-color workspacesbackground1 $(cat ~/.cache/wal/colors | sed -n '3p');/" "$WAYBAR_STYLE"
# sed -i "s/@define-color workspacesbackground2 .*/@define-color workspacesbackground2 $(cat ~/.cache/wal/colors | sed -n '4p');/" "$WAYBAR_STYLE"
# sed -i "s/@define-color bordercolor .*/@define-color bordercolor $(cat ~/.cache/wal/colors | sed -n '5p');/" "$WAYBAR_STYLE"
# sed -i "s/@define-color textcolor1 .*/@define-color textcolor1 $(cat ~/.cache/wal/colors | sed -n '6p');/" "$WAYBAR_STYLE"
# sed -i "s/@define-color textcolor2 .*/@define-color textcolor2 $(cat ~/.cache/wal/colors | sed -n '7p');/" "$WAYBAR_STYLE"
# sed -i "s/@define-color iconcolor .*/@define-color iconcolor $(cat ~/.cache/wal/colors | sed -n '9p');/" "$WAYBAR_STYLE"

# Restart Hyprland and Waybar to apply the changes
hyprctl reload
