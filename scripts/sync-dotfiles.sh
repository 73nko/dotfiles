#!/usr/bin/env bash
set -euo pipefail

ROOT=${DOTFILES_ROOT:-"$HOME/.config"}
GIT_BIN=${DOTFILES_GIT_BIN:-git}
SETUP="$ROOT/scripts/setup.sh"

die() {
  printf 'dotfiles sync: %s\n' "$*" >&2
  exit 1
}

is_dirty() {
  local path=$1
  ! "$GIT_BIN" -C "$path" diff --quiet ||
    ! "$GIT_BIN" -C "$path" diff --cached --quiet ||
    [[ -n "$("$GIT_BIN" -C "$path" ls-files --others --exclude-standard)" ]]
}

pull_repo() {
  local path=$1 label=$2
  printf '==> Updating %s\n' "$label"
  "$GIT_BIN" -C "$path" pull --ff-only
}

[[ -x "$SETUP" ]] || die "no encuentro $SETUP"

personal="$ROOT/personal"
personal_repo=false
if [[ -d "$personal/.git" ]] &&
  [[ "$("$GIT_BIN" -C "$personal" rev-parse --show-toplevel)" == "$personal" ]]; then
  personal_repo=true
fi

is_dirty "$ROOT" && die "hay cambios locales en los dotfiles públicos"
if [[ "$personal_repo" == true ]]; then
  is_dirty "$personal" && die "hay cambios locales en la capa personal privada"
fi

pull_repo "$ROOT" "public dotfiles"
if [[ "$personal_repo" == true ]]; then
  pull_repo "$personal" "private personal layer"
fi

exec bash "$SETUP" "$@"
