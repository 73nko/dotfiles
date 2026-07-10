#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TRACKED=$(git -C "$ROOT" ls-files)

runtime_paths=(
  "uv/uv-receipt.json"
  "yarn/global/node_modules/.yarn-integrity"
  "zed/prompts/prompts-library-db.0.mdb/data.mdb"
  "zed/prompts/prompts-library-db.0.mdb/lock.mdb"
  "zed/settings_backup.json"
)

for path in "${runtime_paths[@]}"; do
  if rg -Fqx "$path" <<<"$TRACKED"; then
    echo "tracked runtime state: $path" >&2
    exit 1
  fi
  git -C "$ROOT" check-ignore -q "$path"
done

if rg -q '^yazi/plugins/|^yazi/flavors/(neon-nocturne|tokyo-night)\.yazi/' <<<"$TRACKED"; then
  echo "tracked generated or inactive Yazi content" >&2
  exit 1
fi

if rg -q '^use = "yazi-rs/plugins:max-preview"$' "$ROOT/yazi/package.toml" ||
  rg -q '^run = "plugin max-preview"$' "$ROOT/yazi/keymap.toml"; then
  echo "stale Yazi max-preview integration" >&2
  exit 1
fi

rg -q '^use = "yazi-rs/plugins:toggle-pane"$' "$ROOT/yazi/package.toml"
rg -q '^run = "plugin toggle-pane max-preview"$' "$ROOT/yazi/keymap.toml"

if rg -q '^brew "glow"' "$ROOT/.Brewfile"; then
  echo "Glow is still declared" >&2
  exit 1
fi

rg -q '^brew "shellcheck"' "$ROOT/.Brewfile"
echo "repo hygiene: OK"
