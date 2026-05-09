#!/usr/bin/env bash
# Next non-past calendar event (in progress or upcoming).
# Filters past events at the source via icalBuddy's eventsFrom:NOW range.
# All-day multi-day events are skipped (no "at HH:MM" segment).
# icalBuddy needs Calendar / Full Disk Access (System Settings > Privacy).
source "$HOME/.config/sketchybar/colors.sh"

ICALBUDDY="$(command -v icalBuddy 2>/dev/null)"
GLYPH=$''   # nf-fa-calendar
SEP="§§§"

if [ -z "$ICALBUDDY" ] || [ ! -x "$ICALBUDDY" ]; then
  sketchybar --set "$NAME" icon="$GLYPH" label="no icalBuddy" \
                           icon.color="$FAINT" label.color="$FAINT"
  exit 0
fi

NOW_DT="$(date '+%Y-%m-%d %H:%M:%S %z')"
END_DT="$(date -v+1d '+%Y-%m-%d 23:59:59 %z')"
TODAY="$(date '+%Y-%m-%d')"
TOMORROW="$(date -v+1d '+%Y-%m-%d')"

# -ps "|<sep>|" forces datetime and title onto one line separated by <sep>.
RAW="$("$ICALBUDDY" -nc -nrd -npn \
       -iep "title,datetime" \
       -po "datetime,title" \
       -df "%Y-%m-%d" -tf "%H:%M" \
       -ps "| ${SEP} |" \
       "eventsFrom:$NOW_DT" "to:$END_DT" 2>/dev/null)"

# Pick the first event with a real start/end time today or tomorrow.
LINE="$(echo "$RAW" | grep -E "^[•*-]+[[:space:]]+[0-9]{4}-[0-9]{2}-[0-9]{2}[[:space:]]+at[[:space:]]+[0-9]{2}:[0-9]{2}[[:space:]]+-[[:space:]]+[0-9]{2}:[0-9]{2}[[:space:]]+${SEP}[[:space:]]+" | head -1)"

if [ -z "$LINE" ]; then
  sketchybar --set "$NAME" icon="$GLYPH" label="—" \
                           icon.color="$MUTED" label.color="$MUTED"
  exit 0
fi

# Parse: "• 2026-05-07 at 17:00 - 17:15 §§§ Standup"
DATE="$(echo "$LINE"  | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)"
START="$(echo "$LINE" | grep -oE '[0-9]{2}:[0-9]{2}' | sed -n 1p)"
END="$(echo "$LINE"   | grep -oE '[0-9]{2}:[0-9]{2}' | sed -n 2p)"
TITLE="${LINE##*${SEP} }"
TITLE="${TITLE# }"          # strip leading space if any

# Compute label and color
NOW_HH="$(date '+%H')"
NOW_MM="$(date '+%M')"
NOW_INT=$((10#$NOW_HH * 60 + 10#$NOW_MM))
SH="${START%:*}"; SM="${START#*:}"
EH="${END%:*}";   EM="${END#*:}"
S_INT=$((10#$SH * 60 + 10#$SM))
E_INT=$((10#$EH * 60 + 10#$EM))

PREFIX=""
COLOR="$PEACH"

if [ "$DATE" = "$TOMORROW" ]; then
  PREFIX="mañ "
  COLOR="$MUTED"
elif [ "$DATE" = "$TODAY" ]; then
  if [ "$S_INT" -le "$NOW_INT" ] && [ "$NOW_INT" -lt "$E_INT" ]; then
    PREFIX="● "                # in progress now
    COLOR="$MAGENTA_HI"
  else
    DIFF=$((S_INT - NOW_INT))
    if [ "$DIFF" -ge 0 ] && [ "$DIFF" -le 60 ]; then
      COLOR="$MAGENTA_HI"      # urgent: starts within an hour
    fi
  fi
fi

LABEL="${PREFIX}${START} - ${END} ${TITLE}"

sketchybar --set "$NAME" icon="$GLYPH" \
                         icon.color="$COLOR" \
                         label="$LABEL" label.color="$COLOR"
