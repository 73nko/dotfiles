#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

rg -q 'set -gx XDG_CONFIG_HOME \$HOME/.config' "$ROOT/fish/conf.d/env.fish"
rg -q "abbr -a prune-branches 'gh poi'" "$ROOT/fish/config.fish"
if rg -q 'del-branches|glow .*cheatsheet' "$ROOT/fish/config.fish"; then
    exit 1
fi
rg -q 'mode-keys vi' "$ROOT/tmux/tmux.conf"
rg -q 'popup-border-style.*#b39dff' "$ROOT/tmux/tmux.conf"
rg -q 'personal/tmux/\*\.conf' "$ROOT/tmux/tmux.conf"
[[ -f "$ROOT/lazygit/config.yml" ]]
lazygit --use-config-file "$ROOT/lazygit/config.yml" --config >/dev/null
rg -Fq '(?i)(api[_-]?key' "$ROOT/atuin/config.toml"
echo "daily tools: OK"
