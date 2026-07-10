# Private Awt Workflow Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the manually copied private `awt` folder run Awtomic services on the Desktop and safely dispatch the same commands from a laptop.

**Architecture:** Keep the private Bash CLI and generated configuration beside each other under `personal/awtomic`. Detect the server by hostname, construct SSH options without editing global SSH configuration, isolate service lifecycle in tmux windows, and expose environment overrides only for deterministic private tests.

**Tech Stack:** macOS Bash 3.2, OpenSSH, tmux 3.5+, Tailscale, plain Bash test harnesses.

## Global Constraints

- Do not stage or commit `personal/awtomic`, its tests, generated `awt.conf`, or private Fish configuration.
- Do not add any `awt` dependency or reference to public setup.
- The entire optional layer must work after manually copying `personal/` to the laptop.
- Keep commands `awt`, `up`, `down`, `restart`, `status`, `logs`, and `svc`.
- Add explicit `setup server`, `setup client`, and `doctor` commands.
- Support macOS Bash 3.2; do not use associative arrays or Bash 4-only features.
- Serialize configuration and remote arguments without `eval` or unquoted `$*`.

## Execution Order

Execute `2026-07-10-public-dotfiles-convergence.md` first. It establishes the
generic personal loaders, XDG path, and ShellCheck ownership that this private
plan relies on. Private files remain ignored throughout both plans.

---

### Task 1: Normalize paths and make remote dispatch safe

**Files:**
- Create: `personal/awtomic/tests/dispatch-test.sh`
- Modify: `personal/awtomic/awt`

**Interfaces:**
- Consumes: `AWT_CONF`, `AWT_HOSTNAME`, `AWT_SSH_BIN`, and generated `awt.conf`.
- Produces: `load_config()`, `on_server()`, `remote_command()`, and `dispatch_remote()`.

- [ ] **Step 1: Write the failing dispatch test**

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/bin"

cat >"$TMP/awt.conf" <<'CONF'
SERVER_HOSTNAME=desktop
SERVER_USER=alex
SERVER_NET_NAME=desktop.tailnet
FORWARD_PORTS="8081 8082 8083 3000 6081"
AWTOMIC_DIR=/tmp/awtomic
DEFAULT_UP="api web"
DYNAMO_DIR=/tmp/dynamo
DYNAMO_CMD="java -jar DynamoDBLocal.jar"
SMOOTHMQ_CMD="go run . server"
WEB_PORT=8081
NGROK_CMD="ngrok http 8081"
CONF

cat >"$TMP/bin/ssh" <<'SH'
#!/usr/bin/env bash
printf '%s\n' "$@" >"$AWT_SSH_LOG"
SH
chmod +x "$TMP/bin/ssh"

AWT_CONF="$TMP/awt.conf" \
AWT_HOSTNAME=laptop \
AWT_SSH_BIN="$TMP/bin/ssh" \
AWT_SSH_LOG="$TMP/ssh.log" \
  "$ROOT/awt" logs "web service" 25

grep -Fqx 'alex@desktop.tailnet' "$TMP/ssh.log"
grep -Fq '"$HOME/.config/personal/awtomic/awt" logs web\\ service 25' "$TMP/ssh.log"
grep -Fqx 'ExitOnForwardFailure=yes' "$TMP/ssh.log"
echo "awt dispatch: OK"
```

- [ ] **Step 2: Run the test and verify current path/argument handling fails**

Run: `bash personal/awtomic/tests/dispatch-test.sh`

Expected: FAIL because the current script reads `~/.config/awtomic/awt.conf`
and forwards unquoted `$*`.

- [ ] **Step 3: Add self-relative configuration and injectable command paths**

At the top of `awt`, replace path constants with:

```bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
CONF=${AWT_CONF:-"$SCRIPT_DIR/awt.conf"}
SSH_BIN=${AWT_SSH_BIN:-ssh}
TMUX_BIN=${AWT_TMUX_BIN:-tmux}
CURRENT_HOSTNAME=${AWT_HOSTNAME:-"$(hostname -s)"}
REMOTE_AWT='"$HOME/.config/personal/awtomic/awt"'
SESSION_WORK=main
SESSION_SVC=awtomic-svc
```

Add configuration loading and server detection:

```bash
load_config() {
  [[ -f "$CONF" ]] || die "missing $CONF; run: awt setup server"
  # shellcheck source=/dev/null
  source "$CONF"
}

