#!/usr/bin/env bash
# ============================================================================
# Glacier Signal — macOS visual identity layer
# ----------------------------------------------------------------------------
# Aplica la capa visual segura del tema al sistema: wallpaper y el preset de
# accent más próximo a Glacier Signal. El puntero se configura manualmente
# porque macOS no ofrece una interfaz de scripting estable para sus colores.
#
# Los tweaks de comportamiento/rendimiento (Dock autohide, Finder, key repeat,
# animaciones) viven aparte en  macos-tweaks.sh  — este script NO los toca.
#
# Idempotente y reversible:  macos-glacier-signal-revert.sh
#
# Uso:  bash ~/.config/scripts/macos-glacier-signal.sh
# ============================================================================
set -euo pipefail

say()  { printf "  \033[38;5;141m•\033[0m %s\n" "$1"; }
warn() { printf "  \033[33m!\033[0m %s\n" "$1"; }
head() { printf "\n\033[1;38;5;183m==>\033[0m \033[1m%s\033[0m\n" "$1"; }

CFG="$HOME/.config"

# ----------------------------------------------------------------------------
head "Wallpaper — Glacier Signal"
# ----------------------------------------------------------------------------
WALLDIR="$CFG/wallpapers"
# Elige el recorte segun la resolucion del display principal. Si no encaja
# con ninguno conocido, usa el recorte desktop 16:10.
RES="$(system_profiler SPDisplaysDataType 2>/dev/null | awk '/Resolution:/{print $2"x"$4; exit}')"
case "$RES" in
  5120x1440) WALLPAPER="$WALLDIR/glacier-signal-ultrawide-5120x1440.jpg" ;;
  3456x2234) WALLPAPER="$WALLDIR/glacier-signal-macbook-3456x2234.jpg" ;;
  *)         WALLPAPER="$WALLDIR/glacier-signal-desktop-5120x3200.jpg" ;;
esac
say "display ${RES:-?} -> $(basename "$WALLPAPER")"
if [ -f "$WALLPAPER" ]; then
  osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\"" \
    >/dev/null 2>&1 && say "wallpaper aplicado a todos los escritorios"
else
  warn "no encuentro $WALLPAPER — corre generate_wallpaper.py"
fi

# ----------------------------------------------------------------------------
head "Accent"
# ----------------------------------------------------------------------------
# macOS solo ofrece presets de accent; Blue es el más próximo al cian del tema.
defaults write NSGlobalDomain AppleAccentColor -int 4
say "accent = Blue, el preset más próximo a signal #22b8f5"

# ----------------------------------------------------------------------------
head "Puntero — paso manual"
# ----------------------------------------------------------------------------
warn "Configúralo en Ajustes del Sistema > Accesibilidad > Pantalla > Puntero:"
warn "  relleno  -> 22B8F5 (signal)"
warn "  contorno -> F3FAF7 (snow)"

echo ""
echo "Listo. El accent puede necesitar logout/login para verse en todas las apps."
echo "Para revertir: bash ~/.config/scripts/macos-glacier-signal-revert.sh"
