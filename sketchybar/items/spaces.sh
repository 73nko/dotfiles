#!/usr/bin/env bash
# ============================================================================
# AeroSpace workspace pills (1..9).
# Active workspace -> turquoise pill (cool / focus, per Style Guide §02).
# Inactive         -> rosegold @ 35%, transparent bg.
# Modified marker  -> magenta dot, only when the workspace has windows.
# ============================================================================

for sid in 1 2 3 4 5 6 7 8 9; do
  sketchybar --add item space.$sid left \
             --subscribe space.$sid aerospace_workspace_change \
             --set space.$sid \
                   icon="$sid" \
                   icon.font="JetBrainsMono Nerd Font:Bold:13.0" \
                   icon.color="$MUTED" \
                   icon.padding_left=10 \
                   icon.padding_right=10 \
                   label.drawing=off \
                   background.color="$TRANSPARENT" \
                   background.corner_radius=999 \
                   background.height=22 \
                   click_script="aerospace workspace $sid" \
                   script="$PLUGIN_DIR/aerospace.sh $sid"
done

# Initial paint — ask aerospace which workspace is focused right now.
sketchybar --trigger aerospace_workspace_change \
           FOCUSED_WORKSPACE="$(aerospace list-workspaces --focused 2>/dev/null || echo 1)"
