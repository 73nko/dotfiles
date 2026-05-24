#!/usr/bin/env bash
# ============================================================================
# Terminal + Desktop Setup Migration
# ----------------------------------------------------------------------------
# One-shot script that brings any of your machines from "fresh dotfiles" to
# the current state: deprecated stuff cleaned, Violet Hour · Glass applied,
# SketchyBar + JankyBorders + AeroSpace running, macOS tweaks in.
#
# Idempotent — safe to re-run. Each block checks before acting.
#
# Usage:
#   bash ~/.config/scripts/migrate-terminal-setup.sh
# ============================================================================
set -uo pipefail

bold()   { printf "\n\033[1;38;5;205m==>\033[0m \033[1m%s\033[0m\n" "$1"; }
ok()     { printf "  \033[32m✓\033[0m %s\n" "$1"; }
warn()   { printf "  \033[33m!\033[0m %s\n" "$1"; }
skip()   { printf "  \033[2m·\033[0m %s\n" "$1"; }
info()   { printf "  %s\n" "$1"; }

# ----------------------------------------------------------------------------
bold "[1/9] Deprecated packages — out"
# ----------------------------------------------------------------------------
for pkg in thefuck neofetch bash-completion skhd; do
  if brew list --formula "$pkg" >/dev/null 2>&1; then
    brew uninstall --force "$pkg" >/dev/null 2>&1 && ok "removed $pkg"
  else
    skip "$pkg not installed"
  fi
done
# stop skhd service if any
skhd --stop-service >/dev/null 2>&1 && ok "stopped skhd service" || true
# Magnet conflicts with AeroSpace — flag, don't auto-remove (App Store install).
if [ -d "/Applications/Magnet.app" ]; then
  warn "Magnet still installed — conflicts with AeroSpace. Quitarlo a mano."
fi

# ----------------------------------------------------------------------------
bold "[2/9] Brew bundle — apply ~/.config/.Brewfile"
# ----------------------------------------------------------------------------
if [ -f "$HOME/.config/.Brewfile" ]; then
  HOMEBREW_BUNDLE_FILE="$HOME/.config/.Brewfile" brew bundle install --no-upgrade 2>&1 \
    | tail -5 || warn "brew bundle had non-fatal errors — review above"
  ok "brewfile applied"
else
  warn "no ~/.config/.Brewfile found"
fi

# ----------------------------------------------------------------------------
bold "[3/9] Cargo / OMF cleanup"
# ----------------------------------------------------------------------------
cargo uninstall fd-find >/dev/null 2>&1 && ok "removed cargo fd-find (brew fd is identical)" || skip "cargo fd-find already gone"
if command -v omf >/dev/null 2>&1; then
  omf destroy --force >/dev/null 2>&1 && ok "OMF destroyed" || warn "OMF destroy failed"
fi
rm -rf "$HOME/.config/omf" "$HOME/.local/share/omf" 2>/dev/null
rm -rf "$HOME/.config/neofetch" "$HOME/.config/skhd" 2>/dev/null
for plugin in tmux-colors-solarized tmux-themepack tmux-tokyo-night tmux-yank; do
  rm -rf "$HOME/.config/tmux/plugins/$plugin" 2>/dev/null && ok "removed tmux plugin: $plugin" || true
done

# ----------------------------------------------------------------------------
bold "[4/9] Violet Hour — wallpaper + capa visual macOS"
# ----------------------------------------------------------------------------
WALLDIR="$HOME/.config/wallpapers"
mkdir -p "$WALLDIR"
# El master 5K (violet-hour-aurora-5120x3200.png) viene versionado en el repo.
# generate_wallpaper.py deriva las variantes por pantalla (ultrawide + portatil).
if [ -f "$HOME/.config/scripts/generate_wallpaper.py" ]; then
  /opt/homebrew/bin/python3 "$HOME/.config/scripts/generate_wallpaper.py" >/dev/null 2>&1 \
    && ok "variantes de wallpaper derivadas del master" \
    || warn "generate_wallpaper.py fallo (Pillow no instalado?)"
else
  warn "generate_wallpaper.py missing — copy it from your dotfiles"
fi
# Capa visual: wallpaper + accent + highlight + puntero.
if [ -f "$HOME/.config/scripts/macos-violet-hour.sh" ]; then
  bash "$HOME/.config/scripts/macos-violet-hour.sh" >/dev/null 2>&1 \
    && ok "capa visual Violet Hour aplicada (wallpaper, accent, puntero)" \
    || warn "macos-violet-hour.sh tuvo errores — revisalo a mano"
