#!/usr/bin/env bash
# ============================================================================
# Revierte la capa visual aplicada por macos-glacier-signal.sh
# (accent e iconos de carpeta).
# El wallpaper NO se revierte automáticamente: elige otro en Ajustes > Fondo.
# ============================================================================
set -uo pipefail

CFG="$HOME/.config"

# Accent -> default macOS (multicolor)
defaults delete NSGlobalDomain AppleAccentColor 2>/dev/null

# Iconos de carpeta -> limpiar los custom icons ya aplicados.
# La capa de "aplicar" se quitó de macos-glacier-signal.sh; este bloque se queda
# solo para borrar el legado de carpetas que sí se llegaron a tintar.
if command -v fileicon >/dev/null 2>&1; then
  for d in Desktop Documents Downloads Developer Projects Movies Music Pictures Public Sites; do
    [ -d "$HOME/$d" ] && fileicon rm "$HOME/$d" >/dev/null 2>&1
  done
  fileicon rm "$CFG" >/dev/null 2>&1
fi

killall Dock Finder SystemUIServer 2>/dev/null
echo "Revertido. El wallpaper cámbialo a mano en Ajustes del Sistema > Fondo de pantalla."
echo "El accent puede necesitar logout/login para volver al azul por completo."
