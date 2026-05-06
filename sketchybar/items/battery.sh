#!/usr/bin/env bash
# Battery — gold per §02 ("numbers, booleans, battery"). Glyph swaps by level.
sketchybar --add item battery right \
           --set battery \
                 update_freq=120 \
                 icon.color="$GOLD" \
                 icon.font="JetBrainsMono Nerd Font:Bold:14.0" \
                 label.color="$GOLD" \
                 background.drawing=off \
                 script="$PLUGIN_DIR/battery.sh" \
           --subscribe battery system_woke power_source_change
