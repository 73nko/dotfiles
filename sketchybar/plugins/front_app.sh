#!/usr/bin/env bash
# Receives INFO=<app name> when front_app_switched fires.
if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set "$NAME" label="$INFO"
fi
