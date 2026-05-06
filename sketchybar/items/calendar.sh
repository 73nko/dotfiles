#!/usr/bin/env bash
# Date — rosegold muted, transparent bg. Quiet companion to the clock.
sketchybar --add item calendar right \
           --set calendar \
                 update_freq=60 \
                 icon="$ICON_CALENDAR" \
                 icon.color="$MUTED" \
                 label.color="$MUTED" \
                 background.drawing=off \
                 script="$PLUGIN_DIR/calendar.sh"
