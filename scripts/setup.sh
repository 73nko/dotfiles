#!/usr/bin/env bash
# ============================================================================
# setup.sh — EL comando para mantener cualquier Mac en el estado actual.
# ----------------------------------------------------------------------------
# Modelo convergente: cada fase comprueba el estado real antes de actuar,
# asi el MISMO comando sirve para una maquina recien formateada y para
# sincronizar una existente. No hay "bootstrap" vs "migrate": hay converger.
#
# Sustituye a: bootstrap.sh, migrate-terminal-setup.sh, fish.sh, brew-export.sh
# (eliminados 2026-06; este es la unica fuente de verdad de orquestacion).
#
# Uso:
#   setup.sh            converge la maquina (equivale a `setup.sh sync`)
#   setup.sh sync       idem, explicito
#   setup.sh doctor     solo health check, no toca nada
#   setup.sh export     re-exporta el Brewfile (filtrando .brewfile-exclude)
#   setup.sh --upgrade  sync + brew bundle CON upgrade de paquetes existentes
#
# Principios:
#   - Idempotente: correrlo dos veces seguidas = segunda vez todo SKIP.
#   - Los errores NO se silencian: se acumulan y se listan al final.
#   - Config declarativa vive en sus ficheros (git/config, fish_plugins,
#     .Brewfile, macos-tweaks.sh). Este script NUNCA duplica esos valores.
# ============================================================================
set -uo pipefail

DOTS="$HOME/.config"
LOG_FILE="/tmp/setup-$(date +%Y%m%d-%H%M%S).log"
UPGRADE=false

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'
BLUE='\033[0;34m'; DIM='\033[2m'; NC='\033[0m'

FAILURES=()

phase() { printf "\n${BLUE}==>${NC} \033[1m%s${NC}\n" "$1"; }
ok()    { printf "  ${GREEN}OK${NC}   %s\n" "$1"; }
skip()  { printf "  ${DIM}SKIP${NC} ${DIM}%s${NC}\n" "$1"; }
warn()  { printf "  ${YELLOW}WARN${NC} %s\n" "$1"; }
fail()  { printf "  ${RED}FAIL${NC} %s\n" "$1"; FAILURES+=("$1"); }

# run <descripcion> <comando...>
# Ejecuta logueando stdout/stderr al LOG_FILE. Si falla, se registra en
# FAILURES y se ENSEÑAN las ultimas lineas del error (nada de /dev/null).
run() {
  local desc="$1"; shift
  if "$@" >>"$LOG_FILE" 2>&1; then
    ok "$desc"
  else
    fail "$desc  ${DIM}(ultimas lineas del log)${NC}"
    tail -3 "$LOG_FILE" | sed 's/^/       /'
  fi
}

# ============================================================================
# Fases
# ============================================================================

