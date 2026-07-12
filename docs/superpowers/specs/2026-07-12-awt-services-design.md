# AWT service set cleanup

## Goal

Remove the unused SmoothMQ service from AWT and make the default startup set
match the services used for daily Awtomic development.

## Service behavior

`awt up` starts these services in order:

1. `dynamo` — local DynamoDB
2. `pg` — the `shopify-api-data` development database
3. `data` — `shopify-api-data`
4. `api` — `awtomic-api`
5. `web` — the `bundle-shopify` admin
6. `widget` — the `bundle-shopify` widget
7. `ngrok` — the configured public tunnel

SmoothMQ is removed from the accepted service names, setup prompts, generated
configuration, help output, and current private configuration. Explicit
`smoothmq` lifecycle or log commands fail as an unknown service before tmux is
called.

`sqs` and `stream` remain available as explicit services but are not part of
the default startup set.

## Configuration migration

`awt setup server` no longer asks for or serializes `SMOOTHMQ_CMD`. Its default
service prompt uses `dynamo pg data api web widget ngrok`.

The current ignored `personal/awtomic/awt.conf` is migrated in place by
removing `SMOOTHMQ_CMD` and setting `DEFAULT_UP` to the same service list. A
future `awt setup server` produces the same shape.

## Verification

Tests must prove that:

- setup neither asks for nor writes SmoothMQ configuration;
- the generated default service set is exact and ordered;
- `smoothmq` is rejected without invoking tmux;
- all existing AWT dispatch, setup, and lifecycle tests still pass under the
  macOS system Bash;
- Bash syntax and ShellCheck remain clean.
