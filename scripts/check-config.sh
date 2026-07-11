#!/usr/bin/env bash
set -uo pipefail

ROOT=${DOTFILES_ROOT:-"$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"}
failures=()

run_check() {
  local label=$1 output line
  shift
  if output=$("$@" 2>&1); then
    printf '  OK   %s\n' "$label"
  else
    printf '  FAIL %s\n' "$label" >&2
    if [[ -n "$output" ]]; then
      while IFS= read -r line; do
        printf '       %s\n' "$line" >&2
      done <<<"$output"
    fi
    failures+=("$label")
  fi
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'missing command: %s\n' "$1" >&2
    return 1
  fi
}

tracked_files() {
  git -C "$ROOT" ls-files "$@"
}

check_bash() {
  local file tracked files=()
  require_command git || return 1
  require_command bash || return 1
  tracked=$(tracked_files 'scripts/*.sh' 'tests/*.sh') || return 1
  [[ -n "$tracked" ]] || { echo "no tracked Bash files" >&2; return 1; }
  while IFS= read -r file; do files+=("$ROOT/$file"); done <<<"$tracked"
  bash -n "${files[@]}"
}

check_fish() {
  local file tracked
  require_command git || return 1
  require_command fish || return 1
  tracked=$(tracked_files 'fish/*.fish' 'fish/**/*.fish') || return 1
  [[ -n "$tracked" ]] || { echo "no tracked Fish files" >&2; return 1; }
  while IFS= read -r file; do
    fish --no-execute "$ROOT/$file" || return 1
  done <<<"$tracked"
}

check_json() {
  local file output tracked files=()
  require_command git || return 1
  require_command jq || return 1
  tracked=$(tracked_files '*.json') || return 1
  [[ -n "$tracked" ]] || { echo "no tracked strict JSON files" >&2; return 1; }
  while IFS= read -r file; do
    case "$file" in
      zed/settings.json|zed/keymap.json|zed/tasks.json|zed/themes/kanagawa.json) continue ;;
    esac
    files+=("$file")
  done <<<"$tracked"
  [[ ${#files[@]} -gt 0 ]] || { echo "no tracked strict JSON files" >&2; return 1; }
  for file in "${files[@]}"; do
    if ! output=$(jq empty "$ROOT/$file" 2>&1); then
      printf '%s: %s\n' "$ROOT/$file" "$output" >&2
      return 1
    fi
  done
}

check_yaml() {
  local content file marker output temp tracked result=0
  require_command git || return 1
  require_command gh || return 1
  tracked=$(tracked_files '*.yml' '*.yaml') || return 1
  [[ -n "$tracked" ]] || { echo "no tracked YAML files" >&2; return 1; }
  temp=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-yaml.XXXXXX") || return 1
  while IFS= read -r file; do
    content=$(grep -Ev '^[[:space:]]*(#|$)' "$ROOT/$file" || true)
    if [[ -z "$content" ]] || {
      [[ $(wc -l <<<"$content" | tr -d '[:space:]') == 1 ]] &&
        grep -Eq '^[[:space:]]*\{\}[[:space:]]*(#.*)?$' <<<"$content"
    }; then
      printf '%s: single mapping is required; YAML config is empty\n' "$ROOT/$file" >&2
      result=1
      break
    fi
    if marker=$(grep -En '^(---|\.\.\.)[[:space:]]*(#.*)?$' "$ROOT/$file"); then
      printf '%s: single mapping is required; YAML document markers are not allowed: %s\n' \
        "$ROOT/$file" "$marker" >&2
      result=1
      break
    fi
    if ! cp "$ROOT/$file" "$temp/config.yml"; then
      result=1
      break
    fi
    if ! output=$(GH_CONFIG_DIR="$temp" gh config list 2>&1); then
      printf '%s: single mapping is required for tracked YAML config\n' "$ROOT/$file" >&2
      printf '%s: %s\n' "$ROOT/$file" "$output" >&2
      result=1
      break
    fi
  done <<<"$tracked"
  rm -rf "$temp"
  return "$result"
}

check_toml() {
  local file tracked files=() python_command=()
  require_command git || return 1
  if [[ -f "$ROOT/mise/config.toml" ]]; then
    require_command mise || return 1
    python_command=(mise exec -- python3)
  else
    require_command python3 || return 1
    python_command=(python3)
  fi
  tracked=$(tracked_files '*.toml') || return 1
  [[ -n "$tracked" ]] || { echo "no tracked TOML files" >&2; return 1; }
  while IFS= read -r file; do files+=("$file"); done <<<"$tracked"
  MISE_CONFIG_FILE="$ROOT/mise/config.toml" "${python_command[@]}" - "$ROOT" "${files[@]}" <<'PY'
import pathlib
import sys
import tomllib

root = pathlib.Path(sys.argv[1])
for file in sys.argv[2:]:
    path = root / file
    try:
        with path.open("rb") as handle:
            tomllib.load(handle)
    except tomllib.TOMLDecodeError as error:
        print(f"{path}: {error}", file=sys.stderr)
        raise SystemExit(1)
PY
}

check_runtime_state() {
  local result runtime tracked
  require_command git || return 1
  require_command rg || return 1
  tracked=$(tracked_files) || return 1
  [[ -n "$tracked" ]] || { echo "no tracked repository files" >&2; return 1; }
  runtime=$(rg '(^uv/uv-receipt\.json$|^yarn/global/node_modules/|^zed/prompts/|^zed/settings_backup\.json$|^yazi/plugins/)' <<<"$tracked")
  result=$?
  if [[ $result -eq 0 ]]; then
    printf 'tracked runtime state:\n%s\n' "$runtime" >&2
    return 1
  fi
  [[ $result -eq 1 ]]
}

check_shellcheck() {
  local file shellcheck_bin tracked files=()
  require_command git || return 1
  shellcheck_bin=$(command -v shellcheck 2>/dev/null || true)
  [[ -n "$shellcheck_bin" ]] || shellcheck_bin="$HOME/.local/share/nvim/mason/bin/shellcheck"
  [[ -x "$shellcheck_bin" ]] || { echo "missing command: shellcheck" >&2; return 1; }
  tracked=$(tracked_files 'scripts/*.sh' 'tests/*.sh') || return 1
  [[ -n "$tracked" ]] || { echo "no tracked Bash files" >&2; return 1; }
  while IFS= read -r file; do files+=("$ROOT/$file"); done <<<"$tracked"
  "$shellcheck_bin" "${files[@]}"
}

run_check "Bash syntax" check_bash
run_check "ShellCheck" check_shellcheck
run_check "Fish syntax" check_fish
run_check "JSON syntax" check_json
run_check "YAML syntax" check_yaml
run_check "TOML syntax" check_toml
run_check "Violet Hour theme" "$ROOT/scripts/check-theme.sh" "$ROOT"
run_check "No tracked runtime state" check_runtime_state

if [[ ${#failures[@]} -gt 0 ]]; then
  printf 'config: %d failure(s)\n' "${#failures[@]}" >&2
  exit 1
fi

echo "config: OK"