else
  warn "macos-violet-hour.sh not found"
fi

# ----------------------------------------------------------------------------
bold "[5/9] macOS tweaks (animations, Finder, screenshots, key repeat...)"
# ----------------------------------------------------------------------------
if [ -f "$HOME/.config/scripts/macos-tweaks.sh" ]; then
  bash "$HOME/.config/scripts/macos-tweaks.sh" >/dev/null 2>&1 && ok "macos-tweaks applied"
else
  warn "macos-tweaks.sh not found"
fi

# ----------------------------------------------------------------------------
bold "[5b/9] Tier S/A/B tooling — bat theme + gh extensions"
# ----------------------------------------------------------------------------
# Rebuild bat cache so the Violet Hour tmTheme is registered.
if command -v bat >/dev/null 2>&1; then
  bat cache --build >/dev/null 2>&1 && ok "bat theme cache rebuilt (Violet Hour)"
fi
# gh extensions: dashboard de PRs/issues (gh-dash), limpieza de branches con
# PR merged (gh-poi), y CLI assistant (gh-copilot).
if command -v gh >/dev/null 2>&1; then
  install_gh_ext() {
    local repo="$1"
    local match="$2"
    if ! gh extension list 2>/dev/null | grep -q "$match"; then
      gh extension install "$repo" >/dev/null 2>&1 && ok "installed $match extension"
    else
      skip "$match extension already installed"
    fi
  }
  install_gh_ext "dlvhdr/gh-dash"        "gh dash"
  install_gh_ext "seachicken/gh-poi"     "gh poi"
  install_gh_ext "github/gh-copilot"     "gh copilot"
fi
# delta gitconfig keys: ahora viven en ~/.config/git/config (versionado).
# El bloque que escribia git config --global aqui se borro para tener una
# unica fuente de verdad y evitar drift entre maquinas.

# ----------------------------------------------------------------------------
bold "[6/9] Brew services — borders + sketchybar"
# ----------------------------------------------------------------------------
for svc in borders sketchybar; do
  if brew services list 2>/dev/null | awk -v s="$svc" '$1==s{print $2}' | grep -q "^started$"; then
    skip "$svc already running"
  else
    brew services start "$svc" >/dev/null 2>&1 && ok "started $svc" || warn "could not start $svc"
  fi
done

# ----------------------------------------------------------------------------
bold "[7/9] AeroSpace"
# ----------------------------------------------------------------------------
if [ -d "/Applications/AeroSpace.app" ]; then
  open -gj -a /Applications/AeroSpace.app
  ok "AeroSpace launched (background)"
  info "first run requires Accessibility permission:"
  info "  System Settings > Privacy & Security > Accessibility > AeroSpace = ON"
else
  warn "AeroSpace.app missing — brew install --cask nikitabobko/tap/aerospace"
fi

# ----------------------------------------------------------------------------
bold "[8/9] Permission reminders (manual, one-time)"
# ----------------------------------------------------------------------------
info "macOS Tahoe gates a few things. Toggle them in System Settings:"
info "  Privacy & Security > Screen Recording > sketchybar = ON"
info "  Privacy & Security > Accessibility   > AeroSpace  = ON"
info "  Privacy & Security > Calendar        > icalBuddy  = ON   (for the meeting widget)"
info ""
info "If sketchybar's permission gets revoked after a brew upgrade (cdhash"
info "mismatch), remove its entry in the Screen Recording panel and add the"
info "binary back at /opt/homebrew/opt/sketchybar/bin/sketchybar."

# ----------------------------------------------------------------------------
bold "[9/9] Final hint"
# ----------------------------------------------------------------------------
info "Reload your shell:    exec fish"
info "Reload tmux:          tmux source-file ~/.config/tmux/tmux.conf"
info "Re-export Brewfile:   bash ~/.config/scripts/brew-export.sh"
info "Update Yazi plugins:  ya pkg upgrade"
info "Test pay-respects:    mistype a command then press F"
info ""
info "New goodies installed today:"
info "  atuin     ↑ for fuzzy shell history (also Ctrl+R)"
info "  delta     enriches git diff / show / log -p / lazygit previews"
info "  gh dash   TUI dashboard for PRs and issues"
info "  navi      Ctrl+G launches an interactive cheatsheet picker"
info "  pomodoro  click the hourglass pill in SketchyBar to start/stop"

bold "Migration complete."