on_server() {
  [[ "$CURRENT_HOSTNAME" == "$SERVER_HOSTNAME" ]]
}
```

- [ ] **Step 4: Add safe remote command construction**

```bash
remote_command() {
  local command=$REMOTE_AWT arg quoted
  for arg in "$@"; do
    printf -v quoted '%q' "$arg"
    command="$command $quoted"
  done
  printf '%s\n' "$command"
}

dispatch_remote() {
  local command port
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  local ssh_args=(
    -t
    -o ControlMaster=auto
    -o ControlPath="$HOME/.ssh/awt-%C"
    -o ControlPersist=8h
    -o ServerAliveInterval=30
    -o ServerAliveCountMax=4
    -o ExitOnForwardFailure=yes
  )

  for port in $FORWARD_PORTS; do
    ssh_args+=( -L "$port:127.0.0.1:$port" )
  done

  command=$(remote_command "$@")
  exec "$SSH_BIN" "${ssh_args[@]}" "$SERVER_USER@$SERVER_NET_NAME" "$command"
}
```

Load configuration before role dispatch and call
`dispatch_remote "$sub" "$@"` when `on_server` is false.

- [ ] **Step 5: Move top-level dispatch into a source-safe `main()`**

Keep helper and service functions above this entry point, then place this at the
bottom of `awt`:

```bash
main() {
  local sub=${1:-attach}
  shift || true

  case "$sub" in
    setup) cmd_setup "$@"; return ;;
    help|-h|--help) show_help; return ;;
    doctor) cmd_doctor; return ;;
  esac

  load_config
  if ! on_server; then
    dispatch_remote "$sub" "$@"
  fi

  case "$sub" in
    attach) exec "$TMUX_BIN" new-session -A -s "$SESSION_WORK" ;;
    svc) ensure_session; exec "$TMUX_BIN" attach -t "$SESSION_SVC" ;;
    up) cmd_up "$@" ;;
    down) cmd_down "$@" ;;
    restart) cmd_restart "$@" ;;
    status|st) cmd_status ;;
    logs) [[ $# -ge 1 ]] || die "logs <service> [lines]"; cmd_logs "$@" ;;
    *) die "unknown command: $sub (awt help)" ;;
  esac
}

if [[ ${AWT_SOURCE_ONLY:-0} != 1 ]]; then
  main "$@"
fi
```

Define the extracted command helpers exactly as follows:

```bash
show_help() {
  cat <<'EOF'
awt setup server      configure this Desktop as the server
awt setup client      verify this laptop as a client
awt doctor            verify local role, config, SSH, and dependencies
awt                   attach to the Desktop work session
awt svc               attach to the Desktop service session
awt up [service...]   start defaults or named services
awt down [service...] stop all or named services
awt restart <service...>
awt status            show service state
awt logs <service> [lines]

Services: dynamo smoothmq pg data api web widget sqs stream ngrok
EOF
}

