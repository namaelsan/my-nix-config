#!/usr/bin/env bash

# Paths
WALLPAPER_DIR="$HOME/Wallpapers"  # Change to your wallpapers folder
SELECTED_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)  # Select random wallpaper

# 1. Calculate Brightness
# Returns a value between 0 (black) and 1 (white)
# We check the standard deviation to avoid issues with high contrast images, 
# but mean is usually enough.
BRIGHTNESS=$(magick "$SELECTED_WALLPAPER" -colorspace gray -format "%[fx:mean]" info:)

# Threshold: < 0.5 is Dark, > 0.5 is Light
if (( $(echo "$BRIGHTNESS < 0.5" | bc -l) )); then
    MODE="dark"
    GTK_MODE="prefer-dark"
    echo "export BtnCol='white'" > ~/.cache/wlogout_theme
else
    MODE="light"
    GTK_MODE="prefer-light"
    echo "export BtnCol='black'" > ~/.cache/wlogout_theme
fi

echo "Detected Brightness: $BRIGHTNESS -> Mode: $MODE"

# 2. Generate Colors (Using Matugen for Material Design or Wallust)
# Matugen is great because you can FORCE the mode.
matugen image "$SELECTED_WALLPAPER" -m $MODE

# 3. Apply to System (The "Imperative" part)

# --- GTK (Gnome/GTK Apps) ---
gsettings set org.gnome.desktop.interface color-scheme $GTK_MODE
# Optional: force specific theme names if you have them installed
# gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-$MODE"

# --- QT (KDE/QT Apps) ---
# QT is tricky on Hyprland. The best way is to tell it to follow GTK.
# Ensure you have 'qt5ct' or 'qt6ct' installed and configured.
# You can use a sed command to swap the setting in qt5ct.conf if needed,
# but usually, setting the GTK mode is enough if using Adwaita-qt.

# --- Set Wallpaper ---
swww img "$SELECTED_WALLPAPER" --transition-type fade
cp $SELECTED_WALLPAPER ~/.cache/current_wp