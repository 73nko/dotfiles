#!/usr/bin/env bash
# Next event in the next 12h. Output format: "<HH:MM> <title>" or "—" if nothing.
# icalBuddy needs Full Disk Access to read Calendar (System Settings > Privacy).
source "$HOME/.config/sketchybar/colors.sh"

ICALBUDDY=/opt/homebrew/bin/icalBuddy
GLYPH=$''   # nf-fa-calendar

if [ ! -x "$ICALBUDDY" ]; then
  sketchybar --set "$NAME" icon="$GLYPH" label="no icalBuddy" icon.color="$FAINT" label.color="$FAINT"
  exit 0
fi

# Format: "HH:MM Title". Strip everything else and limit length.
RAW="$("$ICALBUDDY" -nc -nrd -npn \
                    -iep title,datetime \
                    -po datetime,title \
                    -ps "/ /" \
                    -df "" -tf "%H:%M" \
                    -ea \
                    eventsToday+1 2>/dev/null | head -1)"

if [ -z "$RAW" ]; then
  sketchybar --set "$NAME" icon="$GLYPH" label="—" icon.color="$MUTED" label.color="$MUTED"
  exit 0
fi

# Strip leading bullet/dash/asterisk markers from icalBuddy output.
RAW="$(echo "$RAW" | sed -E 's/^[•\*\-]+[[:space:]]*//')"

# Compute "in NN min" if event is later today.
NOW="$(date +%H%M)"
EVTIME="$(echo "$RAW" | grep -oE '^[0-9]{1,2}:[0-9]{2}')"
LABEL="$RAW"
COLOR="$PEACH"
if [ -n "$EVTIME" ]; then
  H=${EVTIME%:*}; M=${EVTIME#*:}
  EV=$((10#$H * 60 + 10#$M))
  CUR=$((${NOW:0:2} * 60 + ${NOW:2:2}))
  DIFF=$((EV - CUR))
  if [ $DIFF -ge 0 ] && [ $DIFF -le 60 ]; then
    COLOR="$MAGENTA_HI"   # urgent: within an hour
  fi
fi

sketchybar --set "$NAME" icon="$GLYPH" label="$LABEL" \
                         icon.color="$COLOR" label.color="$COLOR"
