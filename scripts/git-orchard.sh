#!/usr/bin/env bash
# ============================================================================
# git-orchard — vista multi-repo de git · Violet Hour · Glass
# ----------------------------------------------------------------------------
# Escanea una carpeta en busca de repos git y muestra, de un vistazo, en qué
# rama está cada uno, qué cambios tiene y si está ahead/behind del remoto.
#
# Dos modos sobre el mismo motor:
#   git-orchard.sh [root]          -> dashboard: tabla compacta y coloreada
#   git-orchard.sh --pick [root]   -> picker fzf con preview; Enter abre lazygit
#
# El estado ahead/behind usa lo ÚLTIMO fetcheado (cero red, instantáneo).
# Dentro del picker:  ctrl-f fetch del repo  ·  ctrl-a fetch de todos.
#
# Root por defecto:  ~/YOUR-ORG   (override con argumento o $ORCHARD_ROOT)
# Atajos:  función fish `repos`   ·   tmux `prefix + G`
#
# Tunables por entorno:
#   ORCHARD_ROOT, ORCHARD_MAXDEPTH (6), ORCHARD_JOBS (8),
#   ORCHARD_GLYPH_BRANCH (glyph Nerd Font de rama)
# ============================================================================
set -uo pipefail

# UTF-8 hace falta para que ${#var} cuente caracteres (no bytes) al alinear.
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# Homebrew en PATH — por si se lanza desde launchd, watch o un popup de tmux
# con un entorno mínimo (igual que hace sketchybarrc).
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:$PATH"

ROOT_DEFAULT="${ORCHARD_ROOT:-$HOME/YOUR-ORG}"
MAXDEPTH="${ORCHARD_MAXDEPTH:-6}"
JOBS="${ORCHARD_JOBS:-8}"
# Glyph de rama (Nerd Font nf-pl-branch, U+E0A0). Es el glyph powerline más
# universal; si tu fuente no lo trae, exporta ORCHARD_GLYPH_BRANCH='' o '*'.
# Se embebe por octal UTF-8 (EE 82 A0) para no depender del encoding del fichero.
GLYPH_BRANCH="${ORCHARD_GLYPH_BRANCH-$(printf '\356\202\240')}"
GB="${GLYPH_BRANCH:- }"   # fallback de 1 columna -> alineación estable

SELF="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

# --- paleta Violet Hour · Glass (truecolor) ---------------------------------
_c()  { printf '\033[38;2;%s;%s;%sm' "$1" "$2" "$3"; }
ORCHID="$(_c 179 157 255)"   # identidad primaria
LILAC="$(_c 214 200 255)"    # identidad brillante / stash
PERI="$(_c 141 167 255)"     # estructura / rama default / staged
ICE="$(_c 168 201 255)"      # foco / rama no-default / ahead
BLOOM="$(_c 240 210 255)"    # valores / cambios sin commitear
ROSE="$(_c 226 188 255)"     # diagnósticos / necesita atención
STAR="$(_c 236 230 255)"     # foreground por defecto
SILVER="$(_c 119 116 148)"   # muted / clean / secundario
RULE="$(_c 47 54 90)"        # divisores
RST=$'\033[0m'
BOLD=$'\033[1m'

