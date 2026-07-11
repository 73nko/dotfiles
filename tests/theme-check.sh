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

printf '{"status":{"error":"#9EE87FFF","success":"#FF9E9EFF"},"surface":[13,13,44]}\n' \
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
    }' "$ROOT/themes/violet-hour.json" >"$fixture/themes/violet-hour.json"
if output=$("$CHECKER" "$fixture" 2>&1); then
  echo "swapped semantic colors unexpectedly passed" >&2
  exit 1
fi
grep -Fq 'tool/semantic.json field status.error should be coral (#ff9e9e)' <<<"$output"
grep -Fq 'tool/semantic.json field status.success should be green (#9ee87f)' <<<"$output"

printf '{"status":{"error":"#FF9E9EFF","success":"#9EE87FFF"},"surface":[13,13,44]}\n' \
  >"$fixture/tool/semantic.json"
"$CHECKER" "$fixture"

cp "$ROOT/themes/violet-hour.json" "$fixture/themes/violet-hour.json"
printf '#0D0D2C\n#1A1745\n' >"$fixture/tool/hash.conf"
printf '0D0D2C\n' >"$fixture/tool/bare.conf"
printf '0xff0D0D2C\n' >"$fixture/tool/argb.conf"

jq '.required = {
      "tool/hash.conf": ["night", "indigo"],
      "tool/bare.conf": ["night"],
      "tool/argb.conf": ["night"]
    } | .references = {} | .semantic = {}' \
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

mkdir -p "$fixture/no-jq"
if output=$(PATH="$fixture/no-jq" /bin/bash "$CHECKER" "$fixture" 2>&1); then
  echo "theme checker without jq unexpectedly passed" >&2
  exit 1
fi
if [[ "$output" != 'theme: missing command: jq' ]]; then
  printf 'unexpected missing-jq output:\n%s\n' "$output" >&2
  exit 1
fi

printf '{"colors":' >"$fixture/themes/violet-hour.json"
if output=$("$CHECKER" "$fixture" 2>&1); then
  echo "malformed palette unexpectedly passed" >&2
  exit 1
fi
grep -Fq "theme: invalid palette: $fixture/themes/violet-hour.json" <<<"$output"
grep -Fq 'parse error:' <<<"$output"

jq -e '
  .required["borders/bordersrc"] == ["ice", "orchid"] and
  .required["bat/themes/Violet Hour.tmTheme"] ==
    ["night", "muted", "star", "orchid", "lilac", "rose", "bloom", "ice", "coral", "gold", "green", "teal", "azure"] and
  .required["Styles/violet-hour-slack-theme.txt"] ==
    ["indigo", "selection", "orchid", "night", "star", "ice", "rose"] and
  .semantic["raycast/violet-hour.json"] == {
    "colors.background": "night",
    "colors.backgroundSecondary": "indigo",
    "colors.text": "star",
    "colors.selection": "orchid",
    "colors.loader": "ice",
    "colors.red": "coral",
    "colors.orange": "gold",
    "colors.yellow": "gold",
    "colors.green": "green",
    "colors.blue": "azure",
    "colors.purple": "orchid",
    "colors.magenta": "teal"
  } and
  .semantic["zed/themes/violet-hour.json"] == {
    "themes.0.style.error": "coral",
    "themes.0.style.warning": "gold",
    "themes.0.style.success": "green",
    "themes.0.style.info": "teal",
    "themes.0.style.conflict": "coral",
    "themes.0.style.created": "green",
    "themes.0.style.modified": "gold",
    "themes.0.style.deleted": "coral",
    "themes.0.style.renamed": "rose"
  } and
  .semantic["chrome-theme/manifest.json"] == {
    "theme.colors.frame": "night",
    "theme.colors.frame_incognito": "indigo",
    "theme.colors.toolbar": "indigo",
    "theme.colors.omnibox_background": "indigo",
    "theme.colors.toolbar_text": "star",
    "theme.colors.tab_text": "star",
    "theme.colors.bookmark_text": "star",
    "theme.colors.ntp_text": "star",
    "theme.colors.omnibox_text": "star",
    "theme.colors.ntp_background": "night",
    "theme.colors.ntp_link": "ice",
    "theme.colors.ntp_header": "orchid",
    "theme.colors.button_background": "orchid"
  }
' "$ROOT/themes/violet-hour.json" >/dev/null
if rg -Fq '#2C2766' "$ROOT/Styles/violet-hour-slack-theme.txt"; then
  echo "Slack theme still contains its noncanonical hover color" >&2
  exit 1
fi

"$CHECKER" "$ROOT"

echo "theme checker: OK"
