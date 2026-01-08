#!/usr/bin/env bash

monitor=$1
current_brightness=$(xrandr --verbose | grep -A10 "^$monitor" | grep -m1 "Brightness" | awk '{print $2}')

if [ -z "$current_brightness" ]; then
    echo "N/A"
    exit 1
fi

case "$2" in
    up)
        new=$(echo "$current_brightness + 0.05" | bc -l | awk '{if ($1>1) print 1; else print $1}')
        ;;
    down)
        new=$(echo "$current_brightness - 0.05" | bc -l | awk '{if ($1<0.1) print 0.1; else print $1}')
        ;;
    *)
        echo "$monitor $(echo "$current_brightness * 100" | bc -l | awk '{printf "%.0f%%\n", $1}')"
        exit 0
        ;;
esac

xrandr --output "$monitor" --brightness "$new"
echo "$(echo "$new * 100" | bc -l | awk '{printf "%.0f%%\n", $1}')"