cmd_up() {
  if [[ $# -eq 0 ]]; then
    # DEFAULT_UP is a trusted, generated whitespace-separated service list.
    set -- $DEFAULT_UP
  fi
  local service
  for service in "$@"; do svc_up "$service"; done
}

cmd_down() {
  local service
  if [[ $# -eq 0 ]]; then
    while IFS= read -r service; do
      win_exists "$service" && svc_down "$service"
    done < <(service_names)
    return 0
  fi
  for service in "$@"; do svc_down "$service"; done
}

cmd_restart() {
  [[ $# -ge 1 ]] || die "restart requires at least one service"
  local service
  for service in "$@"; do svc_restart "$service"; done
}
```

- [ ] **Step 6: Run the dispatch test**

Run: `bash personal/awtomic/tests/dispatch-test.sh`

Expected: `awt dispatch: OK`.

---

### Task 2: Make server/client setup explicit and add private doctor checks

**Files:**
- Create: `personal/awtomic/tests/setup-test.sh`
- Modify: `personal/awtomic/awt`

**Interfaces:**
- Consumes: `write_assignment(KEY, VALUE)`, interactive `ask()`/`confirm()`, SSH command construction from Task 1.
- Produces: `setup_server()`, `setup_client()`, `cmd_setup()`, and `cmd_doctor()`.

- [ ] **Step 1: Write the failing serialization/setup test**

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

export AWT_SOURCE_ONLY=1
export AWT_CONF="$TMP/awt.conf"
source "$ROOT/awt"

value='ngrok http --domain=dev.example "8081"'
serialized=$(write_assignment NGROK_CMD "$value")
printf '%s\n' "$serialized" >"$TMP/value.conf"
unset NGROK_CMD
source "$TMP/value.conf"
[[ "$NGROK_CMD" == "$value" ]]

if cmd_setup invalid >/dev/null 2>&1; then
  echo "invalid setup role unexpectedly passed" >&2
  exit 1
fi

echo "awt setup: OK"
```

- [ ] **Step 2: Run the test and verify `write_assignment` is undefined**

Run: `bash personal/awtomic/tests/setup-test.sh`

Expected: FAIL with `write_assignment: command not found`.

- [ ] **Step 3: Add safe, atomic configuration writing**

```bash
write_assignment() {
  local key=$1 value=$2 quoted
  printf -v quoted '%q' "$value"
  printf '%s=%s\n' "$key" "$quoted"
}

write_server_config() {
  local temp="$CONF.tmp"
  {
    printf '# Generated by awt setup server on %s\n' "$(date +%F)"
    write_assignment SERVER_HOSTNAME "$SERVER_HOSTNAME"
    write_assignment SERVER_USER "$SERVER_USER"
    write_assignment SERVER_NET_NAME "$SERVER_NET_NAME"
    write_assignment FORWARD_PORTS "$FORWARD_PORTS"
    write_assignment AWTOMIC_DIR "$AWTOMIC_DIR"
    write_assignment DYNAMO_DIR "$DYNAMO_DIR"
    write_assignment DYNAMO_CMD "$DYNAMO_CMD"
    write_assignment SMOOTHMQ_CMD "$SMOOTHMQ_CMD"
    write_assignment WEB_PORT "$WEB_PORT"
    write_assignment NGROK_CMD "$NGROK_CMD"
    write_assignment DEFAULT_UP "$DEFAULT_UP"
  } >"$temp"
  mv "$temp" "$CONF"
}
```

- [ ] **Step 4: Implement complete server setup and explicit setup roles**

Implement server setup with current-value detection and safe serialization:

```bash
setup_server() {
  local default_net default_jar quoted_jar quoted_lib ngrok_domain

  SERVER_HOSTNAME=$(hostname -s)
  SERVER_USER=$(whoami)
  default_net=$(tailscale status --json 2>/dev/null | jq -r '.Self.DNSName // empty' | sed 's/\.$//' || true)
  SERVER_NET_NAME=$(ask "Desktop network name" "${default_net:-$SERVER_HOSTNAME.local}")
  AWTOMIC_DIR=$(ask "Awtomic repositories directory" "$HOME/awtomic")

  default_jar=$(mdfind -name DynamoDBLocal.jar 2>/dev/null | head -1 || true)
  if [[ -z "$default_jar" ]]; then
    default_jar=$(find "$HOME" -maxdepth 4 -name DynamoDBLocal.jar 2>/dev/null | head -1 || true)
  fi
  default_jar=$(ask "DynamoDBLocal.jar path" "$default_jar")
  [[ -f "$default_jar" ]] || die "DynamoDBLocal.jar not found: $default_jar"
  DYNAMO_DIR=$(dirname "$default_jar")
  printf -v quoted_jar '%q' "$default_jar"
  printf -v quoted_lib '%q' "$DYNAMO_DIR/DynamoDBLocal_lib"
  DYNAMO_CMD="java -Djava.library.path=$quoted_lib -jar $quoted_jar -sharedDb"

  SMOOTHMQ_CMD=$(ask "SmoothMQ command" "go run . server")
  WEB_PORT=$(ask "bundle-shopify web port" "8081")
  ngrok_domain=$(sed -n 's|^SHOPIFY_APP_PUBLIC_URL=https\{0,1\}://||p' "$AWTOMIC_DIR/bundle-shopify/.env" 2>/dev/null | head -1 || true)
  ngrok_domain=$(ask "ngrok domain" "$ngrok_domain")
  NGROK_CMD="ngrok http --domain=$ngrok_domain $WEB_PORT"
  FORWARD_PORTS=$(ask "Forwarded ports" "$WEB_PORT 8082 8083 3000 6081")
  DEFAULT_UP=$(ask "Default services" "dynamo smoothmq pg data api web ngrok")

  mkdir -p "$(dirname "$CONF")"
  write_server_config
  echo "server config saved: $CONF"
}
```

Implement client verification without modifying SSH config:

```bash
setup_client() {
  load_config
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  echo "Checking $SERVER_USER@$SERVER_NET_NAME..."
  if "$SSH_BIN" -o BatchMode=yes -o ConnectTimeout=5 "$SERVER_USER@$SERVER_NET_NAME" true; then
    if "$SSH_BIN" -o BatchMode=yes "$SERVER_USER@$SERVER_NET_NAME" \
      'test -x "$HOME/.config/personal/awtomic/awt"'; then
      echo "client connection: OK"
      return 0
    fi
    echo "remote awt executable is missing" >&2
    return 1
  fi
  echo "SSH key authentication failed." >&2
  echo "Enable Remote Login on the Desktop, then run:" >&2
  echo "  ssh-copy-id $SERVER_USER@$SERVER_NET_NAME" >&2
  return 1
}

cmd_setup() {
  local role=${1:-}
  if [[ -z "$role" ]]; then
    if confirm "Configure this Mac as the Desktop server?"; then role=server; else role=client; fi
  fi
  case "$role" in
    server) setup_server ;;
    client) setup_client ;;
    *) die "setup role must be server or client" ;;
  esac
}
```

- [ ] **Step 5: Add `awt doctor`**

```bash
cmd_doctor() {
  local errors=0 command path port seen=' '
  load_config

  for command in ssh tmux; do
    command -v "$command" >/dev/null 2>&1 || {
      echo "missing command: $command" >&2
      errors=$((errors + 1))
    }
  done

  for port in $FORWARD_PORTS; do
    case "$port" in
      ''|*[!0-9]*)
        echo "invalid forward port: $port" >&2
        errors=$((errors + 1))
        continue
        ;;
    esac
    if [[ "$seen" == *" $port "* ]]; then
      echo "duplicate forward port: $port" >&2
      errors=$((errors + 1))
    fi
    seen="$seen$port "
  done

  if on_server; then
    for path in "$AWTOMIC_DIR" "$DYNAMO_DIR"; do
      [[ -d "$path" ]] || {
        echo "missing directory: $path" >&2
        errors=$((errors + 1))
      }
    done
  else
    "$SSH_BIN" -o BatchMode=yes -o ConnectTimeout=5 "$SERVER_USER@$SERVER_NET_NAME" true >/dev/null 2>&1 || {
      echo "server SSH unavailable" >&2
      errors=$((errors + 1))
    }
    "$SSH_BIN" -o BatchMode=yes "$SERVER_USER@$SERVER_NET_NAME" \
      'test -x "$HOME/.config/personal/awtomic/awt"' >/dev/null 2>&1 || {
      echo "remote awt executable missing" >&2
      errors=$((errors + 1))
    }
  fi

  [[ $errors -eq 0 ]] || return 1
  echo "awt doctor: OK"
}
```

Add `doctor` to the `show_help()` output. The `main()` dispatch from Task 1
already routes the command to `cmd_doctor`.

- [ ] **Step 6: Run setup tests and syntax analysis**

Run:

```bash
bash personal/awtomic/tests/setup-test.sh
bash personal/awtomic/tests/dispatch-test.sh
bash -n personal/awtomic/awt personal/awtomic/tests/*.sh
SHELLCHECK=$(command -v shellcheck 2>/dev/null || printf '%s' "$HOME/.local/share/nvim/mason/bin/shellcheck")
"$SHELLCHECK" personal/awtomic/awt personal/awtomic/tests/*.sh
```

Expected: both tests print `OK`; syntax and ShellCheck return zero.

---

### Task 3: Make tmux service lifecycle safe and testable

**Files:**
- Create: `personal/awtomic/tests/services-test.sh`
- Modify: `personal/awtomic/awt`

**Interfaces:**
- Consumes: `TMUX_BIN`, `AWTOMIC_DIR`, service-specific config values.
- Produces: `service_names()`, `service_dir(NAME)`, `service_command(NAME)`, `svc_up(NAME)`, `svc_down(NAME)`, and `svc_restart(NAME)`.

- [ ] **Step 1: Write the failing service lifecycle test**

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/bin" "$TMP/awtomic/awtomic-api"

cat >"$TMP/bin/tmux" <<'SH'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"$AWT_TMUX_LOG"
case "$1" in
  has-session)
    [[ ${AWT_TMUX_MODE:-new} == dead ]] && exit 0
    exit 1
    ;;
  list-windows)
    [[ ${AWT_TMUX_MODE:-new} == dead ]] && printf 'api\n'
    ;;
  list-panes)
    [[ ${AWT_TMUX_MODE:-new} == dead ]] && printf '1\n'
    ;;
esac
SH
chmod +x "$TMP/bin/tmux"

cat >"$TMP/awt.conf" <<CONF
SERVER_HOSTNAME=desktop
SERVER_USER=alex
SERVER_NET_NAME=desktop.tailnet
FORWARD_PORTS="8081"
AWTOMIC_DIR="$TMP/awtomic"
DEFAULT_UP="api"
DYNAMO_DIR="$TMP"
DYNAMO_CMD=true
SMOOTHMQ_CMD=true
WEB_PORT=8081
NGROK_CMD=true
CONF

AWT_CONF="$TMP/awt.conf" \
AWT_HOSTNAME=desktop \
AWT_TMUX_BIN="$TMP/bin/tmux" \
AWT_TMUX_LOG="$TMP/tmux.log" \
  "$ROOT/awt" up

grep -Fq "new-window -d -t awtomic-svc -n api -c $TMP/awtomic/awtomic-api npm run dev" "$TMP/tmux.log"

AWT_CONF="$TMP/awt.conf" \
AWT_HOSTNAME=desktop \
AWT_TMUX_BIN="$TMP/bin/tmux" \
AWT_TMUX_LOG="$TMP/tmux.log" \
AWT_TMUX_MODE=dead \
  "$ROOT/awt" up api

grep -Fq 'respawn-window -k -t awtomic-svc:api' "$TMP/tmux.log"

if AWT_CONF="$TMP/awt.conf" AWT_HOSTNAME=desktop AWT_TMUX_BIN="$TMP/bin/tmux" "$ROOT/awt" up unknown >/dev/null 2>&1; then
  echo "unknown service unexpectedly passed" >&2
  exit 1
fi

echo "awt services: OK"
```

- [ ] **Step 2: Run the test and verify the current `cd && command` launch fails**

Run: `bash personal/awtomic/tests/services-test.sh`

Expected: FAIL because current `new-window` does not use `-c`.

- [ ] **Step 3: Replace delimiter-based service lookup with Bash 3-compatible pure functions**

```bash
service_names() {
  printf '%s\n' dynamo smoothmq pg data api web widget sqs stream ngrok
}

service_dir() {
  case "$1" in
    dynamo) printf '%s\n' "$DYNAMO_DIR" ;;
    smoothmq) printf '%s\n' "$AWTOMIC_DIR/smoothmq" ;;
    pg|data) printf '%s\n' "$AWTOMIC_DIR/shopify-api-data" ;;
    api) printf '%s\n' "$AWTOMIC_DIR/awtomic-api" ;;
    web|widget) printf '%s\n' "$AWTOMIC_DIR/bundle-shopify" ;;
    sqs) printf '%s\n' "$AWTOMIC_DIR/shopify-sqs-handlers" ;;
    stream) printf '%s\n' "$AWTOMIC_DIR/shopify-dynamodb-datastream" ;;
    ngrok) printf '%s\n' "$HOME" ;;
    *) return 1 ;;
  esac
}

