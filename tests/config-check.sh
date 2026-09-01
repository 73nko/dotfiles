#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
export GIT_CONFIG_GLOBAL=/dev/null
runtime_fixture=
fixture=
yaml_tmp=
doctor_fixture=

cleanup() {
  local path
  for path in "$runtime_fixture" "$fixture" "$yaml_tmp" "$doctor_fixture"; do
    [[ -n "$path" ]] && rm -rf "$path"
  done
}
trap cleanup EXIT

[[ -x "$ROOT/scripts/check-config.sh" ]]
output=$("$ROOT/scripts/check-config.sh")
grep -Fq "config: OK" <<<"$output"

declared_python=$(MISE_CONFIG_FILE="$ROOT/mise/config.toml" mise which python)
runtime_fixture=$(mktemp -d)
mkdir -p "$runtime_fixture/bin"
printf '#!/usr/bin/env bash\nprintf "stock python3 must not run\\n" >&2\nexit 86\n' \
  >"$runtime_fixture/bin/python3"
# shellcheck disable=SC2016
printf '#!/usr/bin/env bash\n[[ "$1" == exec && "$2" == -- && "$3" == python3 ]] || exit 87\nshift 3\nexec "$DECLARED_PYTHON" "$@"\n' \
  >"$runtime_fixture/bin/mise"
chmod +x "$runtime_fixture/bin/mise" "$runtime_fixture/bin/python3"
if ! runtime_output=$(
  DECLARED_PYTHON="$declared_python" \
    PATH="$runtime_fixture/bin:$PATH" \
    "$ROOT/scripts/check-config.sh" 2>&1
); then
  printf 'repo TOML check did not use mise Python:\n%s\n' "$runtime_output" >&2
  exit 1
fi

fixture=$(mktemp -d)
mkdir -p "$fixture/bin" "$fixture/fish" "$fixture/scripts" "$fixture/themes"
cp "$ROOT/scripts/check-theme.sh" "$fixture/scripts/check-theme.sh"
printf '#!/usr/bin/env bash\nexit 0\n' >"$fixture/bin/shellcheck"
printf 'set -g fixture true\n' >"$fixture/fish/config.fish"
printf '{"broken": }\n' >"$fixture/invalid.json"
printf 'fixture = true\n' >"$fixture/valid.toml"
printf 'fixture: true\n' >"$fixture/valid.yml"
printf '{"colors":{},"required":{},"references":{},"legacy":[]}\n' \
  >"$fixture/themes/glacier-signal.json"
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

printf 'fixture: [\n' >"$fixture/valid.yml"
git -C "$fixture" add valid.yml
yaml_tmp=$(mktemp -d)
if fixture_output=$(
  TMPDIR="$yaml_tmp" PATH="$fixture/bin:$PATH" DOTFILES_ROOT="$fixture" \
    "$ROOT/scripts/check-config.sh" 2>&1
); then
  echo "invalid YAML fixture unexpectedly passed" >&2
  exit 1
fi
if ! grep -Fq "$fixture/valid.yml" <<<"$fixture_output" ||
  ! grep -Fq 'invalid yaml' <<<"$fixture_output"; then
  printf 'invalid YAML diagnostic was not preserved:\n%s\n' "$fixture_output" >&2
  exit 1
fi
if remaining=$(find "$yaml_tmp" -maxdepth 1 -name 'dotfiles-yaml.*' -print -quit) && [[ -n "$remaining" ]]; then
  printf 'YAML parser temporary state was not cleaned: %s\n' "$remaining" >&2
  exit 1
fi
rm -rf "$yaml_tmp"
yaml_tmp=

printf 'fixture: true\n---\nbroken: [\n' >"$fixture/valid.yml"
git -C "$fixture" add valid.yml
if fixture_output=$(PATH="$fixture/bin:$PATH" DOTFILES_ROOT="$fixture" "$ROOT/scripts/check-config.sh" 2>&1); then
  echo "multiple YAML documents unexpectedly passed" >&2
  exit 1
fi
if ! grep -Fq "$fixture/valid.yml" <<<"$fixture_output" ||
  ! grep -Fq 'single mapping is required' <<<"$fixture_output"; then
  printf 'multiple YAML document diagnostic was not actionable:\n%s\n' "$fixture_output" >&2
  exit 1
fi

