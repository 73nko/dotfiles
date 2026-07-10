#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

[[ -x "$ROOT/scripts/check-config.sh" ]]
output=$("$ROOT/scripts/check-config.sh")
grep -Fq "config: OK" <<<"$output"

fixture=$(mktemp -d)
trap 'rm -rf "$fixture"' EXIT
mkdir -p "$fixture/bin" "$fixture/fish" "$fixture/scripts" "$fixture/themes"
cp "$ROOT/scripts/check-theme.sh" "$fixture/scripts/check-theme.sh"
printf '#!/usr/bin/env bash\nexit 0\n' >"$fixture/bin/shellcheck"
printf 'set -g fixture true\n' >"$fixture/fish/config.fish"
printf '{"broken": }\n' >"$fixture/invalid.json"
printf 'fixture = true\n' >"$fixture/valid.toml"
printf '{"colors":{},"required":{},"references":{},"legacy":[]}\n' \
  >"$fixture/themes/violet-hour.json"
chmod +x "$fixture/bin/shellcheck" "$fixture/scripts/check-theme.sh"
git -C "$fixture" init -q
git -C "$fixture" add .

if fixture_output=$(PATH="$fixture/bin:$PATH" DOTFILES_ROOT="$fixture" "$ROOT/scripts/check-config.sh" 2>&1); then
  echo "invalid JSON fixture unexpectedly passed" >&2
  exit 1
fi
if ! grep -Fq "$fixture/invalid.json" <<<"$fixture_output" ||
  ! grep -Fq 'parse error:' <<<"$fixture_output"; then
  printf 'invalid JSON diagnostic was not preserved:\n%s\n' "$fixture_output" >&2
  exit 1
fi

printf '{"valid":true}\n' >"$fixture/invalid.json"
git -C "$fixture" add invalid.json
printf 'fixture =\n' >"$fixture/valid.toml"
if fixture_output=$(PATH="$fixture/bin:$PATH" DOTFILES_ROOT="$fixture" "$ROOT/scripts/check-config.sh" 2>&1); then
  echo "invalid TOML fixture unexpectedly passed" >&2
  exit 1
fi
if ! grep -Fq "$fixture/valid.toml" <<<"$fixture_output" ||
  ! grep -Fq 'line 1, column' <<<"$fixture_output"; then
  printf 'invalid TOML diagnostic was not preserved:\n%s\n' "$fixture_output" >&2
  exit 1
fi
printf 'fixture = true\n' >"$fixture/valid.toml"

git -C "$fixture" rm -q --cached invalid.json themes/violet-hour.json
if fixture_output=$(PATH="$fixture/bin:$PATH" DOTFILES_ROOT="$fixture" "$ROOT/scripts/check-config.sh" 2>&1); then
  echo "empty JSON discovery unexpectedly passed" >&2
  exit 1
fi
if ! grep -Fq 'no tracked strict JSON files' <<<"$fixture_output"; then
  printf 'empty JSON discovery diagnostic was not preserved:\n%s\n' "$fixture_output" >&2
  exit 1
fi
git -C "$fixture" add invalid.json themes/violet-hour.json

mv "$fixture/.git" "$fixture/.git.hidden"
if fixture_output=$(PATH="$fixture/bin:$PATH" DOTFILES_ROOT="$fixture" "$ROOT/scripts/check-config.sh" 2>&1); then
  mv "$fixture/.git.hidden" "$fixture/.git"
  echo "broken Git discovery unexpectedly passed" >&2
  exit 1
fi
mv "$fixture/.git.hidden" "$fixture/.git"
if ! grep -Fq 'not a git repository' <<<"$fixture_output"; then
  printf 'Git discovery diagnostic was not preserved:\n%s\n' "$fixture_output" >&2
  exit 1
fi

