#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Paths
WALLPAPER_DIR="$HOME/Wallpapers"  # Change to your wallpapers folder
SELECTED_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)  # Select random wallpaper
POLYBAR_CONFIG="$HOME/nixos/hosts/default/dotfiles/i3/polybar/config"

# Set the wallpaper
feh --bg-fill $SELECTED_WALLPAPER

# Generate colors using pywal
wal -n -e --cols16 darken -i "$SELECTED_WALLPAPER" 
cp $SELECTED_WALLPAPER ~/.cache/current_wp
xrdb -merge $HOME/.cache/wal/colors.Xresources
~/nixos/hosts/default/scripts/sublimetext4/pywal_sublime.py
i3-msg reload

# Launch mybar
echo "---" | tee -a /tmp/polybar1.log

MONITOR=HDMI-1-0 polybar mybar --config=$POLYBAR_CONFIG 2>&1 | tee -a /tmp/polybar1.log & disown &
MONITOR=eDP-1 polybar secondary --config=$POLYBAR_CONFIG 2>&1 | tee -a /tmp/polybar2.log & disown &

echo "Bars launched..."

# start notification daemon
killall .dunst-wrapped ; dunst -config ~/.cache/wal/dunstrc
