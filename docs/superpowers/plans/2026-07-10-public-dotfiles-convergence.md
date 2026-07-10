# Public Dotfiles Convergence Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the public repository safely reproduce and verify the same daily Mac tooling with a consistent Violet Hour theme.

**Architecture:** Keep `scripts/setup.sh` as the convergence entry point, add focused repository/theme checkers that `doctor` can call, and keep each tool in its native configuration format. Runtime state is ignored, package manifests own generated dependencies, and public Fish/tmux files expose generic optional extension seams without depending on `personal/`.

**Tech Stack:** Bash 3.2-compatible shell, Fish 4, Homebrew Bundle, tmux 3.5+, Neovim 0.12, lazygit YAML, Yazi TOML/Lua, jq, Git.

## Global Constraints

- Install the same public stack on every Mac; do not add machine profiles.
- Public setup must not know whether `personal/` or `awt` exists.
- Normal convergence is additive and must not remove unrelated user tools.
- Keep the current core tool stack; replace or remove only for a substantial benefit.
- Preserve current daily keybindings unless correcting a demonstrated safety or reliability problem.
- Keep Violet Hour as the active identity while retaining semantic red, gold, green, and cyan states.
- Never stage private files, secrets, histories, caches, application databases, or account state.
- Preserve the user's existing tmux change in intent while replacing its hardcoded private include with the generic loader.

---

### Task 1: Remove false reproducibility and declare validation ownership

**Files:**
- Create: `tests/repo-hygiene.sh`
- Modify: `.gitignore`
- Modify: `.Brewfile`
- Remove from tracking: `uv/uv-receipt.json`
- Remove from tracking: `yarn/global/node_modules/.yarn-integrity`
- Remove from tracking: `zed/prompts/prompts-library-db.0.mdb/data.mdb`
- Remove from tracking: `zed/prompts/prompts-library-db.0.mdb/lock.mdb`
- Remove from tracking: `zed/settings_backup.json`
- Remove from tracking: `yazi/plugins/`
- Remove: `yazi/flavors/neon-nocturne.yazi/`
- Remove: `yazi/flavors/tokyo-night.yazi/`

**Interfaces:**
- Consumes: Git's tracked-file list and ignore rules.
- Produces: `tests/repo-hygiene.sh`, the canonical guard used by later verification tasks.

- [ ] **Step 1: Write the failing repository-hygiene test**

```bash
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
  if grep -Fqx "$path" <<<"$TRACKED"; then
    echo "tracked runtime state: $path" >&2
    exit 1
  fi
  git -C "$ROOT" check-ignore -q "$path"
done

if grep -Eq '^yazi/plugins/|^yazi/flavors/(neon-nocturne|tokyo-night)\.yazi/' <<<"$TRACKED"; then
  echo "tracked generated or inactive Yazi content" >&2
  exit 1
fi

if rg -q '^brew "glow"' "$ROOT/.Brewfile"; then
  echo "Glow is still declared" >&2
  exit 1
fi

rg -q '^brew "shellcheck"' "$ROOT/.Brewfile"
echo "repo hygiene: OK"
```

- [ ] **Step 2: Run the test and verify the current repository fails**

Run: `bash tests/repo-hygiene.sh`

Expected: FAIL naming `uv/uv-receipt.json` as tracked runtime state.

- [ ] **Step 3: Add precise ignore rules and update the Brewfile**

Add these rules to `.gitignore` under runtime state:

```gitignore
# Generated package/application state
uv/uv-receipt.json
yarn/global/node_modules/
zed/prompts/
zed/settings_backup.json
yazi/plugins/
```

Remove this line from `.Brewfile`:

```ruby
brew "glow"
```

Add ShellCheck beside the other shell-development formulae:

```ruby
# Static analysis for shell scripts
brew "shellcheck"
```

- [ ] **Step 4: Stop tracking runtime state without deleting local application data**

Run:

```bash
git rm --cached uv/uv-receipt.json
git rm --cached yarn/global/node_modules/.yarn-integrity
git rm --cached zed/prompts/prompts-library-db.0.mdb/data.mdb
git rm --cached zed/prompts/prompts-library-db.0.mdb/lock.mdb
git rm --cached zed/settings_backup.json
git rm -r yazi/plugins
git rm -r yazi/flavors/neon-nocturne.yazi
git rm -r yazi/flavors/tokyo-night.yazi
ya pkg install
```