doctor_fixture=$(mktemp -d)
trap 'rm -rf "$fixture" "$doctor_fixture"' EXIT
mkdir -p "$doctor_fixture/bin" "$doctor_fixture/cache" "$doctor_fixture/data" "$doctor_fixture/state"
# shellcheck disable=SC2016
printf '#!/usr/bin/env bash\nprintf invoked >"$DOCTOR_GIT_MARKER"\nexit 1\n' \
  >"$doctor_fixture/bin/git"
chmod +x "$doctor_fixture/bin/git"
command -v nvim >/dev/null 2>&1 || { echo "nvim is required for config integration" >&2; exit 1; }
if doctor_output=$(
  DOTFILES_DOCTOR=1 \
    DOCTOR_GIT_MARKER="$doctor_fixture/git-invoked" \
    PATH="$doctor_fixture/bin:$PATH" \
    XDG_CACHE_HOME="$doctor_fixture/cache" \
    XDG_DATA_HOME="$doctor_fixture/data" \
    XDG_STATE_HOME="$doctor_fixture/state" \
    nvim --headless -u "$ROOT/nvim/init.lua" -i NONE +qa 2>&1
); then
  echo "doctor mode unexpectedly started without lazy.nvim" >&2
  exit 1
fi
if ! grep -Fq 'lazy.nvim is missing; doctor mode will not install it' <<<"$doctor_output"; then
  printf 'unexpected doctor-mode failure:\n%s\n' "$doctor_output" >&2
  exit 1
fi
if [[ -e "$doctor_fixture/git-invoked" ]]; then
  echo "doctor mode attempted Lazy bootstrap" >&2
  exit 1
fi
[[ ! -e "$doctor_fixture/data/nvim/lazy/lazy.nvim" ]]

mason_command=$(
  sed -n '/^check_mason_packages()/,/^}/p' "$ROOT/scripts/setup.sh" |
    sed -n "s/^[[:space:]]*'\\(.*\\)'[[:space:]]*\\\\$/\\1/p"
)
[[ -n "$mason_command" ]] || { echo "Mason doctor command is missing" >&2; exit 1; }
registry_stub='+lua package.preload["mason-registry"]=function() return {is_installed=function(package) return package ~= "prettier" end} end'
if mason_output=$(
  XDG_CACHE_HOME="$doctor_fixture/cache" \
    XDG_DATA_HOME="$doctor_fixture/data" \
    XDG_STATE_HOME="$doctor_fixture/state" \
    nvim --headless -u NONE -i NONE --cmd "$registry_stub" "$mason_command" +qa 2>&1
); then
  printf 'missing Mason package false-passed (exit 0):\n%s\n' "$mason_output" >&2
  exit 1
fi
if ! grep -Fq 'missing Mason packages: prettier' <<<"$mason_output"; then
  printf 'missing Mason diagnostic did not name prettier:\n%s\n' "$mason_output" >&2
  exit 1
fi

rg -q 'DOTFILES_DOCTOR=1' "$ROOT/scripts/setup.sh"
rg -q -- '-i NONE' "$ROOT/scripts/setup.sh"
if ! grep -Fq "run_nvim_doctor '+checkhealth vim.deprecated' '+qa!'" "$ROOT/scripts/setup.sh"; then
  echo "Neovim health check does not force a headless exit" >&2
  exit 1
fi
if ! rg -q 'vim.env.DOTFILES_DOCTOR ~= "1"' "$ROOT/nvim/lua/alex/plugins/treesitter.lua"; then
  echo "Treesitter doctor install gate missing" >&2
  exit 1
fi
if ! rg -q 'vim.env.DOTFILES_DOCTOR ~= "1"' "$ROOT/nvim/lua/alex/plugins/lsp/mason.lua"; then
  echo "Mason doctor install gate missing" >&2
  exit 1
fi

if rg -q '^legacy_cleanup\(\)' "$ROOT/scripts/setup.sh"; then
  echo "destructive legacy cleanup remains" >&2
  exit 1
fi

rg -q 'check-config\.sh' "$ROOT/scripts/setup.sh"
rg -q 'HOMEBREW_NO_AUTO_UPDATE=1' "$ROOT/scripts/setup.sh"
echo "config integration: OK"
