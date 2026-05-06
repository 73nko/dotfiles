#!/usr/bin/env bash
source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/colors.sh"

# 'networksetup -getairportnetwork en0' returns 'Current Wi-Fi Network: <SSID>' or
# 'You are not associated with an AirPort network.'
SSID_LINE="$(networksetup -getairportnetwork en0 2>/dev/null | sed 's/Current Wi-Fi Network: //')"

if echo "$SSID_LINE" | grep -qi "not associated"; then
  sketchybar --set "$NAME" icon="$ICON_WIFI_OFF" icon.color="$MAGENTA"
else
  sketchybar --set "$NAME" icon="$ICON_WIFI_ON" icon.color="$TURQUOISE_HI"
fi
