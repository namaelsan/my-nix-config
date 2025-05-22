#!/usr/bin/env bash

# Get current power profile
CURRENT_PROFILE=$(powerprofilesctl get)

# Define icons
ICON_BALANCED=""
ICON_POWERSAVER=""
ICON_PERFORMANCE=""

# Handle click actions
case "$1" in
  "--left")
    case "$CURRENT_PROFILE" in
      "power-saver")
        powerprofilesctl set balanced
        polybar-msg action "#power-profiles.hook.0"
        ;;
      "balanced")
        powerprofilesctl set performance
        polybar-msg action "#power-profiles.hook.0"
        ;;
      "performance")
        powerprofilesctl set power-saver
        polybar-msg action "#power-profiles.hook.0"
        ;;
    esac
    ;;
  "--right")
      case "$CURRENT_PROFILE" in
      "power-saver")
        powerprofilesctl set performance
        polybar-msg action "#power-profiles.hook.0"
        ;;
      "balanced")
        powerprofilesctl set power-saver
        polybar-msg action "#power-profiles.hook.0"
        ;;
      "performance")
        powerprofilesctl set balanced
        polybar-msg action "#power-profiles.hook.0"
        ;;
    esac
  ;;
esac

# Display current profile
case "$CURRENT_PROFILE" in
  "power-saver")
    echo "$ICON_POWERSAVER"
    ;;
  "balanced")
    echo "$ICON_BALANCED"
    ;;
  "performance")
    echo "$ICON_PERFORMANCE"
    ;;
  *)
    echo "?"
    ;;
esac