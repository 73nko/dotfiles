#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
fixture=$(mktemp -d)
trap 'rm -rf "$fixture"' EXIT

mkdir -p "$fixture/bin" "$fixture/home/.config/wallpapers"
: >"$fixture/home/.config/wallpapers/glacier-signal-ultrawide-5120x1440.jpg"

apply_patch_stub() {
  local name=$1 body=$2
  printf '#!/usr/bin/env bash\n%s\n' "$body" >"$fixture/bin/$name"
  chmod +x "$fixture/bin/$name"
}

apply_patch_stub system_profiler 'printf "Resolution: 5120 x 1440\n"'
apply_patch_stub defaults "printf 'defaults %s\\n' \"\$*\" >>\"\$CALL_LOG\""
apply_patch_stub osascript "printf 'osascript %s\\n' \"\$*\" >>\"\$CALL_LOG\""

CALL_LOG="$fixture/calls" \
  HOME="$fixture/home" \
  PATH="$fixture/bin:/usr/bin:/bin" \
  bash "$ROOT/scripts/macos-glacier-signal.sh" >/dev/null

rg -Fq 'defaults write NSGlobalDomain AppleAccentColor -int 4' "$fixture/calls"
rg -Fq 'glacier-signal-ultrawide-5120x1440.jpg' "$fixture/calls"

if rg -qi 'universalaccess|cursor|killall|AppleHighlightColor' "$fixture/calls"; then
  echo "macOS visual layer invoked an unsafe or unowned preference" >&2
  exit 1
fi

echo "macOS visual safety: OK"
