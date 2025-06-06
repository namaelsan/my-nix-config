#!/usr/bin/env bash

focused_window=$(xdotool getwindowfocus -f)
output=$(xdotool getwindowgeometry --shell $focused_window)
width=$(echo $output | awk '{print $4}' | cut -d "=" -f 2)
height=$(echo $output | awk '{print $5}' | cut -d "=" -f 2)
echo $width
echo $height
if [ $width == $height ]; then
    if [ $width == 1 ]; then
        exit
    fi
fi

move_y=$((height / 2))
move_x=$((width / 2))
xdotool mousemove --window $focused_window $move_x $move_y