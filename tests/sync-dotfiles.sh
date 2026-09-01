#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/bin" "$TMP/dotfiles/scripts" "$TMP/dotfiles/personal/.git"

cat >"$TMP/bin/git" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >>"$SYNC_GIT_LOG"

if [[ "$*" == *"diff --quiet"* || "$*" == *"diff --cached --quiet"* ]]; then
  [[ ${SYNC_DIRTY:-0} != 1 && ${SYNC_DIRTY_PATH:-} != "$2" ]]
  exit
fi
if [[ "$*" == *"ls-files --others --exclude-standard"* ]]; then
  if [[ ${SYNC_DIRTY:-0} == 1 || ${SYNC_DIRTY_PATH:-} == "$2" ]]; then
    printf 'local-change\n'
  fi
  exit
fi
if [[ "$*" == *"rev-parse --show-toplevel"* ]]; then
  printf '%s\n' "$SYNC_PERSONAL_ROOT"
fi
SH

cat >"$TMP/dotfiles/scripts/setup.sh" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >"$SYNC_SETUP_LOG"
SH

chmod +x "$TMP/bin/git" "$TMP/dotfiles/scripts/setup.sh"

export DOTFILES_ROOT="$TMP/dotfiles"
export DOTFILES_GIT_BIN="$TMP/bin/git"
export SYNC_GIT_LOG="$TMP/git.log"
export SYNC_SETUP_LOG="$TMP/setup.log"
export SYNC_PERSONAL_ROOT="$TMP/dotfiles/personal"

"$ROOT/scripts/sync-dotfiles.sh" --upgrade
grep -Fqx -- "-C $TMP/dotfiles pull --ff-only" "$SYNC_GIT_LOG"
grep -Fqx -- "-C $TMP/dotfiles/personal pull --ff-only" "$SYNC_GIT_LOG"
grep -Fqx -- '--upgrade' "$SYNC_SETUP_LOG"

: >"$SYNC_GIT_LOG"
: >"$SYNC_SETUP_LOG"
if SYNC_DIRTY=1 "$ROOT/scripts/sync-dotfiles.sh" >/dev/null 2>&1; then
  echo "dirty dotfiles sync unexpectedly passed" >&2
  exit 1
fi
if rg -q 'pull --ff-only' "$SYNC_GIT_LOG" || [[ -s "$SYNC_SETUP_LOG" ]]; then
  echo "dirty dotfiles sync changed state" >&2
  exit 1
fi

: >"$SYNC_GIT_LOG"
: >"$SYNC_SETUP_LOG"
if SYNC_DIRTY_PATH="$TMP/dotfiles/personal" "$ROOT/scripts/sync-dotfiles.sh" >/dev/null 2>&1; then
  echo "dirty personal sync unexpectedly passed" >&2
  exit 1
fi
if rg -q -- "-C $TMP/dotfiles/personal pull --ff-only" "$SYNC_GIT_LOG" ||
  [[ -s "$SYNC_SETUP_LOG" ]]; then
  echo "dirty personal sync changed private state or ran setup" >&2
  exit 1
fi

echo "dotfiles sync: OK"
