#!/usr/bin/env bash
set -uo pipefail

ROOT=${1:-"${XDG_CONFIG_HOME:-$HOME/.config}"}
PALETTE="$ROOT/themes/violet-hour.json"
failures=()

fail() {
  local failure
  for failure in "${failures[@]}"; do
    [[ "$failure" == "$1" ]] && return
  done
  failures+=("$1")
}

contains_color() {
  local color=${1#\#}
  local path=$2
  grep -Eiq "#${color}|0x[[:xdigit:]]{2}${color}([^[:xdigit:]]|$)|(^|[^[:xdigit:]])${color}([^[:xdigit:]]|$)" "$path"
}

[[ -f "$PALETTE" ]] || {
  echo "theme: missing $PALETTE" >&2
  exit 1
}

while IFS=$'\t' read -r file color; do
  path="$ROOT/$file"
  hex=$(jq -r --arg color "$color" '.colors[$color]' "$PALETTE")
  if [[ ! -f "$path" ]]; then
    fail "missing active theme file: $file"
  elif ! contains_color "$hex" "$path"; then
    fail "$file does not contain $color ($hex)"
  fi
done < <(jq -r '.required | to_entries[] | .key as $file | .value[] | [$file, .] | @tsv' "$PALETTE")

while IFS=$'\t' read -r file expected; do
  path="$ROOT/$file"
  if [[ ! -f "$path" ]] || ! grep -Fq "$expected" "$path"; then
    fail "$file does not activate $expected"
  fi
done < <(jq -r '.references | to_entries[] | [.key, .value] | @tsv' "$PALETTE")

while IFS= read -r file; do
  path="$ROOT/$file"
  [[ -f "$path" ]] || continue
  while IFS= read -r legacy; do
    if contains_color "$legacy" "$path"; then
      fail "$file contains legacy color $legacy"
    fi
  done < <(jq -r '.legacy[]' "$PALETTE")
done < <(jq -r '.required | keys[]' "$PALETTE")

if [[ ${#failures[@]} -gt 0 ]]; then
  printf 'theme: FAIL %s\n' "${failures[@]}" >&2
  exit 1
fi

echo "theme: OK"
