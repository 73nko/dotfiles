#!/usr/bin/env bash
# Apple logo — magenta, identity-warm. Click opens System Settings.
sketchybar --add item apple.logo left \
           --set apple.logo \
                 icon="$ICON_APPLE" \
                 icon.font="JetBrainsMono Nerd Font:Bold:16.0" \
                 icon.color="$MAGENTA" \
                 icon.padding_left=12 \
                 icon.padding_right=12 \
                 label.drawing=off \
                 background.color="$BG_PILL_WARM" \
                 background.corner_radius=999 \
                 background.height=24 \
                 click_script="open -b com.apple.systempreferences"
