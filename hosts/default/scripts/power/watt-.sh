#!/usr/bin/env bash

power_path="/sys/class/power_supply/BAT0/current_now"
while true; do
if [[ -f "$power_path" ]]; then
    power_uw=$(cat "$power_path")
    # Use awk for floating-point division
    power_w=$(awk "BEGIN {printf \"%.2f\", $power_uw/100000}")
    echo "${power_w} W"
else
    echo "N/A"
fi
sleep 0.5
done