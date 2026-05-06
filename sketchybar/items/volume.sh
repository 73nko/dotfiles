#!/usr/bin/env bash
# Volume — peach (warm secondary). Glyph swaps by level / mute state.
sketchybar --add item volume right \
           --set volume \
                 icon.color="$PEACH" \
                 icon.font="JetBrainsMono Nerd Font:Bold:14.0" \
                 label.color="$PEACH" \
                 background.drawing=off \
                 script="$PLUGIN_DIR/volume.sh" \
           --subscribe volume volume_change