printf 'fixture: true\n...\nbroken: [\n' >"$fixture/valid.yml"
git -C "$fixture" add valid.yml
if fixture_output=$(PATH="$fixture/bin:$PATH" DOTFILES_ROOT="$fixture" "$ROOT/scripts/check-config.sh" 2>&1); then
  echo "YAML document terminator unexpectedly passed" >&2
  exit 1
fi
if ! grep -Fq "$fixture/valid.yml" <<<"$fixture_output" ||
  ! grep -Fq 'single mapping is required' <<<"$fixture_output"; then
  printf 'YAML document terminator diagnostic was not actionable:\n%s\n' "$fixture_output" >&2
  exit 1
fi

printf '%s\n' '- fixture' >"$fixture/valid.yml"
git -C "$fixture" add valid.yml
if fixture_output=$(PATH="$fixture/bin:$PATH" DOTFILES_ROOT="$fixture" "$ROOT/scripts/check-config.sh" 2>&1); then
  echo "non-mapping YAML fixture unexpectedly passed" >&2
  exit 1
fi
if ! grep -Fq "$fixture/valid.yml" <<<"$fixture_output" ||
  ! grep -Fq 'single mapping is required' <<<"$fixture_output" ||
  ! grep -Fq 'invalid format' <<<"$fixture_output"; then
  printf 'non-mapping YAML diagnostic was not actionable:\n%s\n' "$fixture_output" >&2
  exit 1
fi

: >"$fixture/valid.yml"
git -C "$fixture" add valid.yml
if fixture_output=$(PATH="$fixture/bin:$PATH" DOTFILES_ROOT="$fixture" "$ROOT/scripts/check-config.sh" 2>&1); then
  echo "empty YAML fixture unexpectedly passed" >&2
  exit 1
fi
if ! grep -Fq "$fixture/valid.yml" <<<"$fixture_output" ||
  ! grep -Fq 'YAML config is empty' <<<"$fixture_output"; then
  printf 'empty YAML diagnostic was not actionable:\n%s\n' "$fixture_output" >&2
  exit 1
fi

printf '# comment only\n  # still a comment\n' >"$fixture/valid.yml"
git -C "$fixture" add valid.yml
if fixture_output=$(PATH="$fixture/bin:$PATH" DOTFILES_ROOT="$fixture" "$ROOT/scripts/check-config.sh" 2>&1); then
  echo "comments-only YAML fixture unexpectedly passed" >&2
  exit 1
fi
if ! grep -Fq 'YAML config is empty' <<<"$fixture_output"; then
  printf 'comments-only YAML diagnostic was not actionable:\n%s\n' "$fixture_output" >&2
  exit 1
fi

printf '{}\n' >"$fixture/valid.yml"
git -C "$fixture" add valid.yml
if fixture_output=$(PATH="$fixture/bin:$PATH" DOTFILES_ROOT="$fixture" "$ROOT/scripts/check-config.sh" 2>&1); then
  echo "empty YAML mapping unexpectedly passed" >&2
  exit 1
fi
if ! grep -Fq 'YAML config is empty' <<<"$fixture_output"; then
  printf 'empty YAML mapping diagnostic was not actionable:\n%s\n' "$fixture_output" >&2
  exit 1
fi

for empty_mapping in '{ }' $'{ # comment\n}'; do
  printf '%s\n' "$empty_mapping" >"$fixture/valid.yml"
  git -C "$fixture" add valid.yml
  if fixture_output=$(PATH="$fixture/bin:$PATH" DOTFILES_ROOT="$fixture" "$ROOT/scripts/check-config.sh" 2>&1); then
    echo "alternate empty YAML mapping unexpectedly passed" >&2
    exit 1
  fi
  if ! grep -Fq 'YAML config is empty' <<<"$fixture_output"; then
    printf 'alternate empty YAML mapping diagnostic was not actionable:\n%s\n' "$fixture_output" >&2
    exit 1
  fi
done

printf 'message: |\n  ---\n  ...\n  {}\n' >"$fixture/valid.yml"
git -C "$fixture" add valid.yml
if ! fixture_output=$(PATH="$fixture/bin:$PATH" DOTFILES_ROOT="$fixture" "$ROOT/scripts/check-config.sh" 2>&1); then
  printf 'valid YAML block scalar unexpectedly failed:\n%s\n' "$fixture_output" >&2
  exit 1
fi
printf 'fixture: true\n' >"$fixture/valid.yml"

