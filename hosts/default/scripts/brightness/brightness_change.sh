#!/usr/bin/env bash

# Lock file to prevent ddcutil bus crashes
LOCKFILE="/tmp/ddcutil_monitor.lock"

# Check arguments
if [ $# -lt 2 ]; then
    echo "Usage: $0 [u/d] [cursor_position]"
    exit 1
fi

cursor_position=$2
# Extract X coordinate
x_of_cursor=$(echo "$cursor_position" | cut -d ',' -f 1)

# Logic: 
# If cursor X > 0, it treats it as Internal Display (brightnessctl)
# If cursor X <= 0, it treats it as External Display (ddcutil)
if [ "$x_of_cursor" -gt 0 ]; then
    TARGET="internal"
    SIGNAL=5
else
    TARGET="external"
    SIGNAL=6
fi

# --- EXECUTION ---

if [ "$TARGET" == "external" ]; then
    # EXTERNAL MONITOR (Protected by Lock)
    (
        # Wait for the lock (fd 200)
        flock 200

        if [ "$1" == "u" ]; then
            # Using your working flags: bus 14, noverify, sleep-multiplier
            ddcutil --bus 14 --noverify --sleep-multiplier 4 setvcp 10 + 10
        elif [ "$1" == "d" ]; then
            ddcutil --bus 14 --noverify --sleep-multiplier 4 setvcp 10 - 10
        fi
        
        # KEY CHANGE: Sleep INSIDE the lock. 
        # This prevents the next command from starting too soon.
        # Reduced to 0.4s because locking makes it safe.
        sleep 0.4

    ) 200>"$LOCKFILE"

else
    # INTERNAL MONITOR (Fast, no lock needed)
    if [ "$1" == "u" ]; then
        brightnessctl s 10%+
    elif [ "$1" == "d" ]; then
        brightnessctl s 10%-
    fi
fi

# Refresh Waybar
pkill -RTMIN+"$SIGNAL" waybar