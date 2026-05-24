#!/usr/bin/env bash
# ============================================================================
# Violet Hour · Glass — macOS visual identity layer
# ----------------------------------------------------------------------------
# Aplica la capa VISUAL del tema al sistema: wallpaper, accent, color de
# selección y color del puntero.
#
# Los tweaks de comportamiento/rendimiento (Dock autohide, Finder, key repeat,
# animaciones) viven aparte en  macos-tweaks.sh  — este script NO los toca.
#
# Idempotente y reversible:  macos-violet-hour-revert.sh
#
# Uso:  bash ~/.config/scripts/macos-violet-hour.sh
# ============================================================================
set -uo pipefail

say()  { printf "  \033[38;5;141m•\033[0m %s\n" "$1"; }
warn() { printf "  \033[33m!\033[0m %s\n" "$1"; }
head() { printf "\n\033[1;38;5;183m==>\033[0m \033[1m%s\033[0m\n" "$1"; }

CFG="$HOME/.config"

# ----------------------------------------------------------------------------
head "Wallpaper — Violet Hour · Aurora"
# ----------------------------------------------------------------------------
WALLDIR="$CFG/wallpapers"
# Elige el recorte segun la resolucion del display principal. Si no encaja
# con ninguno conocido, usa el master 16:10 (macOS lo ajusta con "Rellenar").
RES="$(system_profiler SPDisplaysDataType 2>/dev/null | awk '/Resolution:/{print $2"x"$4; exit}')"
case "$RES" in
  5120x1440) WALLPAPER="$WALLDIR/violet-hour-aurora-5120x1440.png" ;;
  3456x2234) WALLPAPER="$WALLDIR/violet-hour-aurora-3456x2234.png" ;;
  *)         WALLPAPER="$WALLDIR/violet-hour-aurora-5120x3200.png" ;;
esac
say "display ${RES:-?} -> $(basename "$WALLPAPER")"
if [ -f "$WALLPAPER" ]; then
  osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\"" \
    >/dev/null 2>&1 && say "wallpaper aplicado a todos los escritorios"
else
  warn "no encuentro $WALLPAPER — corre generate_wallpaper.py o renderiza el SVG"
fi

# ----------------------------------------------------------------------------
head "Accent + color de selección"
# ----------------------------------------------------------------------------
# macOS solo ofrece 8 accents preset (no hay hex). Purple (5) es el de la
# familia Violet Hour. El highlight (selección de texto) SÍ acepta hex propio.
defaults write NSGlobalDomain AppleAccentColor -int 5
defaults write NSGlobalDomain AppleHighlightColor -string "0.702 0.616 1.000 Violet Hour"
say "accent = Purple, selección de texto = orchid #b39dff"

# ----------------------------------------------------------------------------
head "Puntero — relleno violeta, contorno claro"
# ----------------------------------------------------------------------------
# Las claves reales son cursorFill / cursorOutline (diccionarios r/g/b/alpha).
# macOS 26 protege el dominio com.apple.universalaccess: el `defaults write`
# devuelve "Could not write domain" salvo que el proceso tenga Full Disk Access.
# Lo intentamos; si falla, abrimos el panel y damos el hex exacto.
#   fill    = orchid  #b39dff -> R168 G158 B255
#   outline = star    #ece6ff -> R236 G230 B255
if defaults write com.apple.universalaccess cursorFill \
     '{alpha=1;red=0.70196;green=0.61569;blue=1.0;}' 2>/dev/null \
   && defaults write com.apple.universalaccess cursorOutline \
     '{alpha=1;red=0.92549;green=0.90196;blue=1.0;}' 2>/dev/null; then
  defaults write com.apple.universalaccess cursorIsCustomized -bool true 2>/dev/null
  killall universalaccessd 2>/dev/null
  say "puntero tintado (orchid / contorno star)"
else
  warn "macOS bloquea escribir el color del puntero por script (dominio protegido)."
  warn "Ponlo a mano en Ajustes del Sistema > Accesibilidad > Puntero:"
  warn "  relleno de puntero   -> hex B39DFF"
  warn "  contorno de puntero  -> hex ECE6FF"
  open "x-apple.systempreferences:com.apple.Accessibility-Settings.extension" 2>/dev/null
fi

# ----------------------------------------------------------------------------
head "Aplicar"
# ----------------------------------------------------------------------------
killall Dock 2>/dev/null
killall Finder 2>/dev/null
killall SystemUIServer 2>/dev/null
say "Dock, Finder y SystemUIServer reiniciados"

echo ""
echo "Listo. El accent y el puntero pueden necesitar logout/login para verse"
echo "en todas las apps. Para revertir:  bash ~/.config/scripts/macos-violet-hour-revert.sh"
