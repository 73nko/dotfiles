#!/usr/bin/env bash
# GitHub: review-requested PRs + unread notifications.
sketchybar --add item github right \
           --set github \
                 update_freq=120 \
                 icon.font="JetBrainsMono Nerd Font:Bold:14.0" \
                 icon.color="$AQUA" \
                 label.color="$AQUA" \
                 background.color="$BG_PILL_QUIET" \
                 background.corner_radius=999 \
                 background.height=22 \
                 background.padding_left=2 \
                 background.padding_right=2 \
                 click_script="open https://github.com/notifications" \
                 script="$PLUGIN_DIR/github.sh"