# ============================================================================
# _row — emite UN registro (TAB-separado) para un repo. Uso interno.
#   campos: prio name repo branch detached isdefault staged unstaged untracked
#           ahead behind hasup age stash
# ============================================================================
cmd_row() {
  local repo="${1%/.git}"
  [[ -d "$repo/.git" ]] || return 0

  local name branch detached=0 isdefault=0
  name="$(basename "$repo")"
  branch="$(git -C "$repo" symbolic-ref --short -q HEAD 2>/dev/null || true)"
  if [[ -z "$branch" ]]; then
    detached=1
    branch="$(git -C "$repo" rev-parse --short HEAD 2>/dev/null || echo '?')"
  fi
  case "$branch" in main|master|develop|trunk) isdefault=1 ;; esac

  # cambios en working tree (porcelain v1: columna X=index, Y=worktree)
  local porc staged=0 unstaged=0 untracked=0
  porc="$(git -C "$repo" status --porcelain 2>/dev/null || true)"
  if [[ -n "$porc" ]]; then
    untracked="$(grep -c '^??'      <<<"$porc" || true)"
    staged="$(  grep -cE '^[MTADRC]' <<<"$porc" || true)"
    unstaged="$(grep -cE '^.[MTD]'   <<<"$porc" || true)"
  fi
  local total=$(( staged + unstaged + untracked ))

  # ahead/behind frente al upstream ya fetcheado (sin red)
  local ahead=0 behind=0 hasup=0
  if git -C "$repo" rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
    hasup=1
    local lr
    lr="$(git -C "$repo" rev-list --left-right --count '@{u}...HEAD' 2>/dev/null || echo '0 0')"
    read -r behind ahead <<<"$lr"
  fi

  local stash
  stash="$(git -C "$repo" stash list 2>/dev/null | wc -l | tr -d ' ')"

  # edad del último commit, compacta
  local ct now=0 age='·'
  ct="$(git -C "$repo" log -1 --format=%ct 2>/dev/null || echo 0)"
  if [[ "$ct" =~ ^[0-9]+$ && "$ct" -gt 0 ]]; then
    now="$(date +%s)"
    age="$(age_fmt $(( now - ct )))"
  fi

  # prioridad de orden (menor = más arriba / más urgente)
  local prio=9
  (( detached ))                  && prio=5
  (( ahead>0 && behind==0 ))      && prio=$(imin "$prio" 4)
  (( total>0 ))                   && prio=$(imin "$prio" 2)
  (( behind>0 && ahead==0 ))      && prio=$(imin "$prio" 1)
  (( ahead>0 && behind>0 ))       && prio=0

  printf '%s\t%s\t%s\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%s\t%s\n' \
    "$prio" "$name" "$repo" "$branch" "$detached" "$isdefault" \
    "$staged" "$unstaged" "$untracked" "$ahead" "$behind" "$hasup" "$age" "$stash"
}

imin() { (( $1 < $2 )) && echo "$1" || echo "$2"; }

age_fmt() {
  local s=$1; (( s<0 )) && s=0
  if   (( s<3600 ));     then echo "$(( s/60 ))m"
  elif (( s<86400 ));    then echo "$(( s/3600 ))h"
  elif (( s<604800 ));   then echo "$(( s/86400 ))d"
  elif (( s<2592000 ));  then echo "$(( s/604800 ))w"
  elif (( s<31536000 )); then echo "$(( s/2592000 ))mo"
  else                        echo "$(( s/31536000 ))y"
  fi
}

# ============================================================================
# scan — encuentra repos bajo $1 y devuelve los registros ya ordenados
# ============================================================================
scan_sorted() {
  local root="$1"
  find -L "$root" -maxdepth "$MAXDEPTH" -type d \
       \( -name node_modules -o -name .Trash -o -name Library \
          -o -name vendor -o -name .cache -o -name .venv \) -prune \
       -o -type d -name .git -print0 2>/dev/null \
  | xargs -0 -P "$JOBS" -n1 "$SELF" _row 2>/dev/null \
  | sort -t$'\t' -k1,1n -k2,2
}

# ============================================================================
# builders de celda — fijan _PLAIN (para medir) y _COLOR (para imprimir)
# ============================================================================
build_changes() {  # staged unstaged untracked
  local s=$1 u=$2 n=$3
  if (( s+u+n == 0 )); then CH_PLAIN='clean'; CH_COLOR="${SILVER}clean${RST}"; return; fi
  local pp=() pc=()
  (( s>0 )) && { pp+=("+$s"); pc+=("${PERI}+$s${RST}"); }
  (( u>0 )) && { pp+=("~$u"); pc+=("${BLOOM}~$u${RST}"); }
  (( n>0 )) && { pp+=("?$n"); pc+=("${SILVER}?$n${RST}"); }
  local IFS=' '; CH_PLAIN="${pp[*]}"; CH_COLOR="${pc[*]}"
}

build_sync() {  # hasup ahead behind detached
  local hu=$1 a=$2 b=$3 det=$4
  if   (( det ));            then SY_PLAIN='detached';    SY_COLOR="${SILVER}detached${RST}"; return; fi
  if   (( hu==0 ));          then SY_PLAIN='⊘ no remote'; SY_COLOR="${SILVER}⊘ no remote${RST}"; return; fi
  if   (( a==0 && b==0 ));   then SY_PLAIN='≡ synced';    SY_COLOR="${SILVER}≡ synced${RST}"; return; fi
  local pp=() pc=()
  (( a>0 )) && { pp+=("↑$a"); pc+=("${ICE}↑$a${RST}"); }
  (( b>0 )) && { pp+=("↓$b"); pc+=("${ROSE}↓$b${RST}"); }
  local IFS=' '; SY_PLAIN="${pp[*]}"; SY_COLOR="${pc[*]}"
}

