#!/usr/bin/env bash
# ============================================================================
# Claude Code -> SketchyBar · dispatcher de hooks (Glacier Signal)
# ----------------------------------------------------------------------------
# Equivalente nativo de claude-status-bar (m1ckc3s) para tu barra: como tu
# macos-tweaks.sh esconde la barra nativa, la app de menubar quedaria invisible.
# Esto vive en sketchybar, que es quien manda arriba.
#
# Lo registra ~/.config/scripts/claude-statusbar-install.sh en
# ~/.claude/settings.json para: SessionStart, SessionEnd, UserPromptSubmit,
# PreToolUse, PostToolUse, Notification, Stop.
#
# Lee el JSON del hook por STDIN, escribe el estado y dispara el evento
# sketchybar 'claude_status'. Debe ser instantaneo y NO imprimir nada en stdout
# (UserPromptSubmit añade el stdout al contexto del prompt: lo silenciamos todo).
# ============================================================================
set -u
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin"

STATE_DIR="$HOME/.claude/statusbar-sb"
STATE_FILE="$STATE_DIR/state"
COUNT_FILE="$STATE_DIR/sessions"
mkdir -p "$STATE_DIR"

input="$(cat)"
event="$(printf '%s' "$input" | jq -r '.hook_event_name // empty' 2>/dev/null)"
now="$(date +%s)"

write_state() { # state  label  turn_start
  printf 'state=%s\nlabel=%s\nturn_start=%s\n' "$1" "$2" "$3" >"$STATE_FILE"
}

read_turn_start() {
  if [ -f "$STATE_FILE" ]; then sed -n 's/^turn_start=//p' "$STATE_FILE"; else echo 0; fi
}

tool_label() {
  case "$1" in
    Edit|Write|MultiEdit|NotebookEdit|Update) echo "Editing" ;;
    Read|NotebookRead)                        echo "Reading" ;;
    Bash)                                     echo "Running command" ;;
    Grep|Glob)                                echo "Searching" ;;
    WebFetch|WebSearch)                       echo "Browsing" ;;
    Task)                                     echo "Delegating" ;;
    TodoWrite)                                echo "Planning" ;;
    *)                                        echo "Using tool" ;;
  esac
}

trigger() { sketchybar --trigger claude_status >/dev/null 2>&1 & }

case "$event" in
  SessionStart)
    c=0; [ -f "$COUNT_FILE" ] && c="$(cat "$COUNT_FILE" 2>/dev/null || echo 0)"
    echo "$((c + 1))" >"$COUNT_FILE"
    write_state idle "" 0
    ;;
  SessionEnd)
    c=1; [ -f "$COUNT_FILE" ] && c="$(cat "$COUNT_FILE" 2>/dev/null || echo 1)"
    c="$((c - 1))"; [ "$c" -lt 0 ] && c=0
    echo "$c" >"$COUNT_FILE"
    [ "$c" -le 0 ] && write_state off "" 0
    ;;
  UserPromptSubmit)
    write_state thinking "Thinking" "$now"
    ;;
  PreToolUse)
    tn="$(printf '%s' "$input" | jq -r '.tool_name // empty' 2>/dev/null)"
    ts="$(read_turn_start)"; [ "${ts:-0}" = "0" ] && ts="$now"
    write_state tool "$(tool_label "$tn")" "$ts"
    ;;
  PostToolUse)
    ts="$(read_turn_start)"; [ "${ts:-0}" = "0" ] && ts="$now"
    write_state thinking "Thinking" "$ts"
    ;;
  Notification)
    nt="$(printf '%s' "$input" | jq -r '.notification_type // empty' 2>/dev/null)"
    msg="$(printf '%s' "$input" | jq -r '.message // empty' 2>/dev/null)"
    if [ "$nt" = "permission_prompt" ] || printf '%s' "$msg" | grep -qiE "permission|approve|waiting for your"; then
      ts="$(read_turn_start)"; [ "${ts:-0}" = "0" ] && ts="$now"
      write_state awaiting "Awaiting" "$ts"
    fi
    ;;
  Stop)
    write_state idle "" 0
    ;;
esac

trigger
exit 0
