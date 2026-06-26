#!/usr/bin/env bash
# ============================================================================
# Indicador de Claude Code. SIEMPRE visible: un ✦ tenue cuando idle, animado
# cuando Claude trabaja. update_freq=1 + updates=on para que el timer y el
# spinner avancen. Lo enciende/anima el dispatcher via el evento claude_status.
# ============================================================================
sketchybar --add item claude right \
  --set claude \
    update_freq=1 \
    updates=on \
    drawing=on \
    icon="$ICON_CLAUDE" \
    icon.color="$MUTED" \
    label.drawing=off \
    background.height=22 \
    background.corner_radius=999 \
    background.drawing=off \
    script="$PLUGIN_DIR/claude.sh" \
  --subscribe claude claude_status