Expected: application state is staged as deletion but retained locally where
needed; Yazi recreates its locked plugins as ignored files; only the Violet Hour
flavor remains tracked.

- [ ] **Step 5: Run the hygiene test**

Run: `bash tests/repo-hygiene.sh`

Expected: `repo hygiene: OK`.

- [ ] **Step 6: Commit the ownership cleanup**

```bash
git add .gitignore .Brewfile tests/repo-hygiene.sh
git commit -m "Remove tracked runtime state"
```

---

### Task 2: Add the canonical Violet Hour palette and drift checker

**Files:**
- Create: `themes/violet-hour.json`
- Create: `scripts/check-theme.sh`
- Create: `tests/theme-check.sh`
- Modify: `raycast/violet-hour.json`

**Interfaces:**
- Consumes: native active theme files and `jq`.
- Produces: `scripts/check-theme.sh [ROOT]`, returning zero on consistency and nonzero with one line per drift.

- [ ] **Step 1: Write the failing theme-checker test**

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
CHECKER="$ROOT/scripts/check-theme.sh"

[[ -x "$CHECKER" ]] || {
  echo "theme checker is missing" >&2
  exit 1
}

"$CHECKER" "$ROOT"

fixture=$(mktemp -d)
trap 'rm -rf "$fixture"' EXIT
mkdir -p "$fixture/themes" "$fixture/tool"
cp "$ROOT/themes/violet-hour.json" "$fixture/themes/violet-hour.json"
printf '#1A0A28\n' >"$fixture/tool/theme.conf"

jq '.required = {"tool/theme.conf": ["night"]} | .references = {}' \
  "$fixture/themes/violet-hour.json" >"$fixture/themes/palette.tmp"
mv "$fixture/themes/palette.tmp" "$fixture/themes/violet-hour.json"

if "$CHECKER" "$fixture" >/dev/null 2>&1; then
  echo "legacy fixture unexpectedly passed" >&2
  exit 1
fi

echo "theme checker: OK"
```

- [ ] **Step 2: Run the test and verify it fails because the checker is absent**

Run: `bash tests/theme-check.sh`

Expected: FAIL with `theme checker is missing`.

- [ ] **Step 3: Create the canonical palette manifest**

Create `themes/violet-hour.json` with this complete structure:

```json
{
  "colors": {
    "abyss": "#06061a",
    "night": "#0d0d2c",
    "indigo": "#1a1745",
    "panel": "#211e45",
    "branch": "#2f365a",
    "selection": "#322d5a",
    "muted": "#777494",
    "star": "#ece6ff",
    "orchid": "#b39dff",
    "lilac": "#d6c8ff",
    "rose": "#e2bcff",
    "bloom": "#f0d2ff",
    "periwinkle": "#8da7ff",
    "ice": "#a8c9ff",
    "coral": "#ff9e9e",
    "gold": "#ffcf7a",
    "green": "#9ee87f",
    "teal": "#5fe0c8",
    "azure": "#7fb0ff"
  },
  "legacy": ["#1a0a28", "#3a1550", "#ff3d8a", "#ffc6a0", "#4ec9d7", "#7fe0eb"],
  "required": {
    "ghostty/config": ["night", "star", "coral", "gold", "green", "azure", "orchid", "teal"],
    "nvim/lua/alex/themes/violet-hour.lua": ["night", "indigo", "branch", "muted", "star", "orchid", "lilac", "rose", "bloom", "ice", "coral", "gold", "green", "teal", "azure"],
    "tmux/tmux.conf": ["night", "indigo", "branch", "muted", "star", "orchid", "lilac", "rose", "bloom", "ice"],
    "fish/config.fish": ["night", "selection", "star", "orchid", "coral", "gold", "green", "teal", "azure"],
    "fish/conf.d/violet-hour-tide.fish": ["indigo", "muted", "star", "orchid", "lilac", "rose", "bloom", "periwinkle", "ice"],
    "yazi/flavors/violet-hour.yazi/flavor.toml": ["night", "indigo", "branch", "muted", "star", "orchid", "lilac", "rose", "bloom", "ice", "coral", "gold", "green", "teal", "azure"],
    "btop/themes/violet-hour.theme": ["night", "indigo", "muted", "star", "orchid", "lilac", "rose", "bloom", "periwinkle", "ice"],
    "sketchybar/colors.sh": ["night", "indigo", "muted", "star", "orchid", "lilac", "rose", "bloom", "periwinkle", "ice"],
    "raycast/violet-hour.json": ["night", "indigo", "star", "orchid", "coral", "gold", "green", "teal", "azure"],
    "zed/themes/violet-hour.json": ["night", "indigo", "branch", "muted", "star", "orchid", "lilac", "rose", "bloom", "ice", "coral", "gold", "green", "teal", "azure"]
  },
  "references": {
    "bat/config": "Violet Hour",
    "git/config": "syntax-theme = Violet Hour",
    "yazi/theme.toml": "violet-hour",
    "btop/btop.conf": "color_theme = \"violet-hour\"",
    "zed/settings.json": "\"theme\": \"Violet Hour\"",
    "chrome-theme/manifest.json": "Violet Hour"
  }
}
```

- [ ] **Step 4: Align Raycast's semantic slots with the active palette**

Replace the `colors` object in `raycast/violet-hour.json` with:

```json
"colors": {
  "background": "#0D0D2C",
  "backgroundSecondary": "#1A1745",
  "text": "#ECE6FF",
  "selection": "#B39DFF",
  "loader": "#A8C9FF",
  "red": "#FF9E9E",
  "orange": "#FFCF7A",
  "yellow": "#FFCF7A",
  "green": "#9EE87F",
  "blue": "#7FB0FF",
  "purple": "#B39DFF",
  "magenta": "#5FE0C8"
}
```

- [ ] **Step 5: Implement the drift checker**

Create `scripts/check-theme.sh`:

```bash
#!/usr/bin/env bash
set -uo pipefail

