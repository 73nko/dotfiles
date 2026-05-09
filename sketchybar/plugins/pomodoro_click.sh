#!/usr/bin/env bash
# Pomodoro click handler.
#   left  -> toggle idle <-> running <-> paused <-> running
#   right -> reset to idle
STATE_FILE="/tmp/sketchybar-pomodoro"
DURATION=$((25 * 60))

[ -f "$STATE_FILE" ] || echo "idle" > "$STATE_FILE"
read -r STATE ARG < "$STATE_FILE"
NOW="$(date +%s)"

if [ "$BUTTON" = "right" ]; then
  echo "idle" > "$STATE_FILE"
elif [ "$BUTTON" = "left" ] || [ -z "$BUTTON" ]; then
  case "$STATE" in
    idle)
      echo "running $(( NOW + DURATION ))" > "$STATE_FILE"
      ;;
    running)
      LEFT=$(( ARG - NOW ))
      [ "$LEFT" -lt 0 ] && LEFT=0
      echo "paused $LEFT" > "$STATE_FILE"
      ;;
    paused)
      echo "running $(( NOW + ARG ))" > "$STATE_FILE"
      ;;
    *)
      echo "idle" > "$STATE_FILE"
      ;;
  esac
fi

# Force immediate redraw
sketchybar --update
