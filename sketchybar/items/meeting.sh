#!/usr/bin/env bash
# Next calendar event from native macOS Calendar via icalBuddy.
sketchybar --add item meeting right \
           --set meeting \
                 update_freq=60 \
                 icon.font="JetBrainsMono Nerd Font:Bold:14.0" \
                 icon.color="$PEACH" \
                 label.color="$PEACH" \
                 label.max_chars=32 \
                 background.color="$BG_PILL_QUIET" \
                 background.corner_radius=999 \
                 background.height=22 \
                 background.padding_left=2 \
                 background.padding_right=2 \
                 click_script="open -a Calendar" \
                 script="$PLUGIN_DIR/meeting.sh"
