# Dotfiles Convergence and Violet Hour Design

**Date:** 2026-07-10

## Objective

Make this public repository reproduce the same versionable Mac environment on
any Mac, improve the daily terminal workflow without unnecessary tool churn,
and make Violet Hour the consistent active theme. Keep the private `awt`
Desktop-to-laptop workflow completely optional and outside public bootstrap.

Reproducible state includes packages, versioned configuration, macOS defaults,
fonts, plugins, services, and themes. It excludes accounts, secrets,
permissions, caches, histories, and application databases.

## Guiding decisions

- Keep the current core stack. No available replacement gives tmux, Neovim,
  Fish, Ghostty, Yazi, fzf, zoxide, Atuin, mise, or lazygit a substantial
  enough advantage to justify migration.
- Prefer surgical corrections and native features over new dependencies.
- Install the same public stack on every Mac; do not add machine profiles.
- Treat `personal/` as an optional, manually copied, gitignored layer.
- Make normal convergence additive. It must not remove unrelated user tools.
- Validate theme consistency instead of generating every native theme file.

## 1. Public repository boundary

The public repository owns the complete general-purpose Mac environment.
`scripts/setup.sh` must not know whether `personal/` or `awt` exists.

Public Fish and tmux configuration may load zero or more private extension
files. Those loaders must be generic and safe when the directories are absent
or empty. A public clone without `personal/` must remain fully functional.

`XDG_CONFIG_HOME` will consistently point to `~/.config`. This makes the
repository the real configuration root and lets tools such as lazygit consume
their checked-in configuration on macOS.

Runtime state must not be tracked. This includes Zed prompt databases, UV
receipts, Yarn installation state, backup settings, package-manager materialized
plugin directories, caches, histories, and lock files that represent live
application state rather than declared dependencies.

## 2. Bootstrap and doctor

The public interface remains:

- `setup.sh` or `setup.sh sync`: converge the Mac.
- `setup.sh doctor`: inspect without changing machine configuration.
- `setup.sh export`: refresh the Brewfile and apply its exclusions.
- `setup.sh --upgrade`: converge and upgrade existing packages.

Normal convergence performs these phases:

1. Verify macOS and install Xcode Command Line Tools and Homebrew when absent.
2. Apply the Brewfile without removing unrelated software.
3. Install Rust and mise-managed runtimes and development tools.
4. Configure Fish and synchronize its declared plugins.
5. Install locked tmux and Yazi plugins.
6. Build only missing generated assets and required theme caches.
7. Apply macOS behavior and Violet Hour visual settings.
8. Start declared services.
9. Run the expanded doctor.

The current destructive legacy cleanup is removed from normal convergence.
Historical migration actions must not run automatically on public users'
machines.

A shared static checker will validate repository configuration. `doctor` will
combine those static checks with live machine checks for:

- Bash and Fish syntax.
- JSON, TOML, YAML, and Lua configuration where supported.
- tmux loading in an isolated temporary server.
- Neovim startup and deprecation health.
- Brewfile satisfaction without upgrading.
- Fisher, TPM, Yazi, Mason, and mise installation state.
- Expected XDG configuration paths.
- Active theme references and palette consistency.
- Tracked runtime-state files.
- Declared services, required permissions, and authentication steps.

Non-critical failures accumulate into one actionable summary. Installation
errors remain visible in the log. Checks must distinguish invalid repository
state, missing installed state, and unavoidable manual actions.

The README will use the real public HTTPS clone URL and document the
reproducible boundary, bootstrap flow, commands, manual logins, permissions,
and GUI theme imports.

## 3. Daily tooling

### tmux

Keep TPM, smart-splits, and sessionx. Add explicit Vim mode for copy and status
interaction so the existing `copy-mode-vi` bindings are active. Apply Violet
Hour popup styles to lazygit, scratch shells, sessionx, and Git Orchard.

Retain extended keys, OSC 52 clipboard support, directory inheritance, and the
AeroSpace modifier contract. Replace the current hardcoded private include with
a safe generic loader while preserving the user's `awtomic.conf` behavior.

### Neovim

Keep the plugin set and native Neovim 0.12 LSP architecture. Current health
reports no deprecated functions. Preserve blink completion, Sidekick/Copilot,
Mason, formatting, linting, testing, debugging, and session behavior.

Reduce `snacks.lua` only by removing copied upstream defaults and stale
explanatory history that do not affect behavior. Keep keybindings and deliberate
overrides. Experimental features remain disabled unless verification proves
their upstream incompatibilities are resolved.

### lazygit

Add a minimal checked-in `lazygit/config.yml`. It will define only intentional
deviations: Violet Hour UI colors, rounded borders, Nerd Font support, and delta
for previews. `XDG_CONFIG_HOME` makes this file the macOS source of truth.

### Fish, Atuin, and safety

