#!/usr/bin/env bash
# Toggles the RESIZE pill based on AeroSpace mode trigger.
# The item itself stays drawing=on so we still receive events; we toggle
# the background and label drawings to make it visually appear/disappear.
source "$HOME/.config/sketchybar/colors.sh"

if [ "$MODE" = "resize" ]; then
  sketchybar --set "$NAME" \
             label="RESIZE" \
             label.drawing=on \
             background.drawing=on
else
  sketchybar --set "$NAME" \
             label.drawing=off \
             background.drawing=off
fi
