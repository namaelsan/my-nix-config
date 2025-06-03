#!/usr/bin/env bash

# Configuration - adjust these to match your setup
declare -A MONITOR_WORKSPACES=(
    ["eDP-1"]="1 2 3 4 5 6 7 8 9 10"
    ["HDMI-1-0"]="11 12 13 14 15 16 17 18 19 20"
)

# Get the pressed number from argument
NUMBER="$1"
if ! [[ "$NUMBER" =~ ^[0-9]+$ ]]; then
    echo "Error: Argument must be a number between 1-10"
    exit 1
fi

if (( NUMBER < 1 || NUMBER > 10 )); then
    echo "Error: Number must be between 1-10"
    exit 1
fi

# Get focused monitor using i3-msg
FOCUSED_MONITOR=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).output')

if [[ -z "$FOCUSED_MONITOR" ]]; then
    echo "Error: Could not determine focused monitor"
    exit 1
fi

# Get workspace list for this monitor
WORKSPACES=(${MONITOR_WORKSPACES["$FOCUSED_MONITOR"]})

if [[ -z "${WORKSPACES[*]}" ]]; then
    echo "Error: No workspace mapping found for monitor $FOCUSED_MONITOR"
    exit 1
fi

# Calculate array index (0-based)
INDEX=$((NUMBER - 1))

# Get the target workspace number
TARGET_WS="${WORKSPACES[$INDEX]}"

if [[ -z "$TARGET_WS" ]]; then
    echo "Error: No workspace mapped for number $NUMBER on monitor $FOCUSED_MONITOR"
    exit 1
fi

# Switch to the workspace
i3-msg "workspace number $TARGET_WS" > /dev/null