ROOT=${1:-"${XDG_CONFIG_HOME:-$HOME/.config}"}
PALETTE="$ROOT/themes/violet-hour.json"
failures=()

fail() {
  failures+=("$1")
}

[[ -f "$PALETTE" ]] || {
  echo "theme: missing $PALETTE" >&2
  exit 1
}

while IFS=$'\t' read -r file color; do
  path="$ROOT/$file"
  hex=$(jq -r --arg color "$color" '.colors[$color]' "$PALETTE")
  if [[ ! -f "$path" ]]; then
    fail "missing active theme file: $file"
  elif ! grep -Fiq "$hex" "$path"; then
    fail "$file does not contain $color ($hex)"
  fi
done < <(jq -r '.required | to_entries[] | .key as $file | .value[] | [$file, .] | @tsv' "$PALETTE")

while IFS=$'\t' read -r file expected; do
  path="$ROOT/$file"
  if [[ ! -f "$path" ]] || ! grep -Fq "$expected" "$path"; then
    fail "$file does not activate $expected"
  fi
done < <(jq -r '.references | to_entries[] | [.key, .value] | @tsv' "$PALETTE")

while IFS= read -r file; do
  while IFS= read -r legacy; do
    if grep -Fiq "$legacy" "$ROOT/$file"; then
      fail "$file contains legacy color $legacy"
    fi
  done < <(jq -r '.legacy[]' "$PALETTE")
done < <(jq -r '.required | keys[]' "$PALETTE")

