#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

rg -q 'set -gx XDG_CONFIG_HOME \$HOME/.config' "$ROOT/fish/conf.d/env.fish"
rg -q "abbr -a prune-branches 'gh poi'" "$ROOT/fish/config.fish"
if rg -q 'del-branches|glow .*cheatsheet' "$ROOT/fish/config.fish"; then
    exit 1
fi
if rg -q 'YOUR-ORG|bundle-shopify|abbr[[:space:]]+-a[[:space:]]+awt([[:space:]]|$)' "$ROOT/fish/config.fish"; then
    exit 1
fi
rg -q 'mode-keys vi' "$ROOT/tmux/tmux.conf"
rg -q '^set -g scroll-on-clear on$' "$ROOT/tmux/tmux.conf"
rg -q '^set -g copy-mode-line-numbers default$' "$ROOT/tmux/tmux.conf"
rg -q 'status-right .*#H' "$ROOT/tmux/tmux.conf"
rg -q 'popup-border-style.*#22b8f5' "$ROOT/tmux/tmux.conf"
rg -q 'personal/tmux/\*\.conf' "$ROOT/tmux/tmux.conf"
rg -q "tmux-plugins/tmux-resurrect" "$ROOT/tmux/tmux.conf"
rg -q "tmux-plugins/tmux-continuum" "$ROOT/tmux/tmux.conf"
rg -q '@continuum-restore.*on' "$ROOT/tmux/tmux.conf"
[[ -f "$ROOT/lazygit/config.yml" ]]
lazygit --use-config-file "$ROOT/lazygit/config.yml" --config >/dev/null
rg -q '^  filterMode: fuzzy$' "$ROOT/lazygit/config.yml"
rg -q '^  diffRenderers:$' "$ROOT/lazygit/config.yml"
if rg -q '^  paging:$' "$ROOT/lazygit/config.yml"; then
    echo "deprecated lazygit git.paging remains" >&2
    exit 1
fi

history_patterns=()
while IFS= read -r pattern; do
    history_patterns+=(-e "$pattern")
done < <(
    sed -n '/^history_filter = \[/,/^\]/p' "$ROOT/atuin/config.toml" |
        sed -n 's/^[[:space:]]*"\(.*\)",[[:space:]]*$/\1/p'
)
[[ ${#history_patterns[@]} -gt 0 ]]
secret_commands=(
    'GITHUB_TOKEN=github-secret'
    'export GITHUB_TOKEN=github-secret'
    'env GH_TOKEN=cli-secret'
    'runner api_key=api-secret'
    'deploy --password=password-secret'
    'Api-Key=api-secret'
    'export ACCESS_TOKEN=access-secret'
    'env auth_token=auth-secret'
    'CLIENT_SECRET=client-secret'
    'Password=password-secret'
)
for command in "${secret_commands[@]}"; do
    if ! rg -q "${history_patterns[@]}" <<<"$command"; then
        printf 'Atuin history filters missed: %s\n' "$command" >&2
        exit 1
    fi
done
if rg -q "${history_patterns[@]}" <<<'git status'; then
    echo "Atuin history filters matched a benign command" >&2
    exit 1
fi
echo "daily tools: OK"