Define XDG variables once and make private source loading safe. Replace the
destructive `del-branches` abbreviation with the already-installed `gh poi`
merged-branch workflow. Strengthen Atuin filters for common secret assignments.
Add ShellCheck as a public validation dependency rather than relying on the
Neovim-private Mason installation.

### Yazi and update ownership

Keep Yazi and the custom Violet Hour flavor. `package.toml` remains the locked
source of truth; package-managed plugin copies must not be tracked. The current
theme references only Violet Hour, so the inactive Neon Nocturne and Tokyo
Night flavor copies will be removed.

Keep Ghostty, btop, fzf, zoxide, Git/delta, AeroSpace, SketchyBar, Zed, and
Topgrade. Remove duplicate update steps where Topgrade and another declared
owner currently perform the same update.

## 4. Violet Hour theme system

A machine-readable palette defines core surfaces, identity accents, semantic
colors, and muted text. Native tool configurations continue to contain the
values they require, while a theme checker detects drift from the canonical
palette.

The active theme covers:

- Ghostty and Neovim ANSI colors.
- Neovim highlights, lualine, bufferline, diagnostics, and plugin UIs.
- tmux status, borders, messages, and popups.
- Fish syntax, Tide, fzf, lazygit, Yazi, btop, bat, and delta.
- SketchyBar, Borders, Zed, Raycast, Chrome, and macOS visual defaults.
- Manual Slack theme instructions.

Violet remains the interface identity, but semantic states remain recognizable:
coral for errors and deletions, gold for warnings, green for successes and
additions, and teal/cyan for information.

Correct the stale Chrome, Raycast, Zed, and general theme documentation. Remove
obsolete Sunset Pool claims from active-theme documentation. Remove Glow rather
than restoring its deleted standalone theme; `ncheat` will use the existing
Neovim render-markdown setup, with the HTML cheatsheet retained as an
alternative.

## 5. Private `awt` workflow

`personal/awtomic/awt` locates `awt.conf` relative to its own executable. No
private path points to the public `~/.config/awtomic` location.

Setup is explicit and recoverable:

1. Run `awt setup server` on the Desktop.
2. Detect and confirm the server hostname, user, Tailscale name, repository
   paths, DynamoDB, ngrok domain, ports, service commands, and default services.
3. Serialize shell-safe values to `personal/awtomic/awt.conf`.
4. Copy `personal/` manually to the laptop.
5. Run `awt setup client` on the laptop.
6. Validate SSH, authentication, remote paths, dependencies, and forwarding
   without rewriting shared configuration.

Bare `awt setup` remains a guided role prompt. `awt` constructs SSH options
itself instead of editing `~/.ssh/config`. It uses the configured server target,
ControlMaster, persistent shared connections, explicit local forwards,
`ExitOnForwardFailure`, and shell-safe remote argument serialization.

The Desktop keeps two tmux sessions: `main` for interactive work and
`awtomic-svc` for service windows. Each service has one named window and uses
tmux's start-directory option rather than interpolated `cd` command strings.
Dead windows retain logs and can be restarted. Shutdown requests a clean
interrupt before removing the service window.

Add `awt doctor` for configuration, dependency, directory, server identity,
SSH, and forwarding checks.

## 6. Error handling and verification

Public verification includes:

- Static configuration checks.
- Isolated tmux loading.
- Neovim startup and deprecation checks.
- Yazi diagnostics.
- Theme consistency checks.
- Brewfile comparison.
- Confirmation that runtime state is not tracked.

Private `awt` tests use a temporary home directory and stub SSH and tmux
commands. They cover server detection, safe serialization, client dispatch,
argument quoting, default services, unknown services, dead-window restart, and
actionable failure messages.

Verification reports missing packages but does not silently install software or
alter unrelated machine state.

## Acceptance criteria

- A fresh Mac can clone the public repository and run one convergence command.
- Re-running convergence is safe and non-destructive.
- Public configuration works with no `personal/` directory.
- `doctor` identifies repository errors, machine drift, and manual steps.
- Copying `personal/` makes `awt` discoverable without command shadowing.
- `awt` runs services locally on the Desktop and safely dispatches the same
  commands from the laptop.
- Daily-tool configuration validates without unintended workflow changes.
- Every active themed tool uses Violet Hour and active documentation matches it.
- Runtime databases, caches, receipts, backups, and generated package copies
  are not tracked.

## Upstream references

- [Homebrew Bundle and Brewfile](https://docs.brew.sh/Brew-Bundle-and-Brewfile)
- [Lazygit configuration](https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md)
- [tmux changes](https://github.com/tmux/tmux/blob/master/CHANGES)
- [Neovim 0.12 changes](https://neovim.io/doc/user/news-0.12/)
- [Yazi flavors](https://yazi-rs.github.io/docs/flavors/overview/)
- [Yazi package manager](https://yazi-rs.github.io/docs/cli/)
