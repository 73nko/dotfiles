#!/usr/bin/env bash
# Amphetamine — keep-awake state. Click toggles a session.
sketchybar --add item amphetamine right \
           --set amphetamine \
                 update_freq=15 \
                 icon.font="JetBrainsMono Nerd Font:Bold:14.0" \
                 icon.color="$FAINT" \
                 label.drawing=off \
                 background.color="$BG_PILL_QUIET" \
                 background.corner_radius=999 \
                 background.height=22 \
                 background.padding_left=2 \
                 background.padding_right=2 \
                 click_script="$PLUGIN_DIR/amphetamine_toggle.sh && sketchybar --update" \
                 script="$PLUGIN_DIR/amphetamine.sh"
