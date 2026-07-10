#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
CHECKER="$ROOT/scripts/check-theme.sh"

[[ -x "$CHECKER" ]] || {
  echo "theme checker is missing" >&2
  exit 1
}

fixture=$(mktemp -d)
trap 'rm -rf "$fixture"' EXIT
mkdir -p "$fixture/themes" "$fixture/tool"
cp "$ROOT/themes/violet-hour.json" "$fixture/themes/violet-hour.json"
printf '#0D0D2C\n#1A1745\n' >"$fixture/tool/hash.conf"
printf '0D0D2C\n' >"$fixture/tool/bare.conf"
printf '0xff0D0D2C\n' >"$fixture/tool/argb.conf"

jq '.required = {
      "tool/hash.conf": ["night", "indigo"],
      "tool/bare.conf": ["night"],
      "tool/argb.conf": ["night"]
    } | .references = {}' \
  "$fixture/themes/violet-hour.json" >"$fixture/themes/palette.tmp"
mv "$fixture/themes/palette.tmp" "$fixture/themes/violet-hour.json"

"$CHECKER" "$fixture"

for legacy in '#1A0A28' '1A0A28' '0xff1A0A28'; do
  printf '#0D0D2C\n#1A1745\n%s\n' "$legacy" >"$fixture/tool/hash.conf"
  if output=$("$CHECKER" "$fixture" 2>&1); then
    echo "legacy fixture unexpectedly passed: $legacy" >&2
    exit 1
  fi
  grep -Fq 'contains legacy color #1a0a28' <<<"$output"
done

rm "$fixture/tool/hash.conf"
if output=$("$CHECKER" "$fixture" 2>&1); then
  echo "missing active theme file unexpectedly passed" >&2
  exit 1
fi
expected='theme: FAIL missing active theme file: tool/hash.conf'
if [[ "$output" != "$expected" ]]; then
  printf 'unexpected missing-file output:\n%s\n' "$output" >&2
  exit 1
fi

"$CHECKER" "$ROOT"

echo "theme checker: OK"
