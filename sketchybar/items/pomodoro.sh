#!/usr/bin/env bash
# Pomodoro pill.
#   Click left  → toggle (idle → running → paused → running ...)
#   Click right → reset to idle
sketchybar --add item pomodoro right \
           --set pomodoro \
                 update_freq=1 \
                 icon.font="JetBrainsMono Nerd Font:Bold:14.0" \
                 icon.color="$FAINT" \
                 label.font="JetBrainsMono Nerd Font:Semibold:12.0" \
                 label.color="$FAINT" \
                 background.color="$BG_PILL_QUIET" \
                 background.corner_radius=999 \
                 background.height=22 \
                 background.padding_left=2 \
                 background.padding_right=2 \
                 click_script="$PLUGIN_DIR/pomodoro_click.sh" \
                 script="$PLUGIN_DIR/pomodoro.sh"
