#!/usr/bin/env bash
# Wi-Fi — turquoise hi. Cool/structural per palette rules.
sketchybar --add item wifi right \
           --set wifi \
                 update_freq=15 \
                 icon.color="$TURQUOISE_HI" \
                 icon.font="JetBrainsMono Nerd Font:Bold:14.0" \
                 label.drawing=off \
                 background.drawing=off \
                 script="$PLUGIN_DIR/wifi.sh" \
                 click_script="open /System/Library/PreferencePanes/Network.prefPane" \
           --subscribe wifi wifi_change
