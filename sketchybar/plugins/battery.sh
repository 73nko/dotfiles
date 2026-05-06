#!/usr/bin/env bash
source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/colors.sh"

PMSET="$(pmset -g batt 2>/dev/null)"
PERCENTAGE="$(echo "$PMSET" | grep -Eo "[0-9]+%" | head -1 | tr -d '%')"
CHARGING="$(echo "$PMSET" | grep -E "AC Power|charging|charged")"

# Fallback: clamshell or weird SMC state — read directly from ioreg.
if [ -z "$PERCENTAGE" ]; then
  IOREG="$(ioreg -rn AppleSmartBattery 2>/dev/null)"
  CUR="$(echo "$IOREG" | awk -F'= ' '/"CurrentCapacity"/{print $2; exit}')"
  MAX="$(echo "$IOREG" | awk -F'= ' '/"MaxCapacity"/{print $2; exit}')"
  if [ -n "$CUR" ] && [ -n "$MAX" ] && [ "$MAX" -gt 0 ]; then
    PERCENTAGE=$(( CUR * 100 / MAX ))
  fi
fi

# No battery at all (Mac mini / Studio / desktop). Hide the item.
if [ -z "$PERCENTAGE" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

if [ -n "$CHARGING" ]; then
  ICON="$ICON_BATTERY_CHARGING"
  COLOR="$TURQUOISE_HI"
else
  case "${PERCENTAGE}" in
    9[0-9]|100) ICON="$ICON_BATTERY_FULL"; COLOR="$GOLD" ;;
    [6-8][0-9]) ICON="$ICON_BATTERY_75";   COLOR="$GOLD" ;;
    [3-5][0-9]) ICON="$ICON_BATTERY_50";   COLOR="$PEACH" ;;
    [1-2][0-9]) ICON="$ICON_BATTERY_25";   COLOR="$TANGERINE" ;;
    *)          ICON="$ICON_BATTERY_LOW";  COLOR="$MAGENTA" ;;
  esac
fi

sketchybar --set "$NAME" drawing=on \
                         icon="$ICON"   icon.color="$COLOR" \
                         label="${PERCENTAGE}%" label.color="$COLOR"
