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
cp "$ROOT/themes/glacier-signal.json" "$fixture/themes/glacier-signal.json"

printf '{"status":{"error":"#8fdc8fFF","success":"#ff7a6eFF"},"surface":[6,34,48]}\n' \
  >"$fixture/tool/semantic.json"
jq '.required = {} |
    .references = {} |
    .legacy = [] |
    .semantic = {
      "tool/semantic.json": {
        "status.error": "coral",
        "status.success": "green",
        "surface": "night"
      }
    }' "$ROOT/themes/glacier-signal.json" >"$fixture/themes/glacier-signal.json"
if output=$("$CHECKER" "$fixture" 2>&1); then
  echo "swapped semantic colors unexpectedly passed" >&2
  exit 1
fi
grep -Fq 'tool/semantic.json field status.error should be coral (#ff7a6e)' <<<"$output"
grep -Fq 'tool/semantic.json field status.success should be green (#8fdc8f)' <<<"$output"

printf '{"status":{"error":"#ff7a6eFF","success":"#8fdc8fFF"},"surface":[6,34,48]}\n' \
  >"$fixture/tool/semantic.json"
"$CHECKER" "$fixture"

cp "$ROOT/themes/glacier-signal.json" "$fixture/themes/glacier-signal.json"
printf '#062230\n#0d3547\n' >"$fixture/tool/hash.conf"
printf '062230\n' >"$fixture/tool/bare.conf"
printf '0xff062230\n' >"$fixture/tool/argb.conf"

jq '.required = {
      "tool/hash.conf": ["night", "fjord"],
      "tool/bare.conf": ["night"],
      "tool/argb.conf": ["night"]
    } | .references = {} | .semantic = {}' \
  "$fixture/themes/glacier-signal.json" >"$fixture/themes/palette.tmp"
mv "$fixture/themes/palette.tmp" "$fixture/themes/glacier-signal.json"

"$CHECKER" "$fixture"

cp "$fixture/themes/glacier-signal.json" "$fixture/themes/palette.valid"
jq '.required = {"tool/hash.conf": ["does-not-exist"]}' \
  "$fixture/themes/palette.valid" >"$fixture/themes/glacier-signal.json"
if output=$("$CHECKER" "$fixture" 2>&1); then
  echo "unknown palette color unexpectedly passed" >&2
  exit 1
fi
grep -Fq 'theme: invalid required palette data:' <<<"$output"
grep -Fq 'invalid or missing palette color: does-not-exist' <<<"$output"
mv "$fixture/themes/palette.valid" "$fixture/themes/glacier-signal.json"

for legacy in '#1A0A28' '1A0A28' '0xff1A0A28'; do
  printf '#062230\n#0d3547\n%s\n' "$legacy" >"$fixture/tool/hash.conf"
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

mkdir -p "$fixture/no-jq"
if output=$(PATH="$fixture/no-jq" /bin/bash "$CHECKER" "$fixture" 2>&1); then
  echo "theme checker without jq unexpectedly passed" >&2
  exit 1
fi
if [[ "$output" != 'theme: missing command: jq' ]]; then
  printf 'unexpected missing-jq output:\n%s\n' "$output" >&2
  exit 1
fi

printf '{"colors":' >"$fixture/themes/glacier-signal.json"
if output=$("$CHECKER" "$fixture" 2>&1); then
  echo "malformed palette unexpectedly passed" >&2
  exit 1
fi
grep -Fq "theme: invalid palette: $fixture/themes/glacier-signal.json" <<<"$output"
grep -Fq 'parse error:' <<<"$output"

jq -e '
  .required["borders/bordersrc"] == ["ice", "signal"] and
  .required["bat/themes/Glacier Signal.tmTheme"] ==
    ["night", "muted", "snow", "signal", "glow", "mint", "frost", "ice", "coral", "gold", "green", "teal", "azure"] and
  .required["Styles/glacier-signal-slack-theme.txt"] ==
    ["fjord", "selection", "signal", "night", "snow", "ice", "mint"] and
  .semantic["raycast/glacier-signal.json"] == {
    "colors.background": "night",
    "colors.backgroundSecondary": "fjord",
    "colors.text": "snow",
    "colors.selection": "signal",
    "colors.loader": "ice",
    "colors.red": "coral",
    "colors.orange": "gold",
    "colors.yellow": "gold",
    "colors.green": "green",
    "colors.blue": "azure",
    "colors.purple": "signal",
    "colors.magenta": "teal"
  } and
  .semantic["zed/themes/glacier-signal.json"] == {
    "themes.0.style.error": "coral",
    "themes.0.style.warning": "gold",
    "themes.0.style.success": "green",
    "themes.0.style.info": "teal",
    "themes.0.style.conflict": "coral",
    "themes.0.style.created": "green",
    "themes.0.style.modified": "gold",
    "themes.0.style.deleted": "coral",
    "themes.0.style.renamed": "mint"
  } and
  .semantic["chrome-theme/manifest.json"] == {
    "theme.colors.frame": "night",
    "theme.colors.frame_incognito": "fjord",
    "theme.colors.toolbar": "fjord",
    "theme.colors.omnibox_background": "fjord",
    "theme.colors.toolbar_text": "snow",
    "theme.colors.tab_text": "snow",
    "theme.colors.bookmark_text": "snow",
    "theme.colors.ntp_text": "snow",
    "theme.colors.omnibox_text": "snow",
    "theme.colors.ntp_background": "night",
    "theme.colors.ntp_link": "ice",
    "theme.colors.ntp_header": "signal",
    "theme.colors.button_background": "signal"
  }
' "$ROOT/themes/glacier-signal.json" >/dev/null
if rg -Fq '#174b60' "$ROOT/Styles/glacier-signal-slack-theme.txt"; then
  echo "Slack theme still contains its noncanonical hover color" >&2
  exit 1
fi

"$CHECKER" "$ROOT"

echo "theme checker: OK"