service_command() {
  case "$1" in
    dynamo) printf '%s\n' "$DYNAMO_CMD" ;;
    smoothmq) printf '%s\n' "$SMOOTHMQ_CMD" ;;
    pg) printf '%s\n' 'npm run dev:db' ;;
    data|api|web) printf '%s\n' 'npm run dev' ;;
    widget) printf '%s\n' 'npm run dev:widget' ;;
    sqs) printf '%s\n' 'npm run start-sqs' ;;
    stream) printf '%s\n' 'npm run start-stream' ;;
    ngrok) printf '%s\n' "$NGROK_CMD" ;;
    *) return 1 ;;
  esac
}
```

- [ ] **Step 4: Launch service windows with native start directories**

```bash
svc_up() {
  local name=$1 dir command
  dir=$(service_dir "$name") || die "unknown service: $name"
  command=$(service_command "$name") || die "unknown service: $name"
  [[ -d "$dir" ]] || die "missing service directory: $dir"
  ensure_session

  if win_exists "$name"; then
    if win_dead "$name"; then
      "$TMUX_BIN" respawn-window -k -t "$SESSION_SVC:$name"
      echo "restarted $name"
    else
      echo "$name already running"
    fi
    return 0
  fi

  "$TMUX_BIN" new-window -d -t "$SESSION_SVC" -n "$name" -c "$dir" "$command"
  echo "started $name"
}
```

Update every tmux call in helpers to use `"$TMUX_BIN"`.

- [ ] **Step 5: Make shutdown bounded and clean**

```bash
svc_down() {
  local name=$1 attempt
  win_exists "$name" || {
    echo "$name already stopped"
    return 0
  }

  if ! win_dead "$name"; then
    "$TMUX_BIN" send-keys -t "$SESSION_SVC:$name" C-c
    for attempt in 1 2 3 4 5 6 7 8 9 10; do
      win_dead "$name" && break
      sleep 0.2
    done
  fi

  "$TMUX_BIN" kill-window -t "$SESSION_SVC:$name" 2>/dev/null || true
  echo "stopped $name"
}
```

- [ ] **Step 6: Run all private tests**

Run:

```bash
for test in personal/awtomic/tests/*.sh; do bash "$test"; done
bash -n personal/awtomic/awt personal/awtomic/tests/*.sh
SHELLCHECK=$(command -v shellcheck 2>/dev/null || printf '%s' "$HOME/.local/share/nvim/mason/bin/shellcheck")
"$SHELLCHECK" personal/awtomic/awt personal/awtomic/tests/*.sh
```

Expected: dispatch, setup, and service tests all print `OK`.

---

### Task 4: Integrate the private command with Fish and document manual copying

**Files:**
- Modify: `personal/fish/awtomic.fish`
- Modify: `personal/awtomic/README.md`
- Verify: `personal/tmux/awtomic.conf`

**Interfaces:**
- Consumes: self-contained `personal/awtomic/awt` and public generic personal loaders.
- Produces: an interactive `awt` command discoverable on both Macs without an abbreviation collision.

- [ ] **Step 1: Write the failing private integration test**

Append this assertion to `personal/awtomic/tests/dispatch-test.sh`:

```bash
fish -c "source '$ROOT/../fish/awtomic.fish'; type -q awt; and not abbr --show awt | string match -q '*cd *'"
```

- [ ] **Step 2: Run the test and verify the existing `awt` abbreviation fails**

Run: `bash personal/awtomic/tests/dispatch-test.sh`

Expected: FAIL because `awt` currently expands to `cd ~/awtomic`.

- [ ] **Step 3: Replace the conflicting abbreviation with a path and a distinct navigation shortcut**

Replace `personal/fish/awtomic.fish` with:

```fish
fish_add_path ~/.config/personal/awtomic
abbr -a awd 'cd ~/awtomic'
abbr -a tna 'tmux new -s awtomic'
abbr -a taw 'tmux attach -t awtomic'
abbr -a tbs 'tmux attach -t bundle-shopify'
```

- [ ] **Step 4: Rewrite the private README around the approved flow**

Document these exact commands:

```bash
# Desktop
chmod +x ~/.config/personal/awtomic/awt
awt setup server
awt doctor

# Then copy ~/.config/personal to the laptop.

# Laptop
awt setup client
awt doctor
awt
```

Document that `awt` never modifies repositories, `.env` files, or
`~/.ssh/config`; that its forwarding exists while the shared SSH connection is
alive; and that `awt.conf` is private and copied manually.

- [ ] **Step 5: Run private end-to-end verification**

Run:

```bash
for test in personal/awtomic/tests/*.sh; do bash "$test"; done
fish --no-execute personal/fish/awtomic.fish
bash -n personal/awtomic/awt
SHELLCHECK=$(command -v shellcheck 2>/dev/null || printf '%s' "$HOME/.local/share/nvim/mason/bin/shellcheck")
"$SHELLCHECK" personal/awtomic/awt personal/awtomic/tests/*.sh
git status --short --ignored personal
```

Expected: tests pass; Fish/Bash/ShellCheck return zero; private files remain
ignored and unstaged.
