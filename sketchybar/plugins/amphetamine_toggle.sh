#!/usr/bin/env bash
# Toggle Amphetamine session: end if active, start a session if not.
# We start with no options (uses Amphetamine's default duration, set in Prefs).
# Older syntax with `start new session with options {...}` was rejected on
# recent versions ("could not understand the message received from AppleScript").
ACTIVE="$(timeout 2 osascript -e 'tell application "Amphetamine" to session is active' 2>/dev/null)"

if [ "$ACTIVE" = "true" ]; then
  osascript -e 'tell application "Amphetamine" to end session' 2>/dev/null
else
  osascript -e 'tell application "Amphetamine" to start new session' 2>/dev/null
fi
