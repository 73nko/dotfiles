#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
docs=(
  "$ROOT/README.md"
  "$ROOT/personal/README.md"
  "$ROOT/docs/themes.md"
  "$ROOT/chrome-theme/README.md"
  "$ROOT/raycast/README.md"
  "$ROOT/zed/themes/README.md"
)

rg -q 'https://github.com/73nko/dotfiles.git' "$ROOT/README.md"
rg -qi 'preserves unrelated user tools' "$ROOT/README.md"
rg -Uqi 'private, application,\s+and account state' "$ROOT/README.md"
rg -qi 'manifest-owned generated dependencies' "$ROOT/README.md"
rg -Uqi 'may be installed,\s+updated, or purged' "$ROOT/README.md"
if rg -Fqi 'ignored personal or runtime data is not replaced' "$ROOT/README.md"; then
  exit 1
fi

if rg -qi 'CONFIG-AUDIT-2026-06|AUDIT-PLUGINS-2026-06|Sunset Pool Splash|glow/violet-hour|charmbracelet/glow|max-preview' "${docs[@]}"; then
  exit 1
fi
rg -q 'toggle-pane' "$ROOT/README.md"

rg -q 'personal/.*optional' "$ROOT/README.md"
rg -Fq 'personal/fish/*.fish' "$ROOT/README.md"
rg -Fq 'personal/fish/*.fish' "$ROOT/fish/config.fish"
rg -qi 'public setup does not require' "$ROOT/personal/README.md"
rg -qi 'manually copy' "$ROOT/personal/README.md"
if rg -q 'YOUR-ORG|bundle-shopify|abbr[[:space:]]+-a[[:space:]]+awt([[:space:]]|$)' "$ROOT/fish/config.fish"; then
  exit 1
fi
if rg -qi '\bawt\b' "$ROOT/scripts/setup.sh"; then
  exit 1
fi

rg -qi 'Lazygit uses its native XDG path' "$ROOT/README.md"
rg -Fq '.config/lazygit/config.yml' "$ROOT/README.md"
[[ -f "$ROOT/lazygit/config.yml" ]]

while IFS=$'\t' read -r name value; do
  rg -Fqi "| $name | \`$value\` |" "$ROOT/docs/themes.md"
done < <(jq -r '.colors | to_entries[] | [.key, .value] | @tsv' "$ROOT/themes/violet-hour.json")

required_paths=(
  "scripts/setup.sh"
  "scripts/check-config.sh"
  "scripts/check-theme.sh"
  "personal/README.md"
  "gh-dash/config.yml.example"
  "fastfetch/config.jsonc"
  "lazygit/config.yml"
  "themes/violet-hour.json"
  "bat/themes/Violet Hour.tmTheme"
  "chrome-theme/manifest.json"
  "raycast/violet-hour.json"
  "zed/themes/violet-hour.json"
)
for path in "${required_paths[@]}"; do
  [[ -e "$ROOT/$path" ]]
done

rg -Fq 'bash ~/.config/scripts/setup.sh' "$ROOT/README.md"
rg -q 'setup\.sh doctor' "$ROOT/README.md"
rg -q 'setup\.sh export' "$ROOT/README.md"
rg -q 'setup\.sh --upgrade' "$ROOT/README.md"
echo "documentation: OK"
