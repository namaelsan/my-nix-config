#!/usr/bin/env bash

# Function to get current volume/mute state
get_state() {
  VOLUME=$(pamixer --get-volume-human)
  MUTE=$(pamixer --get-mute)
  if [ "$MUTE" = "true" ]; then
    echo " MUTED"
  else
    echo " $VOLUME"
  fi
}

# Handle arguments
case $1 in
  "--up")
    pamixer --increase 10
    polybar-msg hook pipewire-simple 1
    ;;
  "--down")
    pamixer --decrease 10
    polybar-msg hook pipewire-simple 1
    ;;
  "--mute")
    pamixer --toggle-mute
    polybar-msg hook pipewire-simple 1
    ;;
esac

# Always output the current state (required for `tail = true`)
get_state