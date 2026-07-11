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

normalize_json_color() {
  local value=$1 kind payload red green blue extra
  local red_number green_number blue_number
  normalized_color=
  kind=${value%%:*}
  payload=${value#*:}

  if [[ "$kind" == string ]]; then
    if [[ "$payload" =~ ^#[[:xdigit:]]{6}([[:xdigit:]]{2})?$ ]]; then
      normalized_color=$(printf '%s' "${payload:0:7}" | tr '[:upper:]' '[:lower:]')
    fi
    return
  fi

  [[ "$kind" == array ]] || return
  IFS=, read -r red green blue extra <<<"$payload"
  [[ "$red" =~ ^[0-9]+$ && "$green" =~ ^[0-9]+$ && "$blue" =~ ^[0-9]+$ && -z "$extra" ]] || return
  red_number=$((10#$red))
  green_number=$((10#$green))
  blue_number=$((10#$blue))
  ((red_number <= 255 && green_number <= 255 && blue_number <= 255)) || return
  printf -v normalized_color '#%02x%02x%02x' "$red_number" "$green_number" "$blue_number"
}

[[ -f "$PALETTE" ]] || {
  echo "theme: missing $PALETTE" >&2
  exit 1
}

if ! command -v jq >/dev/null 2>&1; then
  echo "theme: missing command: jq" >&2
  exit 1
fi

if ! palette_error=$(jq empty "$PALETTE" 2>&1); then
  printf 'theme: invalid palette: %s: %s\n' "$PALETTE" "$palette_error" >&2
  exit 1
fi

if ! required_rows=$(jq -r '
  def valid_color: type == "string" and test("^#[0-9A-Fa-f]{6}$");
  .colors as $colors |
  .required | to_entries[] | .key as $file | .value[] as $color |
  $colors[$color] as $hex |
  if ($hex | valid_color) then [$file, $color, $hex] | @tsv
  else error("invalid or missing palette color: \($color)")
  end
' "$PALETTE" 2>&1); then
  printf 'theme: invalid required palette data: %s\n' "$required_rows" >&2
  exit 1
fi
if [[ -n "$required_rows" ]]; then
  while IFS=$'\t' read -r file color hex; do
    path="$ROOT/$file"
    if [[ ! -f "$path" ]]; then
      fail "missing active theme file: $file"
    elif ! contains_color "$hex" "$path"; then
      fail "$file does not contain $color ($hex)"
    fi
  done <<<"$required_rows"
fi

if ! reference_rows=$(jq -r '.references | to_entries[] | [.key, .value] | @tsv' "$PALETTE" 2>&1); then
  printf 'theme: invalid reference palette data: %s\n' "$reference_rows" >&2
  exit 1
fi
if [[ -n "$reference_rows" ]]; then
  while IFS=$'\t' read -r file expected; do
    path="$ROOT/$file"
    if [[ ! -f "$path" ]] || ! grep -Fq "$expected" "$path"; then
      fail "$file does not activate $expected"
    fi
  done <<<"$reference_rows"
fi

if ! semantic_rows=$(jq -r '
  def valid_color: type == "string" and test("^#[0-9A-Fa-f]{6}$");
  .colors as $colors |
  (.semantic // {}) | to_entries[] | .key as $file |
  .value | to_entries[] |
  .key as $field | .value as $color | $colors[$color] as $hex |
  if ($hex | valid_color) then [$file, $field, $color, $hex] | @tsv
  else error("invalid or missing palette color: \($color)")
  end
' "$PALETTE" 2>&1); then
  printf 'theme: invalid semantic palette data: %s\n' "$semantic_rows" >&2
  exit 1
fi
if [[ -n "$semantic_rows" ]]; then
  while IFS=$'\t' read -r file field color hex; do
    path="$ROOT/$file"
    if [[ ! -f "$path" ]]; then
      fail "missing active theme file: $file"
      continue
    fi
    if ! semantic_value=$(jq -r --arg field "$field" '
      def dotted_path:
        $field | split(".") |
        map(if test("^[0-9]+$") then tonumber else . end);
      getpath(dotted_path) |
      if type == "string" then "string:" + .
      elif type == "array" then "array:" + (map(tostring) | join(","))
      else type + ":"
      end
    ' "$path" 2>/dev/null); then
      fail "$file field $field should be $color ($hex)"
      continue
    fi
    normalize_json_color "$semantic_value"
    if [[ "$normalized_color" != "$hex" ]]; then
      fail "$file field $field should be $color ($hex)"
    fi
  done <<<"$semantic_rows"
fi

if ! required_files=$(jq -r '.required | keys[]' "$PALETTE" 2>&1); then
  printf 'theme: invalid required file data: %s\n' "$required_files" >&2
  exit 1
fi
if ! legacy_values=$(jq -r '
  def valid_color: type == "string" and test("^#[0-9A-Fa-f]{6}$");
  .legacy[] |
  if valid_color then . else error("invalid legacy palette color") end
' "$PALETTE" 2>&1); then
  printf 'theme: invalid legacy palette data: %s\n' "$legacy_values" >&2
  exit 1
fi
if [[ -n "$required_files" && -n "$legacy_values" ]]; then
  while IFS= read -r file; do
    path="$ROOT/$file"
    [[ -f "$path" ]] || continue
    while IFS= read -r legacy; do
      if contains_color "$legacy" "$path"; then
        fail "$file contains legacy color $legacy"
      fi
    done <<<"$legacy_values"
  done <<<"$required_files"
fi

if [[ ${#failures[@]} -gt 0 ]]; then
  printf 'theme: FAIL %s\n' "${failures[@]}" >&2
  exit 1
fi

echo "theme: OK"
