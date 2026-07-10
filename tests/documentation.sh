#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
docs=(
  "$ROOT/README.md"
  "$ROOT/docs/themes.md"
  "$ROOT/chrome-theme/README.md"
  "$ROOT/raycast/README.md"
  "$ROOT/zed/themes/README.md"
)

rg -q 'https://github.com/73nko/dotfiles.git' "$ROOT/README.md"
if rg -qi 'CONFIG-AUDIT-2026-06|AUDIT-PLUGINS-2026-06|Sunset Pool Splash|glow/violet-hour|charmbracelet/glow' "${docs[@]}"; then
  exit 1
fi
rg -q 'personal/.*optional' "$ROOT/README.md"
rg -q 'setup\.sh doctor' "$ROOT/README.md"
echo "documentation: OK"