git -C "$fixture" rm -q --cached invalid.json themes/glacier-signal.json
mv "$fixture/invalid.json" "$fixture/invalid.json.hidden"
mv "$fixture/themes/glacier-signal.json" "$fixture/themes/glacier-signal.json.hidden"
if fixture_output=$(PATH="$fixture/bin:$PATH" DOTFILES_ROOT="$fixture" "$ROOT/scripts/check-config.sh" 2>&1); then
  echo "empty JSON discovery unexpectedly passed" >&2
  exit 1
fi
if ! grep -Fq 'no tracked strict JSON files' <<<"$fixture_output"; then
  printf 'empty JSON discovery diagnostic was not preserved:\n%s\n' "$fixture_output" >&2
  exit 1
fi
mv "$fixture/invalid.json.hidden" "$fixture/invalid.json"
mv "$fixture/themes/glacier-signal.json.hidden" "$fixture/themes/glacier-signal.json"
git -C "$fixture" add invalid.json themes/glacier-signal.json

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

health_runtime="set runtimepath^=$ROOT/nvim"
warning_report='+lua vim.api.nvim_buf_set_lines(0, 0, -1, false, {"health report", "- WARNING injected deprecation"})'
if warning_output=$(
  XDG_CACHE_HOME="$doctor_fixture/cache" \
    XDG_STATE_HOME="$doctor_fixture/state" \
    nvim --headless -u NONE -i NONE --cmd "$health_runtime" \
    "$warning_report" '+lua require("alex.doctor").assert_health()' '+qa!' 2>&1
); then
  echo "injected Neovim health warning unexpectedly passed" >&2
  exit 1
fi
if ! grep -Fq 'WARNING injected deprecation' <<<"$warning_output"; then
  printf 'Neovim health failure did not print the warning report:\n%s\n' "$warning_output" >&2
  exit 1
fi
error_report='+lua vim.api.nvim_buf_set_lines(0, 0, -1, false, {"health report", "- ERROR injected deprecation"})'
if error_output=$(
  XDG_CACHE_HOME="$doctor_fixture/cache" \
    XDG_STATE_HOME="$doctor_fixture/state" \
    nvim --headless -u NONE -i NONE --cmd "$health_runtime" \
    "$error_report" '+lua require("alex.doctor").assert_health()' '+qa!' 2>&1
); then
  echo "injected Neovim health error unexpectedly passed" >&2
  exit 1
fi
if ! grep -Fq 'ERROR injected deprecation' <<<"$error_output"; then
  printf 'Neovim health failure did not print the error report:\n%s\n' "$error_output" >&2
  exit 1
fi
ok_report='+lua vim.api.nvim_buf_set_lines(0, 0, -1, false, {"health report", "- OK no deprecated functions"})'
if ! ok_output=$(
  XDG_CACHE_HOME="$doctor_fixture/cache" \
    XDG_STATE_HOME="$doctor_fixture/state" \
    nvim --headless -u NONE -i NONE --cmd "$health_runtime" \
    "$ok_report" '+lua require("alex.doctor").assert_health()' '+qa!' 2>&1
); then
  printf 'clean Neovim health report unexpectedly failed:\n%s\n' "$ok_output" >&2
  exit 1
fi

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

check_nvim_source="$doctor_fixture/check-nvim-config.sh"
sed -n '/^check_nvim_config()/,/^}/p' "$ROOT/scripts/setup.sh" >"$check_nvim_source"
run_nvim_doctor() {
  printf '%s\n' "$@"
}
# shellcheck source=/dev/null
source "$check_nvim_source"
nvim_doctor_args=$(check_nvim_config)
expected_nvim_doctor_args=$(printf '%s\n' \
  '+checkhealth vim.deprecated' \
  '+lua require("alex.doctor").assert_health()' \
  '+qa!')
if [[ "$nvim_doctor_args" != "$expected_nvim_doctor_args" ]]; then
  printf 'unexpected Neovim doctor argv:\n%s\n' "$nvim_doctor_args" >&2
  exit 1
fi

rg -q 'DOTFILES_DOCTOR=1' "$ROOT/scripts/setup.sh"
rg -q -- '-i NONE' "$ROOT/scripts/setup.sh"
if ! grep -Fq "'+lua require(\"alex.doctor\").assert_health()'" "$ROOT/scripts/setup.sh"; then
  echo "Neovim health check does not assert the health report" >&2
  exit 1
fi
if ! grep -Fq "'+qa!'" "$ROOT/scripts/setup.sh"; then
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
