#!/usr/bin/env bash
# AeroSpace mode pill — visible only in resize mode (driven by plugin).
# Item stays drawing=on so its script runs on events; the *background* and
# label visibility is what we toggle.
sketchybar --add item aerospace_mode left \
           --set aerospace_mode \
                 drawing=on \
                 icon.drawing=off \
                 label.drawing=off \
                 label.font="JetBrainsMono Nerd Font:Bold:11.0" \
                 label.color="$DUSK" \
                 background.drawing=off \
                 background.color="$MAGENTA" \
                 background.corner_radius=999 \
                 background.height=22 \
                 background.padding_left=6 \
                 background.padding_right=6 \
                 padding_left=2 \
                 padding_right=2 \
                 script="$PLUGIN_DIR/aerospace_mode.sh" \
           --subscribe aerospace_mode aerospace_mode_change
