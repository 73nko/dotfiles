#!/usr/bin/env bash
# ============================================================================
# Registra el indicador de Claude Code (sketchybar) en ~/.claude/settings.json.
# Merge IDEMPOTENTE: borra entradas previas nuestras y las re-añade, sin tocar
# el resto de tus hooks. Hace backup antes. Reversible con --uninstall.
#
# Uso:
#   bash ~/.config/scripts/claude-statusbar-install.sh
#   bash ~/.config/scripts/claude-statusbar-install.sh --uninstall
# Tras instalar: reinicia las sesiones de Claude Code (cargan hooks al arrancar).
# ============================================================================
set -euo pipefail

SETTINGS="$HOME/.claude/settings.json"
HOOK="$HOME/.config/sketchybar/helpers/claude_hook.sh"
EVENTS='["SessionStart","SessionEnd","UserPromptSubmit","PreToolUse","PostToolUse","Notification","Stop"]'

command -v jq >/dev/null 2>&1 || { echo "Falta jq (brew install jq)"; exit 1; }
mkdir -p "$HOME/.claude"
[ -f "$SETTINGS" ] || echo '{}' >"$SETTINGS"
cp "$SETTINGS" "$SETTINGS.bak-claude-sb"

tmp="$(mktemp)"

if [ "${1:-}" = "--uninstall" ]; then
  # Quita SOLO nuestras entradas (las que invocan $HOOK) de cada evento.
  jq --arg hook "$HOOK" '
    if .hooks then
      .hooks |= with_entries(
        .value |= map(select(((.hooks // []) | map(.command) | index($hook)) | not))
      )
      | .hooks |= with_entries(select((.value | length) > 0))
    else . end
  ' "$SETTINGS" >"$tmp" && mv "$tmp" "$SETTINGS"
  echo "Hooks de claude-status-bar (sketchybar) ELIMINADOS de $SETTINGS"
  echo "Backup: $SETTINGS.bak-claude-sb"
  exit 0
fi

jq --arg hook "$HOOK" --argjson events "$EVENTS" '
  .hooks //= {} |
  reduce $events[] as $ev (.;
    .hooks[$ev] = (
      ((.hooks[$ev] // [])
        # idempotente: descarta cualquier entrada previa que llame a $hook
        | map(select(((.hooks // []) | map(.command) | index($hook)) | not)))
      + [ { "hooks": [ { "type": "command", "command": $hook } ] } ]
    )
  )
' "$SETTINGS" >"$tmp" && mv "$tmp" "$SETTINGS"

echo "Hooks de claude-status-bar (sketchybar) instalados en $SETTINGS"
echo "Backup previo: $SETTINGS.bak-claude-sb"
echo "Reinicia las sesiones de Claude Code para que carguen los hooks."
