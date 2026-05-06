#!/usr/bin/env bash
# Clock — turquoise bg, dusk fg, bold. The most prominent right-side item.
sketchybar --add item clock right \
           --set clock \
                 update_freq=10 \
                 icon="$ICON_CLOCK" \
                 icon.color="$DUSK" \
                 icon.font="JetBrainsMono Nerd Font:Bold:13.0" \
                 label.color="$DUSK" \
                 label.font="JetBrainsMono Nerd Font:Bold:12.0" \
                 background.color="$TURQUOISE" \
                 background.corner_radius=999 \
                 background.height=24 \
                 script="$PLUGIN_DIR/clock.sh"
