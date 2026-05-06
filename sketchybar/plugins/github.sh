#!/usr/bin/env bash
# Reads `gh` CLI for PRs that have review requested from me + unread notifications.
# Falls back gracefully if offline / not logged in.
source "$HOME/.config/sketchybar/colors.sh"

GH="$(command -v gh 2>/dev/null)"
GLYPH=$''   # nf-fa-github

if [ -z "$GH" ] || [ ! -x "$GH" ] || ! "$GH" auth status >/dev/null 2>&1; then
  sketchybar --set "$NAME" icon="$GLYPH" label="--" icon.color="$FAINT" label.color="$FAINT"
  exit 0
fi

PRS="$(timeout 6 "$GH" search prs --review-requested=@me --state=open --json url --jq 'length' 2>/dev/null)"
NOTIFS="$(timeout 6 "$GH" api notifications --jq 'length' 2>/dev/null)"
PRS="${PRS:-0}"
NOTIFS="${NOTIFS:-0}"

# Color rule: highlight if there's actionable stuff.
if [ "$PRS" -gt 0 ]; then
  COLOR="$MAGENTA"          # someone is waiting on you
elif [ "$NOTIFS" -gt 0 ]; then
  COLOR="$AQUA"             # background notifs only
else
  COLOR="$FAINT"             # all clear
fi

LABEL="${PRS}/${NOTIFS}"
sketchybar --set "$NAME" icon="$GLYPH" label="$LABEL" \
                         icon.color="$COLOR" label.color="$COLOR"
