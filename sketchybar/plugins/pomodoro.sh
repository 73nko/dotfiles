#!/usr/bin/env bash
# Pomodoro renderer. Reads state from /tmp/sketchybar-pomodoro and updates the pill.
# State file format (single line):
#   idle
#   running <epoch_end>
#   paused <seconds_left>
source "$HOME/.config/sketchybar/colors.sh"

GLYPH=$''   # nf-fa-hourglass_half
STATE_FILE="/tmp/sketchybar-pomodoro"
DURATION_DEFAULT=$((25 * 60))

[ -f "$STATE_FILE" ] || echo "idle" > "$STATE_FILE"

read -r STATE ARG < "$STATE_FILE"
NOW="$(date +%s)"

case "$STATE" in
  running)
    REMAINING=$(( ARG - NOW ))
    if [ "$REMAINING" -le 0 ]; then
      # Session finished — flip to idle and chime
      echo "idle" > "$STATE_FILE"
      afplay /System/Library/Sounds/Glass.aiff >/dev/null 2>&1 &
      osascript -e 'display notification "Pomodoro done." with title "Focus session complete" sound name "Glass"' >/dev/null 2>&1 &
      sketchybar --set "$NAME" \
                 icon="$GLYPH" \
                 icon.color="$MAGENTA" \
                 label="done" \
                 label.color="$MAGENTA"
      exit 0
    fi
    MM=$(( REMAINING / 60 ))
    SS=$(( REMAINING % 60 ))
    LABEL="$(printf '%d:%02d' "$MM" "$SS")"
    if [ "$REMAINING" -le 300 ]; then
      COLOR="$MAGENTA"   # last 5 minutes — push
    else
      COLOR="$TANGERINE"
    fi
    sketchybar --set "$NAME" \
               icon="$GLYPH" icon.color="$COLOR" \
               label="$LABEL" label.color="$COLOR"
    ;;

  paused)
    MM=$(( ARG / 60 ))
    SS=$(( ARG % 60 ))
    LABEL="$(printf ' %d:%02d' "$MM" "$SS")"   # nf-fa-pause-circle
    sketchybar --set "$NAME" \
               icon="$GLYPH" icon.color="$PEACH" \
               label="$LABEL" label.color="$PEACH"
    ;;

  *)  # idle
    sketchybar --set "$NAME" \
               icon="$GLYPH" icon.color="$FAINT" \
               label="" label.color="$FAINT"
    ;;
esac
