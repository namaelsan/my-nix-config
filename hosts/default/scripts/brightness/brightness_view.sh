#!/usr/bin/env bash

# Usage: ./brightness.sh [ddcutil|brightnessctl]

get_ddcutil_percentage() {
    brightness_info=$(ddcutil getvcp 10 --brief 2>/dev/null)
    if [ $? -eq 0 ]; then
        current=$(echo "$brightness_info" | awk '{print $4}')
        max=$(echo "$brightness_info" | awk '{print $5}')
        percentage=$(( (current * 100) / max ))
        echo "{\"percentage\": $percentage, \"tooltip\": \"External: $percentage%\"}"
    else
        echo "{\"percentage\": 0, \"tooltip\": \"External: Disconnected\"}"
    fi
}

get_brightnessctl_percentage() {
    percentage=$(brightnessctl info 2>/dev/null | grep -oP 'Current brightness: \d+ \(\K\d+(?=%)' || echo "0")
    echo "{\"percentage\": $percentage, \"tooltip\": \"Built-in: $percentage%\"}"
}

case "$1" in
    "ddcutil") get_ddcutil_percentage ;;
    "brightnessctl") get_brightnessctl_percentage ;;
    *) echo "{\"percentage\": 0, \"tooltip\": \"Usage: $0 [ddcutil|brightnessctl]\"}" ;;
esac


# ~/nixos/hosts/default/scripts/brightness/brightness_view.sh brightnessctl
# ~/nixos/hosts/default/scripts/brightness/brightness_view.sh ddcutil