#!/usr/bin/env bash
# Argument $1 is the workspace number this pill represents.
# $FOCUSED_WORKSPACE comes from the aerospace_workspace_change event.

source "$HOME/.config/sketchybar/colors.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" \
             background.drawing=on \
             background.color="$BG_PILL_COOL" \
             icon.color="$TURQUOISE_HI"
else
  sketchybar --set "$NAME" \
             background.drawing=off \
             icon.color="$MUTED"
fi
