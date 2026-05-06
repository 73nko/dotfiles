#!/usr/bin/env bash
source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/colors.sh"

# Try the volume_change payload first; fall back to AppleScript.
VOLUME="$INFO"
if [ -z "$VOLUME" ] || [ "$VOLUME" = "missing value" ]; then
  VOLUME="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)"
fi
MUTED="$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)"

# Some audio outputs (HDMI, DisplayPort, certain Bluetooth devices) don't expose
# system volume to AppleScript. Show "--" with mute glyph instead of "missing value%".
case "$VOLUME" in
  ''|missing*|*[!0-9]*)
    sketchybar --set "$NAME" icon="$ICON_VOL_MUTE" label="--"
    exit 0
    ;;
esac

if [ "$MUTED" = "true" ] || [ "$VOLUME" -eq 0 ]; then
  ICON="$ICON_VOL_MUTE"
elif [ "$VOLUME" -gt 60 ]; then
  ICON="$ICON_VOL_HIGH"
elif [ "$VOLUME" -gt 30 ]; then
  ICON="$ICON_VOL_MED"
else
  ICON="$ICON_VOL_LOW"
fi

sketchybar --set "$NAME" icon="$ICON" label="${VOLUME}%"
