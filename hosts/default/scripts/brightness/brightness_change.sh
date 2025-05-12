#!/usr/bin/env bash

# Check arguments
if [ $# -lt 2 ]; then
    echo "Usage: $0 [u/d] [cursor_position]"
    exit 1
fi

cursor_position=$2
x_of_cursor=$(echo "$cursor_position" | cut -d ',' -f 1)

if [ "$x_of_cursor" -gt 0 ]; then
    display=1
    SIGNAL=5
else
    display=0
    SIGNAL=6
fi

if [ "$1" == "u" ]; then
    if [ "$display" -eq 0 ]; then
        ddcutil --noverify --sleep-multiplier 0.1 setvcp 10 + 10
    else
        brightnessctl s 10%+
    fi
elif [ "$1" == "d" ]; then
    if [ "$display" -eq 0 ]; then
        ddcutil --noverify --sleep-multiplier 0.1 setvcp 10 - 10
    else
        brightnessctl s 10%-
    fi
fi

if ["$display" -eq 0]; then 
    sleep 2.3
else
    sleep 0.06
fi

pkill -RTMIN+"$SIGNAL" waybar