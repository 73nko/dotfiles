#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TRACKED=$(git -C "$ROOT" ls-files)

if grep -Eq '^yazi/plugins/|^yazi/flavors/(neon-nocturne|tokyo-night)\.yazi/' <<<"$TRACKED"; then
  exit 1
fi
[[ ! -e "$ROOT/topgrade.d/custom.toml" ]]
if rg -q '^\s+previewers = \{|^\s+icons = \{|^\s+sort = \{' "$ROOT/nvim/lua/alex/plugins/snacks.lua"; then
  exit 1
fi
rg -q 'cwd_bonus = true' "$ROOT/nvim/lua/alex/plugins/snacks.lua"
rg -q 'frecency = true' "$ROOT/nvim/lua/alex/plugins/snacks.lua"
echo "tool ownership: OK"
