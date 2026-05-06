#!/usr/bin/env bash
source "$HOME/.config/sketchybar/colors.sh"

GLYPH=""   # nf-fa-coffee

ACTIVE="$(timeout 2 osascript -e 'tell application "Amphetamine" to session is active' 2>/dev/null)"

if [ "$ACTIVE" = "true" ]; then
  COLOR="$TANGERINE"
else
  COLOR="$FAINT"
fi

sketchybar --set "$NAME" icon="$GLYPH" icon.color="$COLOR"
