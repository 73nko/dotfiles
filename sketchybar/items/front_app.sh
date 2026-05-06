#!/usr/bin/env bash
# Front-app name — turquoise hi pill (active tab feel from §04).
sketchybar --add item front_app left \
           --set front_app \
                 icon.drawing=off \
                 label="$(osascript -e 'tell application "System Events" to get name of (first process whose frontmost is true)' 2>/dev/null || echo Desktop)" \
                 label.color="$TURQUOISE_HI" \
                 label.font="JetBrainsMono Nerd Font:Bold:12.0" \
                 background.color="$BG_PILL_COOL" \
                 background.corner_radius=999 \
                 background.height=22 \
                 background.padding_left=4 \
                 background.padding_right=4 \
                 script="$PLUGIN_DIR/front_app.sh" \
           --subscribe front_app front_app_switched