# dot líder según prioridad
dot_for() {
  case "$1" in
    0) printf '%s⇅%s' "$ROSE"   "$RST" ;;
    1) printf '%s↓%s' "$ROSE"   "$RST" ;;
    2) printf '%s●%s' "$BLOOM"  "$RST" ;;
    4) printf '%s↑%s' "$ICE"    "$RST" ;;
    5) printf '%s◇%s' "$SILVER" "$RST" ;;
    *) printf '%s✓%s' "$SILVER" "$RST" ;;
  esac
}

truncate_to() {  # string width  -> string recortado con … si hace falta
  local s="$1" w="$2"
  (( ${#s} > w )) && s="${s:0:w-1}…"
  printf '%s' "$s"
}

# ============================================================================
# render — pinta la lista de repos.  $1=root  $2=withpath(0|1)
#   withpath=1 antepone "repo<TAB>" a cada línea (para fzf {1})
# ============================================================================
render() {
  local root="$1" withpath="$2"
  local data; data="$(scan_sorted "$root")"
  [[ -z "$data" ]] && { RENDER_EMPTY=1; return 0; }
  RENDER_EMPTY=0

  # cap de columnas
  local NW=10 BW=8 CW=7 SW=9
  local -a render_lines=()
  local prio name repo branch detached isdefault staged unstaged untracked
  local ahead behind hasup age stash

  # --- pasada 1: medir ------------------------------------------------------
  while IFS=$'\t' read -r prio name repo branch detached isdefault \
        staged unstaged untracked ahead behind hasup age stash; do
    [[ -z "$prio" ]] && continue
    name="$(truncate_to "$name" 26)"
    branch="$(truncate_to "$branch" 28)"
    build_changes "$staged" "$unstaged" "$untracked"
    build_sync "$hasup" "$ahead" "$behind" "$detached"
    (( ${#name}      > NW )) && NW=${#name}
    (( ${#branch}    > BW )) && BW=${#branch}
    (( ${#CH_PLAIN}  > CW )) && CW=${#CH_PLAIN}
    (( ${#SY_PLAIN}  > SW )) && SW=${#SY_PLAIN}
  done <<<"$data"

  # --- pasada 2: render -----------------------------------------------------
  D_TOTAL=0 D_DIRTY=0 D_BEHIND=0 D_AHEAD=0 D_CLEAN=0 D_DETACHED=0
  while IFS=$'\t' read -r prio name repo branch detached isdefault \
        staged unstaged untracked ahead behind hasup age stash; do
    [[ -z "$prio" ]] && continue
    (( D_TOTAL++ ))
    case "$prio" in
      0|1) (( D_BEHIND++ )) ;;
      2)   (( D_DIRTY++ ))  ;;
      4)   (( D_AHEAD++ ))  ;;
      5)   (( D_DETACHED++ )) ;;
      *)   (( D_CLEAN++ ))  ;;
    esac

    local tname tbranch
    tname="$(truncate_to "$name" 26)"
    tbranch="$(truncate_to "$branch" 28)"
    build_changes "$staged" "$unstaged" "$untracked"
    build_sync "$hasup" "$ahead" "$behind" "$detached"

    # colores por campo
    local namecol="$STAR"; (( prio < 9 )) && namecol="${STAR}${BOLD}"
    local brcol="$PERI"
    (( detached ))            && brcol="$ROSE"
    (( isdefault==0 && detached==0 )) && brcol="$ICE"

    local dot; dot="$(dot_for "$prio")"

    # padding manual (los campos con color multi-tono se miden en *_PLAIN)
    local namepad branchpad chgpad syncpad agepad
    printf -v namepad   '%-*s' "$NW" "$tname"
    printf -v branchpad '%-*s' "$BW" "$tbranch"
    printf -v agepad    '%-5s' "$age"
    local cpad=$(( CW - ${#CH_PLAIN} )); (( cpad<0 )) && cpad=0
    local spad=$(( SW - ${#SY_PLAIN} )); (( spad<0 )) && spad=0
    printf -v chgpad  '%*s' "$cpad" ''
    printf -v syncpad '%*s' "$spad" ''

    local stashcell
    if [[ "$stash" == "0" || -z "$stash" ]]; then
      stashcell="${SILVER}·${RST}"
    else
      stashcell="${LILAC}≡${stash}${RST}"
    fi

    local line
    printf -v line ' %s  %s%s%s  %s%s %s%s%s  %s%s  %s%s  %s%s%s  %s' \
      "$dot" \
      "$namecol" "$namepad" "$RST" \
      "$PERI" "$GB" "$brcol" "$branchpad" "$RST" \
      "$CH_COLOR" "$chgpad" \
      "$SY_COLOR" "$syncpad" \
      "$SILVER" "$agepad" "$RST" \
      "$stashcell"

    if [[ "$withpath" == "1" ]]; then
      render_lines+=("$repo"$'\t'"$line")
    else
      render_lines+=("$line")
    fi
  done <<<"$data"

  RENDER_NW=$NW RENDER_BW=$BW RENDER_CW=$CW RENDER_SW=$SW
  RENDER_LINES=("${render_lines[@]}")
}

# emite las líneas de render por stdout (para fzf / _rows)
cmd_rows() {
  render "${1:-$ROOT_DEFAULT}" 1
  [[ "${RENDER_EMPTY:-0}" == "1" ]] && return 0
  printf '%s\n' "${RENDER_LINES[@]}"
}

# ============================================================================
# dashboard — header + tabla + footer
# ============================================================================
cmd_dashboard() {
  local root="$1"
  if [[ ! -d "$root" ]]; then
    printf '%s  no existe la carpeta:%s %s\n' "$ROSE" "$RST" "$root" >&2
    exit 1
  fi
  render "$root" 0

  printf '\n  %s%s%sgit orchard%s   %s%s%s\n\n' \
    "$ORCHID" "$GLYPH_BRANCH" "$BOLD" "$RST" "$SILVER" "${root/#$HOME/~}" "$RST"

  if [[ "${RENDER_EMPTY:-0}" == "1" ]]; then
    printf '  %ssin repos git bajo esa carpeta (maxdepth %s)%s\n\n' "$SILVER" "$MAXDEPTH" "$RST"
    return 0
  fi

  # cabecera de columnas
  local hNW=$RENDER_NW hBW=$RENDER_BW hCW=$RENDER_CW hSW=$RENDER_SW
  printf '    %s%-*s    %-*s  %-*s  %-*s  %-5s  %s%s\n' \
    "$SILVER" \
    "$hNW" "REPO" "$hBW" "BRANCH" "$hCW" "CHANGES" "$hSW" "SYNC" \
    "AGE" "STASH" "$RST"
  printf '  %s' "$RULE"
  local i=0 width=$(( hNW + hBW + hCW + hSW + 28 ))
  while (( i < width )); do printf '─'; (( i++ )); done
  printf '%s\n' "$RST"

  printf '%s\n' "${RENDER_LINES[@]}"

  # footer
  printf '  %s' "$RULE"; i=0
  while (( i < width )); do printf '─'; (( i++ )); done; printf '%s\n' "$RST"
  printf '  %s%d repos%s  ·  %s%d dirty%s  ·  %s%d behind%s  ·  %s%d ahead%s  ·  %s%d clean%s\n' \
    "$STAR" "$D_TOTAL" "$RST" \
    "$BLOOM" "$D_DIRTY" "$RST" \
    "$ROSE" "$D_BEHIND" "$RST" \
    "$ICE" "$D_AHEAD" "$RST" \
    "$SILVER" "$D_CLEAN" "$RST"
  printf '  %spicker:%s repos -i      %stmux:%s prefix + G\n\n' \
    "$SILVER" "$RST" "$SILVER" "$RST"
}

# ============================================================================
# _preview — panel de detalle para fzf
# ============================================================================
cmd_preview() {
  local repo="$1" name
  [[ -d "$repo/.git" ]] || { echo "  (no es un repo)"; return 0; }
  name="$(basename "$repo")"
  printf '%s%s%s%s   %s%s%s\n\n' \
    "$ORCHID" "$BOLD" "$name" "$RST" "$SILVER" "${repo/#$HOME/~}" "$RST"
  printf '%s── status ─────────────────────────────%s\n' "$RULE" "$RST"
  git -C "$repo" -c color.ui=always status -sb 2>/dev/null | head -n 18
  printf '\n%s── log ────────────────────────────────%s\n' "$RULE" "$RST"
  git -C "$repo" -c color.ui=always log --oneline --graph --decorate -10 2>/dev/null
  printf '\n%s── diffstat (HEAD) ────────────────────%s\n' "$RULE" "$RST"
  git -C "$repo" -c color.ui=always diff --stat HEAD 2>/dev/null | tail -n 16
}

# ============================================================================
# _fetchall — git fetch en paralelo de todos los repos bajo root
# ============================================================================
cmd_fetchall() {
  local root="$1"
  # shellcheck disable=SC2016
  find -L "$root" -maxdepth "$MAXDEPTH" -type d \
       \( -name node_modules -o -name .Trash -o -name Library \
          -o -name vendor -o -name .cache -o -name .venv \) -prune \
       -o -type d -name .git -print0 2>/dev/null \
  | xargs -0 -P "$JOBS" -n1 -I{} \
      sh -c 'git -C "${1%/.git}" fetch --quiet 2>/dev/null || true' _ {}
}

# ============================================================================
# pick — picker fzf
# ============================================================================
cmd_pick() {
  local root="$1"
  if [[ ! -d "$root" ]]; then
    printf '%s  no existe la carpeta:%s %s\n' "$ROSE" "$RST" "$root" >&2
    exit 1
  fi
  if ! command -v fzf >/dev/null 2>&1; then
    printf '%s  fzf no está instalado — mostrando dashboard%s\n' "$ROSE" "$RST" >&2
    cmd_dashboard "$root"; return
  fi

  local fzf_color="\
fg:#f3faf7,bg:-1,hl:#22b8f5,fg+:#f3faf7,bg+:#214c5e,hl+:#a8ecff,\
info:#5f9bd8,prompt:#22b8f5,pointer:#e0fbff,marker:#5ff2cf,\
border:#214c5e,header:#5f9bd8,spinner:#22b8f5,gutter:-1,label:#22b8f5"

  local hdr="enter lazygit · ctrl-f fetch repo · ctrl-a fetch all · ctrl-o shell · ctrl-r reload · ctrl-/ preview"

  cmd_rows "$root" | fzf \
    --ansi \
    --delimiter='\t' --with-nth=2.. --nth=2.. \
    --no-sort \
    --layout=reverse \
    --height=100% \
    --border=rounded \
    --border-label=" git orchard · ${root/#$HOME/~} " \
    --color="$fzf_color" \
    --header="$hdr" \
    --prompt='repo ❯ ' \
    --pointer='▶' \
    --preview="$SELF _preview {1}" \
    --preview-window='right,58%,border-left,wrap' \
    --bind="enter:execute(lazygit -p {1})" \
    --bind="ctrl-f:execute-silent(git -C {1} fetch --quiet 2>/dev/null)+reload($SELF _rows $root)" \
    --bind="ctrl-a:execute-silent($SELF _fetchall $root)+reload($SELF _rows $root)" \
    --bind="ctrl-o:execute(cd {1} && exec \$SHELL)" \
    --bind="ctrl-r:reload($SELF _rows $root)" \
    --bind='ctrl-/:toggle-preview'
}

usage() {
  cat <<EOF
git orchard — vista multi-repo de git

  git-orchard.sh [root]          dashboard (tabla)
  git-orchard.sh --pick [root]   picker interactivo (fzf -> lazygit)
  git-orchard.sh --help

  root por defecto: ${ROOT_DEFAULT/#$HOME/~}   (o \$ORCHARD_ROOT)
EOF
}

# ============================================================================
# dispatch
# ============================================================================
case "${1:-}" in
  _row)      shift; cmd_row "${1:-}";                 exit 0 ;;
  _preview)  shift; cmd_preview "${1:-}";             exit 0 ;;
  _rows)     shift; cmd_rows "${1:-}";                exit 0 ;;
  _fetchall) shift; cmd_fetchall "${1:-$ROOT_DEFAULT}"; exit 0 ;;
  -h|--help) usage;                                   exit 0 ;;
  -i|--pick|pick) shift; cmd_pick "${1:-$ROOT_DEFAULT}";     exit 0 ;;
  *)         cmd_dashboard "${1:-$ROOT_DEFAULT}";     exit 0 ;;
esac
