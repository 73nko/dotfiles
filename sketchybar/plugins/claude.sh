#!/usr/bin/env bash
# ============================================================================
# Plugin del indicador de Claude Code (Violet Hour).
# Se ejecuta en cada evento 'claude_status' y cada update_freq (1s) para el
# timer en vivo y el avance del spinner. Lee el estado que escribe el
# dispatcher helpers/claude_hook.sh.
# ============================================================================
source "$HOME/.config/sketchybar/colors.sh"

STATE_FILE="$HOME/.claude/statusbar-sb/state"

state=idle; label=""; turn_start=0
if [ -f "$STATE_FILE" ]; then
  state="$(sed -n 's/^state=//p' "$STATE_FILE")"
  label="$(sed -n 's/^label=//p' "$STATE_FILE")"
  turn_start="$(sed -n 's/^turn_start=//p' "$STATE_FILE")"
fi
state="${state:-idle}"
turn_start="${turn_start:-0}"

# Spinner braille (unicode estandar, render garantizado en Nerd Font).
# Avanza 1 frame/seg: es el limite de update_freq de sketchybar, no morph
# suave como la app original, pero lee como "trabajando".
SPIN=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)

fmt_elapsed() {
  local s=$(( $(date +%s) - turn_start ))
  [ "$s" -lt 0 ] && s=0
  if [ "$s" -ge 60 ]; then echo "$((s / 60))m $((s % 60))s"; else echo "${s}s"; fi
}

case "$state" in
  off|idle)
    # Siempre visible: ✦ tenue. 'off' (sin sesiones) tambien lo muestra para
    # que el item no desaparezca de la barra; solo se anima cuando hay trabajo.
    sketchybar --set "$NAME" drawing=on \
      icon="$ICON_CLAUDE" icon.color="$MUTED" \
      label.drawing=off \
      background.drawing=off
    ;;
  thinking|tool)
    frame="${SPIN[$(( $(date +%s) % ${#SPIN[@]} ))]}"
    el="$(fmt_elapsed)"
    txt="$label"
    [ -n "$el" ] && txt="$label · $el"
    sketchybar --set "$NAME" drawing=on \
      icon="$frame" icon.color="$MAGENTA" \
      label="$txt" label.drawing=on label.color="$ROSEGOLD" \
      background.color="$BG_PILL_WARM" background.drawing=on
    ;;
  awaiting)
    sketchybar --set "$NAME" drawing=on \
      icon="$ICON_CLAUDE_WAIT" icon.color="$GOLD" \
      label="Awaiting" label.drawing=on label.color="$GOLD" \
      background.color="$BG_PILL_TANG" background.drawing=on
    ;;
esac