if [[ ${#failures[@]} -gt 0 ]]; then
  printf 'theme: FAIL %s\n' "${failures[@]}" >&2
  exit 1
fi

echo "theme: OK"
```

Make both scripts executable.

- [ ] **Step 6: Run the theme test**

Run: `bash tests/theme-check.sh`

Expected: `theme: OK` followed by `theme checker: OK`.

- [ ] **Step 7: Commit the palette contract**

```bash
git add themes/violet-hour.json scripts/check-theme.sh tests/theme-check.sh raycast/violet-hour.json
git commit -m "Add Violet Hour drift checks"
```

---

### Task 3: Add static configuration checks and make setup non-destructive

**Files:**
- Create: `scripts/check-config.sh`
- Create: `tests/config-check.sh`
- Modify: `scripts/setup.sh`
- Modify: `scripts/macos-violet-hour.sh`
- Modify: `scripts/git-orchard.sh`

**Interfaces:**
- Consumes: `scripts/check-theme.sh`, repository manifests, installed command availability.
- Produces: `scripts/check-config.sh`, called directly by tests and from `setup.sh doctor`.

- [ ] **Step 1: Write the failing integration test**

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

[[ -x "$ROOT/scripts/check-config.sh" ]]
output=$("$ROOT/scripts/check-config.sh")
grep -Fq "config: OK" <<<"$output"

if rg -q '^legacy_cleanup\(\)' "$ROOT/scripts/setup.sh"; then
  echo "destructive legacy cleanup remains" >&2
  exit 1
fi

rg -q 'check-config\.sh' "$ROOT/scripts/setup.sh"
rg -q 'HOMEBREW_NO_AUTO_UPDATE=1' "$ROOT/scripts/setup.sh"
echo "config integration: OK"
```

- [ ] **Step 2: Run the test and verify it fails because the checker is absent**

Run: `bash tests/config-check.sh`

Expected: FAIL on the executable check.

- [ ] **Step 3: Implement `scripts/check-config.sh`**

```bash
#!/usr/bin/env bash
set -uo pipefail

ROOT=${DOTFILES_ROOT:-"$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"}
failures=()

run_check() {
  local label=$1
  shift
  if "$@" >/dev/null 2>&1; then
    printf '  OK   %s\n' "$label"
  else
    printf '  FAIL %s\n' "$label" >&2
    failures+=("$label")
  fi
}

check_bash() {
  local files=()
  while IFS= read -r file; do files+=("$ROOT/$file"); done < <(git -C "$ROOT" ls-files 'scripts/*.sh' 'tests/*.sh')
  bash -n "${files[@]}"
}

check_fish() {
  local file
  while IFS= read -r file; do
    fish --no-execute "$ROOT/$file" || return 1
  done < <(git -C "$ROOT" ls-files 'fish/*.fish' 'fish/**/*.fish')
}

check_json() {
  local file
  while IFS= read -r file; do
    case "$file" in
      zed/settings.json|zed/keymap.json|zed/tasks.json) continue ;;
    esac
    jq empty "$ROOT/$file" || return 1
  done < <(git -C "$ROOT" ls-files '*.json')
}

check_toml() {
  ROOT="$ROOT" python3 - <<'PY'
import os
import pathlib
import subprocess
import tomllib

root = pathlib.Path(os.environ["ROOT"])
files = subprocess.check_output(["git", "-C", str(root), "ls-files", "*.toml"], text=True).splitlines()
for file in files:
    with (root / file).open("rb") as handle:
        tomllib.load(handle)
PY
}

check_runtime_state() {
  ! git -C "$ROOT" ls-files | rg -q '(^uv/uv-receipt\.json$|^yarn/global/node_modules/|^zed/prompts/|^zed/settings_backup\.json$|^yazi/plugins/)'
}

check_shellcheck() {
  local shellcheck_bin files=()
  shellcheck_bin=$(command -v shellcheck 2>/dev/null || true)
  [[ -n "$shellcheck_bin" ]] || shellcheck_bin="$HOME/.local/share/nvim/mason/bin/shellcheck"
  [[ -x "$shellcheck_bin" ]] || return 1
  while IFS= read -r file; do files+=("$ROOT/$file"); done < <(git -C "$ROOT" ls-files 'scripts/*.sh' 'tests/*.sh')
  "$shellcheck_bin" "${files[@]}"
}

run_check "Bash syntax" check_bash
run_check "ShellCheck" check_shellcheck
run_check "Fish syntax" check_fish
run_check "JSON syntax" check_json
run_check "TOML syntax" check_toml
run_check "Violet Hour theme" "$ROOT/scripts/check-theme.sh" "$ROOT"
run_check "No tracked runtime state" check_runtime_state

if [[ ${#failures[@]} -gt 0 ]]; then
  printf 'config: %d failure(s)\n' "${#failures[@]}" >&2
  exit 1
fi

echo "config: OK"
```

- [ ] **Step 4: Refactor `scripts/setup.sh`**

Delete the complete `legacy_cleanup()` function and remove its call from the
`sync` dispatch. In `theming()`, replace unconditional wallpaper generation
with:

```bash
local wallpaper="$DOTS/wallpapers/violet-hour-aurora-5120x3200.png"
if [[ -f "$wallpaper" ]]; then
  skip "wallpaper assets already present"
elif [[ -f "$DOTS/scripts/generate_wallpaper.py" ]]; then
  run "generate wallpaper assets" python3 "$DOTS/scripts/generate_wallpaper.py"
fi
```

At the start of `doctor()`, run the public checker:

```bash
if [[ -x "$DOTS/scripts/check-config.sh" ]]; then
  run "static dotfiles checks" "$DOTS/scripts/check-config.sh"
else
  fail "scripts/check-config.sh missing"
fi
```

Add read-only live configuration checks above `doctor()`:

```bash
check_tmux_config() {
  local temp socket=dotfiles-doctor
  temp=$(mktemp -d)
  TMUX_TMPDIR="$temp" tmux -L "$socket" -f "$DOTS/tmux/tmux.conf" new-session -d -s doctor || {
    rm -rf "$temp"
    return 1
  }
  TMUX_TMPDIR="$temp" tmux -L "$socket" kill-server >/dev/null 2>&1 || true
  rm -rf "$temp"
}

check_nvim_config() {
  local state cache
  state=$(mktemp -d)
  cache=$(mktemp -d)
  XDG_STATE_HOME="$state" XDG_CACHE_HOME="$cache" \
    nvim --headless '+checkhealth vim.deprecated' +qa
  local result=$?
  rm -rf "$state" "$cache"
  return "$result"
}

check_yazi_config() {
  yazi --debug 2>&1 | grep -Fq 'violet-hour'
}

check_fisher_plugins() {
  fish -c '
    set installed (fisher list)
    while read -l plugin
      string match -qr "^#|^$" -- $plugin; and continue
      contains -- $plugin $installed; or exit 1
    end < ~/.config/fish/fish_plugins
  '
}

check_tpm_plugins() {
  local plugin
  for plugin in tpm smart-splits.nvim tmux-sessionx; do
    [[ -d "$DOTS/tmux/plugins/$plugin" ]] || return 1
  done
}

check_mason_packages() {
  nvim --headless \
    '+lua local r=require("mason-registry"); for _,p in ipairs({"lua-language-server","vtsls","prettier"}) do assert(r.is_installed(p), p) end' \
    +qa
}
```

Call them from `doctor()` after command availability checks:

```bash
run "tmux config loads" check_tmux_config
run "Neovim starts without deprecated APIs" check_nvim_config
run "Yazi loads Violet Hour" check_yazi_config
run "Fisher plugins match fish_plugins" check_fisher_plugins
run "TPM plugins installed" check_tpm_plugins
run "representative Mason packages installed" check_mason_packages
```

After command checks, add a Brewfile state check that does not auto-update:

```bash
if command -v brew >/dev/null 2>&1; then
  if HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --file="$DOTS/.Brewfile" >/dev/null 2>&1; then
    ok "Brewfile dependencies satisfied"
  else
    warn "Brewfile drift: run setup.sh sync"
  fi
fi
```

In `scripts/macos-violet-hour.sh`, keep the protected pointer-domain warning but
remove the `open "x-apple.systempreferences:..."` call. Convergence must report
the manual Accessibility step without opening a GUI on every rerun.

Make the existing public scripts pass ShellCheck:

- In `scripts/git-orchard.sh`, remove unused declarations `R_PRIO`, `R_PATH`,
  `R_LINE`, and `rec`. Add `# shellcheck disable=SC2016` immediately before the
  intentional inner `sh -c` command whose single quotes defer expansion to the
  child shell.
- In `scripts/setup.sh`, replace both `A && B || C` constructs with explicit
  `if` statements.
- In `summary()`, use `printf '%b\n' "${GREEN}...${NC}"` rather than expanding
  color variables in the format string.

Make `scripts/check-config.sh` and its test executable.

- [ ] **Step 5: Run the static integration tests**

Run:

```bash
bash tests/repo-hygiene.sh
bash tests/theme-check.sh
bash tests/config-check.sh
bash -n scripts/setup.sh scripts/check-config.sh
```

Expected: all tests print `OK`; Bash syntax returns zero.

- [ ] **Step 6: Commit safe convergence**

```bash
git add scripts/setup.sh scripts/macos-violet-hour.sh scripts/git-orchard.sh scripts/check-config.sh tests/config-check.sh
git commit -m "Make Mac convergence non-destructive"
```

---

### Task 4: Improve Fish, tmux, Atuin, and lazygit

**Files:**
- Create: `lazygit/config.yml`
- Create: `tests/daily-tools.sh`
- Modify: `fish/conf.d/env.fish`
- Modify: `fish/config.fish`
- Modify: `tmux/tmux.conf`
- Modify: `atuin/config.toml`
- Modify: `themes/violet-hour.json`

**Interfaces:**
- Consumes: `XDG_CONFIG_HOME`, the palette contract, existing personal extension directories.
- Produces: a versioned lazygit config and generic public Fish/tmux extension seams.

- [ ] **Step 1: Write the failing daily-tools test**

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

rg -q 'set -gx XDG_CONFIG_HOME \$HOME/.config' "$ROOT/fish/conf.d/env.fish"
rg -q "abbr -a prune-branches 'gh poi'" "$ROOT/fish/config.fish"
! rg -q 'del-branches|glow .*cheatsheet' "$ROOT/fish/config.fish"
rg -q 'mode-keys vi' "$ROOT/tmux/tmux.conf"
rg -q 'popup-border-style.*#b39dff' "$ROOT/tmux/tmux.conf"
rg -q 'personal/tmux/\*\.conf' "$ROOT/tmux/tmux.conf"
[[ -f "$ROOT/lazygit/config.yml" ]]
lazygit --use-config-file "$ROOT/lazygit/config.yml" --config >/dev/null
rg -Fq '(?i)(api[_-]?key' "$ROOT/atuin/config.toml"
echo "daily tools: OK"
```

- [ ] **Step 2: Run the test and verify it fails on the missing XDG declaration**

Run: `bash tests/daily-tools.sh`

Expected: FAIL on the first `rg`.

- [ ] **Step 3: Establish XDG and safe Fish behavior**

Add to `fish/conf.d/env.fish` before editor variables:

```fish
set -gx XDG_CONFIG_HOME $HOME/.config
```

Replace the destructive branch abbreviation in `fish/config.fish` with:

```fish
abbr -a prune-branches 'gh poi'
```

Replace the Glow cheatsheet abbreviation with:

```fish
abbr -a ncheat 'nvim ~/.config/nvim/cheatsheet.md'
```

Replace the private Fish loader with:

```fish
for file in ~/.config/personal/fish/*.fish
    test -f "$file"; and source "$file"
end
```

- [ ] **Step 4: Activate Vim interaction and Violet Hour popups in tmux**

Add beside copy-mode configuration:

```tmux
setw -g mode-keys vi
set -g status-keys vi
```

Add before popup bindings:

```tmux
set -g popup-border-lines rounded
set -g popup-border-style "fg=#b39dff"
set -g popup-style "fg=#ece6ff,bg=#1a1745"
```

Replace the hardcoded personal include with:

```tmux
run-shell 'for file in "$HOME"/.config/personal/tmux/*.conf; do [ -f "$file" ] && tmux source-file "$file"; done'
```

- [ ] **Step 5: Add the minimal lazygit configuration**

```yaml
# yaml-language-server: $schema=https://raw.githubusercontent.com/jesseduffield/lazygit/master/schema/config.json
gui:
  border: rounded
  nerdFontsVersion: "3"
  showCommandLog: false
  theme:
    activeBorderColor:
      - "#a8c9ff"
      - bold
    inactiveBorderColor:
      - "#777494"
    searchingActiveBorderColor:
      - "#b39dff"
      - bold
    optionsTextColor:
      - "#d6c8ff"
    selectedLineBgColor:
      - "#322d5a"
    cherryPickedCommitBgColor:
      - "#2f365a"
    cherryPickedCommitFgColor:
      - "#e2bcff"
    markedBaseCommitBgColor:
      - "#1a1745"
    markedBaseCommitFgColor:
      - "#ffcf7a"
    unstagedChangesColor:
      - "#ff9e9e"
git:
  paging:
    colorArg: always
    pager: delta --dark --paging=never
```

- [ ] **Step 6: Strengthen Atuin history filtering and extend the palette contract**

Add this regex to `history_filter` in `atuin/config.toml`:

```toml
"(?i)(api[_-]?key|access[_-]?token|auth[_-]?token|client[_-]?secret|password)=",
```

Add this entry to `themes/violet-hour.json.required`:

```json
"lazygit/config.yml": ["indigo", "branch", "selection", "muted", "orchid", "lilac", "rose", "ice", "coral", "gold"]
```

- [ ] **Step 7: Run daily-tool validation**

Run:

```bash
bash tests/daily-tools.sh
bash tests/theme-check.sh
fish --no-execute fish/config.fish
fish --no-execute fish/conf.d/env.fish
```

Then load tmux in an isolated server:

```bash
tmux -L dotfiles-test -f "$PWD/tmux/tmux.conf" new-session -d -s dotfiles-test
tmux -L dotfiles-test show-options -gqv popup-style
tmux -L dotfiles-test kill-server
```

Expected: tests pass and popup style is `fg=#ece6ff,bg=#1a1745`.

- [ ] **Step 8: Commit daily-tool improvements**

```bash
git add fish/conf.d/env.fish fish/config.fish tmux/tmux.conf atuin/config.toml lazygit/config.yml themes/violet-hour.json tests/daily-tools.sh
git commit -m "Improve daily terminal workflow"
```

---

### Task 5: Simplify Neovim and Topgrade ownership

**Files:**
- Create: `tests/tool-ownership.sh`
- Modify: `nvim/lua/alex/plugins/snacks.lua`
- Remove: `topgrade.d/custom.toml`

**Interfaces:**
- Consumes: lazy.nvim's existing lockfile and built-in Snacks defaults.
- Produces: single-owner update behavior and a smaller behavior-equivalent Snacks override.

- [ ] **Step 1: Write the failing ownership test**

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TRACKED=$(git -C "$ROOT" ls-files)

! grep -Eq '^yazi/plugins/|^yazi/flavors/(neon-nocturne|tokyo-night)\.yazi/' <<<"$TRACKED"
[[ ! -e "$ROOT/topgrade.d/custom.toml" ]]
! rg -q '^\s+previewers = \{|^\s+icons = \{|^\s+sort = \{' "$ROOT/nvim/lua/alex/plugins/snacks.lua"
rg -q 'cwd_bonus = true' "$ROOT/nvim/lua/alex/plugins/snacks.lua"
rg -q 'frecency = true' "$ROOT/nvim/lua/alex/plugins/snacks.lua"
echo "tool ownership: OK"
```

- [ ] **Step 2: Run the test and verify it fails on tracked Yazi plugins**

Run: `bash tests/tool-ownership.sh`

Expected: FAIL because `topgrade.d/custom.toml` still exists.

- [ ] **Step 3: Confirm Task 1's Yazi ownership boundary**

Run:

```bash
git ls-files | rg '^yazi/plugins/|^yazi/flavors/(neon-nocturne|tokyo-night)\.yazi/' && exit 1 || true
ya pkg install
```

Expected: no tracked match; `ya pkg install` restores ignored plugins from
`package.toml`.

- [ ] **Step 4: Remove duplicated Topgrade custom updates**

Remove `topgrade.d/custom.toml`. Atuin already has `auto_sync = true`, setup owns
bat cache building and GitHub extensions, and lazy.nvim owns Neovim plugin
updates.

- [ ] **Step 5: Reduce the Snacks picker override to intentional differences**

Keep the custom layouts. Replace the copied `matcher`, `sort`, `formatters`,
`previewers`, `jump`, `win`, `icons`, and `debug` blocks with:

```lua
matcher = {
  cwd_bonus = true,
  frecency = true,
},
win = {
  input = {
    keys = {
      ["<Esc>"] = { "close", mode = { "i", "n" } },
      ["<C-c>"] = { "close", mode = { "i", "n" } },
      ["q"] = "close",
    },
  },
  list = {
    keys = {
      ["<Esc>"] = "close",
      ["q"] = "close",
    },
  },
  preview = {
    keys = {
      ["<Esc>"] = "close",
      ["q"] = "close",
    },
  },
},
```

Do not change custom layouts, picker sources, dashboard sections, enabled
Snacks modules, or user keybindings.

- [ ] **Step 6: Run ownership and runtime checks**

Run:

```bash
bash tests/tool-ownership.sh
ya pkg install
yazi --debug
env XDG_STATE_HOME=/tmp/dotfiles-nvim-state XDG_CACHE_HOME=/tmp/dotfiles-nvim-cache nvim --headless '+checkhealth vim.deprecated' +qa
```

Expected: ownership test passes, Yazi reports `violet-hour`, and Neovim reports
no deprecated functions.

- [ ] **Step 7: Commit manifest ownership cleanup**

```bash
git add nvim/lua/alex/plugins/snacks.lua tests/tool-ownership.sh
git add -u topgrade.d
git commit -m "Restore plugin manifest ownership"
```

---

### Task 6: Correct documentation and run public verification

**Files:**
- Create: `tests/documentation.sh`
- Modify: `README.md`
- Modify: `personal/README.md`
- Modify: `docs/themes.md`
- Modify: `chrome-theme/README.md`
- Modify: `raycast/README.md`
- Modify: `zed/themes/README.md`

**Interfaces:**
- Consumes: all implemented commands, current active palette, public/private boundary.
- Produces: the public bootstrap guide and final public verification record.

- [ ] **Step 1: Write the failing documentation test**

```bash
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
! rg -qi 'CONFIG-AUDIT-2026-06|AUDIT-PLUGINS-2026-06|Sunset Pool Splash|glow/violet-hour|charmbracelet/glow' "${docs[@]}"
rg -q 'personal/.*optional' "$ROOT/README.md"
rg -q 'setup\.sh doctor' "$ROOT/README.md"
echo "documentation: OK"
```

- [ ] **Step 2: Run the test and verify stale audit/theme references fail**

Run: `bash tests/documentation.sh`

Expected: FAIL because the README still references deleted audit files and the
old clone URL.

- [ ] **Step 3: Rewrite the public bootstrap sections**

Use this clone command in `README.md`:

```bash
git clone https://github.com/73nko/dotfiles.git ~/.config
bash ~/.config/scripts/setup.sh
```

Document the reproducible boundary, the four setup commands, non-destructive
behavior, `doctor`, the real manual permission/login/import checklist, and the
fact that `personal/` is optional and manually managed. Remove references to
deleted audit files and Glow.

- [ ] **Step 4: Make theme documentation match active files**

Update `docs/themes.md`, `chrome-theme/README.md`, `raycast/README.md`, and
`zed/themes/README.md` to use these active semantic names and values:

```text
night #0D0D2C, indigo #1A1745, branch #2F365A, star #ECE6FF,
orchid #B39DFF, lilac #D6C8FF, rose #E2BCFF, bloom #F0D2FF,
periwinkle #8DA7FF, ice #A8C9FF, coral #FF9E9E, gold #FFCF7A,
green #9EE87F, teal #5FE0C8, azure #7FB0FF
```

Remove active instructions and claims for Sunset Pool Splash and Glow. Explain
that GUI themes require manual import while the checker validates their files.

- [ ] **Step 5: Run the complete public verification suite**

Run:

```bash
for test in tests/*.sh; do bash "$test"; done
bash scripts/check-config.sh
bash scripts/setup.sh doctor
git diff --check
git status --short
```

Expected:

- Every repository test and `check-config.sh` passes.
- `doctor` may report current-machine package drift, but no repository syntax,
  runtime-state, or theme error.
- Only intended implementation files and the pre-existing private/runtime
  working-tree state appear in status.

- [ ] **Step 6: Commit documentation**

```bash
git add README.md personal/README.md docs/themes.md chrome-theme/README.md raycast/README.md zed/themes/README.md tests/documentation.sh
git commit -m "Document reproducible Mac setup"
```
