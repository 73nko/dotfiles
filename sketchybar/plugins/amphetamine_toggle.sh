#!/usr/bin/env bash
ACTIVE="$(timeout 2 osascript -e 'tell application "Amphetamine" to session is active' 2>/dev/null)"

if [ "$ACTIVE" = "true" ]; then
  osascript -e 'tell application "Amphetamine" to end session' 2>/dev/null
else
  osascript -e 'tell application "Amphetamine" to start new session with options {duration:0, displaySleepAllowed:false}' 2>/dev/null
fi
