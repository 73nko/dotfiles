#!/usr/bin/env bash
# ============================================================================
# Revierte la capa visual aplicada por macos-violet-hour.sh
# (accent, color de selección, puntero, iconos de carpeta).
# El wallpaper NO se revierte automáticamente: elige otro en Ajustes > Fondo.
# ============================================================================
set -uo pipefail

CFG="$HOME/.config"

# Accent + highlight -> default macOS (azul / multicolor)
defaults delete NSGlobalDomain AppleAccentColor 2>/dev/null
defaults delete NSGlobalDomain AppleHighlightColor 2>/dev/null

# Puntero -> default macOS (blanco / negro).
# El dominio com.apple.universalaccess esta protegido en macOS 26: el delete
# puede fallar. Si falla, resetea el color en Ajustes > Accesibilidad > Puntero.
defaults delete com.apple.universalaccess cursorFill 2>/dev/null
defaults delete com.apple.universalaccess cursorOutline 2>/dev/null
defaults delete com.apple.universalaccess cursorIsCustomized 2>/dev/null
killall universalaccessd 2>/dev/null

# Iconos de carpeta -> limpiar los custom icons ya aplicados.
# La capa de "aplicar" se quitó de macos-violet-hour.sh; este bloque se queda
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