preflight() {
  phase "Preflight"
  [[ "$(uname)" == "Darwin" ]] || { echo "Solo macOS."; exit 1; }
  [[ -d "$DOTS" ]] || { echo "\$HOME/.config no existe. Clona los dotfiles primero."; exit 1; }
  echo "  Log: $LOG_FILE"

  if xcode-select -p >/dev/null 2>&1; then
    skip "Xcode Command Line Tools"
  else
    echo "  Instalando Xcode CLT (puede tardar)..."
    xcode-select --install >>"$LOG_FILE" 2>&1
    until xcode-select -p >/dev/null 2>&1; do sleep 5; done
    ok "Xcode Command Line Tools"
  fi

  if command -v brew >/dev/null 2>&1; then
    skip "Homebrew"
  else
    echo "  Instalando Homebrew..."
    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" >>"$LOG_FILE" 2>&1; then
      ok "Homebrew"
    else
      fail "Homebrew install"
    fi
  fi
  # PATH para el resto del script (shell nueva o vieja)
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

brew_bundle() {
  phase "Brew bundle (.Brewfile)"
  if [[ ! -f "$DOTS/.Brewfile" ]]; then fail ".Brewfile no encontrado"; return; fi
  local args=(bundle install --file="$DOTS/.Brewfile")
  $UPGRADE || args+=(--no-upgrade)
  # brew bundle es ruidoso: log completo al fichero, resumen aqui.
  if brew "${args[@]}" >>"$LOG_FILE" 2>&1; then
    ok "Brewfile aplicado$($UPGRADE && echo ' (con upgrade)')"
  else
    fail "brew bundle (revisa el log: $LOG_FILE)"
    grep -E "^(Error|Warning)" "$LOG_FILE" | tail -5 | sed 's/^/       /'
  fi
}

rust_toolchain() {
  phase "Rust toolchain"
  if command -v rustup >/dev/null 2>&1; then
    skip "rustup ya instalado"
  else
    run "rustup-init via brew" brew install rustup-init
    run "toolchain stable" rustup-init -y --no-modify-path --quiet --default-toolchain stable
    # shellcheck disable=SC1091
    [[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
  fi
}

fish_shell() {
  phase "Fish como shell por defecto"
  local fish_path
  fish_path="$(command -v fish 2>/dev/null)" || { fail "fish no instalado (deberia venir del Brewfile)"; return; }
  if [[ "$SHELL" == *fish* ]]; then
    skip "ya es la shell por defecto"
  else
    grep -q "$fish_path" /etc/shells || echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
    run "chsh a fish" chsh -s "$fish_path"
  fi
}

fish_plugins() {
  phase "Fisher + plugins de fish"
  if fish -c "type -q fisher" 2>/dev/null; then
    skip "fisher ya instalado"
  else
    run "instalar fisher" fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
  fi
  # fish_plugins es la fuente de verdad: update instala/actualiza/purga.
  run "fisher update (sync desde fish_plugins)" fish -c "fisher update"

  # Tide cachea la ruta Cellar de fish; tras un brew upgrade esa ruta muere
  # y el prompt revienta. Parche: ruta estable via command -v.
  local prompt="$DOTS/fish/functions/fish_prompt.fish"
  if [[ -f "$prompt" ]] && grep -q '^status fish-path | read -l fish_path' "$prompt"; then
    sed -i '' 's#^status fish-path | read -l fish_path#command -v fish | read -l fish_path#' "$prompt"
    ok "parche Tide fish-path aplicado"
  fi
}

mise_toolchains() {
  phase "mise (toolchains: node/go/python/java/deno + go/cargo/pipx tools)"
  command -v mise >/dev/null 2>&1 || { fail "mise no instalado (deberia venir del Brewfile)"; return; }
  # 2026-06: mise es el unico gestor de toolchains. La lista completa vive en
  # mise/config.toml (este script NUNCA duplica esos valores; converge contra
  # el fichero, igual que brew bundle contra el Brewfile).
  # idiomatic_version_file_enable_tools tambien vive ya en config.toml.
  run "mise install (converger toolchains)" mise install --yes
}

tmux_plugins() {
  phase "tmux: TPM + plugins"
  local tpm="$DOTS/tmux/plugins/tpm"
  if [[ -d "$tpm" ]]; then
    skip "TPM ya presente"
  else
    run "clonar TPM" git clone --depth=1 https://github.com/tmux-plugins/tpm "$tpm"
  fi
  if [[ -x "$tpm/bin/install_plugins" ]]; then
    run "instalar plugins tmux" "$tpm/bin/install_plugins"
  fi
  # Purga plugins que ya no estan en tmux.conf (convergencia tambien al quitar)
  if [[ -x "$tpm/bin/clean_plugins" ]]; then
    run "limpiar plugins tmux retirados" "$tpm/bin/clean_plugins"
  fi
}

yazi_plugins() {
  phase "Yazi plugins"
  if command -v ya >/dev/null 2>&1; then
    run "ya pkg install (segun package.toml)" ya pkg install
  else
    warn "ya no encontrado, instala yazi primero"
  fi
}

theming() {
  phase "Tema Violet Hour (bat, wallpaper, capa visual macOS)"
  # bat cache registra el tmTheme que usa delta en los diffs.
  command -v bat >/dev/null 2>&1 && run "bat cache --build" bat cache --build
  local wallpaper="$DOTS/wallpapers/violet-hour-aurora-5120x3200.png"
  if [[ -f "$wallpaper" ]]; then
    skip "wallpaper assets already present"
  elif [[ -f "$DOTS/scripts/generate_wallpaper.py" ]]; then
    run "generate wallpaper assets" python3 "$DOTS/scripts/generate_wallpaper.py"
  fi
  if [[ -f "$DOTS/scripts/macos-violet-hour.sh" ]]; then
    run "capa visual (wallpaper, accent, puntero)" bash "$DOTS/scripts/macos-violet-hour.sh"
  fi
}

macos_defaults() {
  phase "macOS defaults (macos-tweaks.sh, fuente unica)"
  # TODOS los defaults viven en macos-tweaks.sh. Este script no duplica
  # ninguno: la duplicacion bootstrap-vs-tweaks causo defaults contradictorios
  # (screenshots en dos rutas distintas, key repeat definido dos veces).
  if [[ -f "$DOTS/scripts/macos-tweaks.sh" ]]; then
    run "aplicar macos-tweaks.sh" bash "$DOTS/scripts/macos-tweaks.sh"
  else
    fail "macos-tweaks.sh no encontrado"
  fi
}

gh_extensions() {
  phase "gh extensions"
  command -v gh >/dev/null 2>&1 || { warn "gh no instalado"; return; }
  if ! gh auth status >/dev/null 2>&1; then
    warn "gh sin autenticar: corre 'gh auth login' y reintenta (extensiones omitidas)"
    return
  fi
  local exts
  exts="$(gh extension list 2>/dev/null || true)"
  for repo in dlvhdr/gh-dash seachicken/gh-poi github/gh-copilot; do
    local name="${repo#*/}"
    if grep -q "$name" <<<"$exts"; then
      skip "$name"
    else
      run "instalar $name" gh extension install "$repo"
    fi
  done
}

services() {
  phase "Servicios (borders, sketchybar, AeroSpace)"
  for svc in borders sketchybar; do
    if brew services list 2>/dev/null | awk -v s="$svc" '$1==s{print $2}' | grep -q "^started$"; then
      skip "$svc ya corriendo"
    else
      run "arrancar $svc" brew services start "$svc"
    fi
  done
  if [[ -d "/Applications/AeroSpace.app" ]]; then
    if pgrep -xq AeroSpace; then
      skip "AeroSpace ya corriendo"
    else
      open -gj -a /Applications/AeroSpace.app
      ok "AeroSpace lanzado"
    fi
  else
    warn "AeroSpace.app no instalado"
  fi
}

git_identity() {
  phase "Identidad git"
  # SOLO identidad. Los defaults (pull, push, delta...) viven versionados en
  # ~/.config/git/config; escribirlos aqui con --global los SOBREESCRIBIA
  # (~/.gitconfig tiene prioridad sobre el XDG config). Nunca mas.
  local name email
  name="$(git config --global user.name 2>/dev/null || true)"
  email="$(git config --global user.email 2>/dev/null || true)"
  if [[ -n "$name" && -n "$email" ]]; then
    skip "ya configurada: $name <$email>"
  else
    [[ -z "$name" ]] && { read -rp "  Nombre para commits: " name; git config --global user.name "$name"; }
    [[ -z "$email" ]] && { read -rp "  Email para commits: " email; git config --global user.email "$email"; }
    ok "identidad guardada en ~/.gitconfig"
  fi
}

check_tmux_config() {
  local temp socket=dotfiles-doctor
  temp=$(mktemp -d)
  TMUX_TMPDIR="$temp" tmux -L "$socket" -f "$DOTS/tmux/tmux.conf" new-session -d -s doctor || {
    rm -rf "$temp"
    return 1
  }
  TMUX_TMPDIR="$temp" tmux -L "$socket" kill-server >/dev/null 2>&1 || true
  rm -rf "$temp"
}

run_nvim_doctor() {
  local state cache result
  state=$(mktemp -d)
  cache=$(mktemp -d)
  DOTFILES_DOCTOR=1 XDG_STATE_HOME="$state" XDG_CACHE_HOME="$cache" \
    nvim --headless -i NONE "$@"
  result=$?
  rm -rf "$state" "$cache"
  return "$result"
}

check_nvim_config() {
  run_nvim_doctor '+checkhealth vim.deprecated' '+qa!'
}

check_yazi_config() {
  yazi --debug 2>&1 | grep -Fq 'violet-hour'
}

check_fisher_plugins() {
  # shellcheck disable=SC2016
  fish -c '
    set installed (fisher list)
    while read -l plugin
      string match -qr "^#|^$" -- $plugin; and continue
      contains -- $plugin $installed; or exit 1
    end < ~/.config/fish/fish_plugins
  '
}

check_tpm_plugins() {
  local plugin
  for plugin in tpm smart-splits.nvim tmux-sessionx; do
    [[ -d "$DOTS/tmux/plugins/$plugin" ]] || return 1
  done
}

check_mason_packages() {
  run_nvim_doctor \
    '+lua local r=require("mason-registry"); for _,p in ipairs({"lua-language-server","vtsls","prettier"}) do assert(r.is_installed(p), p) end' \
    +qa
}

doctor() {
  phase "Doctor"
  if [[ -x "$DOTS/scripts/check-config.sh" ]]; then
    run "static dotfiles checks" "$DOTS/scripts/check-config.sh"
  else
    fail "scripts/check-config.sh missing"
  fi
  local errors=0
  check() {
    if command -v "$1" >/dev/null 2>&1; then
      printf "  ${GREEN}OK${NC}      %-14s %s\n" "$1" "$(command -v "$1")"
    else
      printf "  ${RED}MISSING${NC} %s\n" "$1"
      errors=$((errors + 1))
    fi
  }
  # Toolchains de mise: NO usar command -v. Los shims solo estan en el PATH
  # con mise activado (fish); desde bash/zsh darian MISSING falsos en una
  # maquina recien instalada. mise which pregunta a la fuente de verdad.
  check_mise() {
    if mise which "$1" >/dev/null 2>&1; then
      printf "  ${GREEN}OK${NC}      %-14s %s\n" "$1" "$(mise which "$1" 2>/dev/null)"
    else
      printf "  ${RED}MISSING${NC} %-14s (mise install pendiente?)\n" "$1"
      errors=$((errors + 1))
    fi
  }
  echo "  Core:"
  for c in fish nvim tmux git brew ghostty; do check "$c"; done
  echo "  Shell:"
  for c in fzf fd bat eza zoxide atuin yazi direnv mise fastfetch pay-respects; do check "$c"; done
  echo "  Dev (brew/rustup):"
  for c in rustc cargo cargo-nextest bacon gh lazygit delta just; do check "$c"; done
  echo "  Toolchains (mise):"
  for c in node go python java deno pnpm gopls dlv; do check_mise "$c"; done
  if command -v brew >/dev/null 2>&1; then
    if HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --file="$DOTS/.Brewfile" >/dev/null 2>&1; then
      ok "Brewfile dependencies satisfied"
    else
      warn "Brewfile drift: run setup.sh sync"
    fi
  fi
  run "tmux config loads" check_tmux_config
  run "Neovim starts without deprecated APIs" check_nvim_config
  run "Yazi loads Violet Hour" check_yazi_config
  run "Fisher plugins match fish_plugins" check_fisher_plugins
  run "TPM plugins installed" check_tpm_plugins
  run "representative Mason packages installed" check_mason_packages
  echo "  Servicios:"
  for svc in borders sketchybar; do
    if brew services list 2>/dev/null | awk -v s="$svc" '$1==s{print $2}' | grep -q "^started$"; then
      printf "  ${GREEN}OK${NC}      %s (corriendo)\n" "$svc"
    else
      printf "  ${YELLOW}WARN${NC}    %s (parado)\n" "$svc"
    fi
  done
  echo ""
  echo "  Permisos manuales (macOS los resetea tras algunos upgrades):"
  echo "    Screen Recording > sketchybar | Accessibility > AeroSpace | Calendar > icalBuddy"
  if [[ $errors -gt 0 ]]; then
    fail "$errors herramienta(s) faltan"
  else
    ok "todas las herramientas presentes"
  fi
}

export_brewfile() {
  phase "Export Brewfile"
  local brewfile="$DOTS/.Brewfile" exclude="$DOTS/.brewfile-exclude"
  run "brew bundle dump" brew bundle dump --file="$brewfile" --force
  if [[ -f "$exclude" ]]; then
    local pattern=""
    while IFS= read -r kw || [[ -n "$kw" ]]; do
      [[ -z "$kw" || "$kw" =~ ^[[:space:]]*# ]] && continue
      # Trim en bash puro. NUNCA xargs aqui: interpreta las comillas de
      # patrones como `tap "x/y"` (las quita) o `^brew "` (revienta), y un
      # patron vacio en la alternancia borraria el Brewfile entero (2026-06).
      kw="${kw#"${kw%%[![:space:]]*}"}"
      kw="${kw%"${kw##*[![:space:]]}"}"
      [[ -z "$kw" ]] && continue
      pattern="${pattern:+$pattern|}$kw"
    done <"$exclude"
    if [[ -n "$pattern" ]]; then
      grep -Ev "$pattern" "$brewfile" >"$brewfile.tmp" && mv "$brewfile.tmp" "$brewfile"
      ok "filtrado .brewfile-exclude aplicado"
    fi
  fi
  ok "Brewfile actualizado: revisa 'git diff .Brewfile' antes de commitear"
}

summary() {
  echo ""
  if [[ ${#FAILURES[@]} -eq 0 ]]; then
    printf '%b\n' "${GREEN}=== Convergencia completa, sin errores ===${NC}"
  else
    printf "${RED}=== Terminado con %d error(es) ===${NC}\n" "${#FAILURES[@]}"
    for f in "${FAILURES[@]}"; do printf "  ${RED}*${NC} %s\n" "$f"; done
    echo ""
    echo "Log completo: $LOG_FILE"
    exit 1
  fi
  echo "Log completo: $LOG_FILE"
  echo ""
  echo "Recuerda: si fish se actualizo, 'exec fish' para refrescar el prompt."
}

# ============================================================================
# Main
# ============================================================================
cmd="sync"
for arg in "$@"; do
  case "$arg" in
    sync|doctor|export) cmd="$arg" ;;
    --upgrade) UPGRADE=true ;;
    -h|--help) sed -n '2,22p' "$0"; exit 0 ;;
    *) echo "Argumento desconocido: $arg (usa --help)"; exit 1 ;;
  esac
done

case "$cmd" in
  doctor)
    doctor
    summary
    ;;
  export)
    export_brewfile
    summary
    ;;
  sync)
    preflight
    brew_bundle
    rust_toolchain
    fish_shell
    fish_plugins
    mise_toolchains
    tmux_plugins
    yazi_plugins
    theming
    macos_defaults
    gh_extensions
    services
    git_identity
    doctor
    summary
    ;;
esac
