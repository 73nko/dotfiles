# AWT Service Set Cleanup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remove SmoothMQ from AWT and make `awt up` start the exact daily Awtomic service set.

**Architecture:** Keep the existing fixed service map and tmux lifecycle design. Remove the obsolete service at each existing boundary—registry, command map, setup serialization, help, tests, documentation, and private configuration—without changing service names or lifecycle mechanics.

**Tech Stack:** Bash 3.2, tmux command stubs, ShellCheck, private shell configuration.

## Global Constraints

- The default startup order is exactly `dynamo pg data api web widget ngrok`.
- `smoothmq` is not an accepted AWT service and must fail before any tmux call.
- `sqs` and `stream` remain available explicitly but are not started by default.
- `personal/awtomic` stays ignored and must not be staged or committed.
- No real service, tmux session, SSH connection, or ngrok tunnel is started during verification.

---

### Task 1: Remove SmoothMQ from the AWT service model

**Files:**
- Modify: `personal/awtomic/tests/setup-test.sh`
- Modify: `personal/awtomic/tests/services-test.sh`
- Modify: `personal/awtomic/awt`
- Modify: `personal/awtomic/README.md`

**Interfaces:**
- Consumes: existing `service_names`, `service_dir`, `service_command`, `setup_server`, and `show_help` shell functions.
- Produces: an AWT service model with no `smoothmq` entry and the default list `dynamo pg data api web widget ngrok`.

- [ ] **Step 1: Write failing setup and lifecycle tests**

In `personal/awtomic/tests/setup-test.sh`, remove the `SmoothMQ command` response, return the new exact value for `Default services`, and assert the generated config contains no SmoothMQ assignment:

```bash
"Default services") printf '%s\n' 'dynamo pg data api web widget ngrok' ;;
```

```bash
if grep -Fq 'SMOOTHMQ_CMD=' "$AWT_CONF"; then
  echo "setup unexpectedly wrote SmoothMQ configuration" >&2
  exit 1
fi
```

After sourcing the generated configuration, assert:

```bash
[[ "$DEFAULT_UP" == 'dynamo pg data api web widget ngrok' ]]
```

Also assert the public service registry and help output contain no SmoothMQ:

```bash
if service_names | grep -Fqx smoothmq; then
  echo "SmoothMQ unexpectedly remains registered" >&2
  exit 1
fi

if grep -Fq smoothmq <<<"$help_output"; then
  echo "help unexpectedly lists SmoothMQ" >&2
  exit 1
fi
```

In `personal/awtomic/tests/services-test.sh`, verify every SmoothMQ lifecycle command is rejected without tmux:

```bash
for command in up down restart logs; do
  assert_rejected_without_tmux "$command" smoothmq
done
```

- [ ] **Step 2: Run the tests and verify RED**

Run:

```bash
/bin/bash personal/awtomic/tests/setup-test.sh
/bin/bash personal/awtomic/tests/services-test.sh
```

Expected: setup fails because the script still asks for `SmoothMQ command` or writes `SMOOTHMQ_CMD`; services fails because `smoothmq` still reaches the tmux stub.

- [ ] **Step 3: Implement the minimal service-model change**

In `personal/awtomic/awt`:

- remove `write_assignment SMOOTHMQ_CMD "$SMOOTHMQ_CMD"`;
- remove `smoothmq` from `service_names`;
- remove the `smoothmq` cases from `service_dir` and `service_command`;
- remove the SmoothMQ question from `setup_server`;
- change the default prompt to `dynamo pg data api web widget ngrok`;
- remove `smoothmq` from the help service list.

Do not change `sqs`, `stream`, lifecycle functions, tmux behavior, or remote dispatch.

In `personal/awtomic/README.md`, state that plain `awt up` starts:

```text
dynamo, pg, data, api, web, widget y ngrok
```

- [ ] **Step 4: Run focused tests and static checks**

Run:

```bash
/bin/bash personal/awtomic/tests/setup-test.sh
/bin/bash personal/awtomic/tests/services-test.sh
/bin/bash -n personal/awtomic/awt personal/awtomic/tests/*.sh
$HOME/.local/share/nvim/mason/bin/shellcheck personal/awtomic/awt personal/awtomic/tests/*.sh
```

Expected: both suites print their `OK` result; Bash syntax and ShellCheck exit zero.

### Task 2: Migrate the current private configuration and verify the complete workflow

**Files:**
- Modify: `personal/awtomic/awt.conf`

**Interfaces:**
- Consumes: the configuration variables loaded by `personal/awtomic/awt`.
- Produces: the current Desktop configuration without `SMOOTHMQ_CMD` and with the new exact `DEFAULT_UP` value.

- [ ] **Step 1: Migrate the current configuration**

Remove the `SMOOTHMQ_CMD` assignment from `personal/awtomic/awt.conf` and replace its default assignment with:

```bash
DEFAULT_UP=dynamo\ pg\ data\ api\ web\ widget\ ngrok
```

- [ ] **Step 2: Verify the loaded private configuration without starting services**

Run a source-only Bash assertion with `AWT_SOURCE_ONLY=1` and `AWT_CONF` pointing to the current private configuration. Assert `DEFAULT_UP` is exact, `SMOOTHMQ_CMD` is unset, and `validate_service smoothmq` fails.

Expected: exit zero with no tmux or service process invoked.

- [ ] **Step 3: Run the complete private regression suite**

Run:

```bash
for test_file in personal/awtomic/tests/*.sh; do
  /bin/bash "$test_file"
done
```

Expected: dispatch, services, and setup suites all print `OK`.

- [ ] **Step 4: Confirm the public/private boundary**

Run:

```bash
git check-ignore -v personal/awtomic/awt personal/awtomic/awt.conf personal/awtomic/README.md personal/awtomic/tests/setup-test.sh personal/awtomic/tests/services-test.sh
git status --short
```

Expected: every implementation path is ignored and no private change appears in Git status. Only this tracked plan and its design document may exist in branch history.

- [ ] **Step 5: Record completion**

Do not stage or commit private AWT files. Report the verified local change and explicitly note that the laptop must receive the updated `personal/awtomic` folder through the user's manual copy workflow.
