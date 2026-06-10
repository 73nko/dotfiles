# .config audit, June 2026 (v2, verified)

Second pass, June 9. The v1 audit from earlier today was checked claim by claim against the actual files and against the live state of every tool ecosystem (web-verified, June 2026 sources). This version corrects what v1 got wrong, marks what you already fixed, and adds findings v1 missed.

---

## 0. The uncomfortable opening

The first audit sat in this folder and the response was to ask for another audit. None of the P0 items moved: secrets are still plaintext, mise still manages exactly one tool, sidekick is still untried. A second analysis of an unexecuted plan is not progress, it is a more sophisticated form of procrastination. This document is sharper than v1, but its marginal value is near zero compared to executing item 1 of the plan you already had. Read section 5, pick the first item, do it today.

---

## 1. v1 claims: verified, corrected, or already done

**Verified true (all 7 nvim claims):** nvim-lint triggers include InsertLeave; NeoCodeium with the supermaven exit comment; snacks.image disabled citing 0.12 treesitter API; conform async format_after_save (documented, intentional); python = pyright + ruff lint + ruff format (three layers); claude/opencode terminal keymaps; diffview, render-markdown, package-info in the lockfile.

**Corrected:**
- "You are on Neovim 0.12 dev absorbing breakage": no longer true. 0.12.0 shipped stable March 29, 2026. You are on stable now. Consequence: re-test `snacks.image`, the treesitter API incompatibility comment may be obsolete. Also 0.12 ships `vim.pack` (native plugin manager, experimental). Not a reason to leave lazy.nvim yet, but watch it.
- "NeoCodeium is degrading": the plugin itself is fine (maintained, last push June 5, 2026). The real risk is the backend: Windsurf's free tier has been degraded post-breakup (OpenAI deal collapsed July 2025, Google took the founders, Cognition took the rest) and free users are being pushed to the paid plan. So the v1 conclusion stands but for the right reason: you depend on a free tier owned by a company whose incentive is to shut it.

**Already fixed (credit where due):** `.DS_Store` is gitignored and zero files are tracked. Dead `@prefix_highlight_*` options removed from tmux.conf. The resurrect nvim-session strategy dead config was removed and documented inline.

**Still pending from v1:** plaintext `~/.secrets.fish` (no `op` usage anywhere in fish/ or scripts/), mise = node only, orphaned `tmux/plugins/vim-tmux-navigator/` dir on disk, stale dotfyle README.md, InsertLeave still in nvim-lint triggers.

---

## 2. New findings v1 missed

### 2.1 Dead keybind: yazi drag-and-drop (broken on macOS)
`keymap.toml` binds `<C-n>` to `dragon -x -i -T`. `dragon` is a Linux/X11 tool. It is not in your Brewfile and has no macOS build. This keybind has never worked on this machine. Delete it, or replace with `open -R` reveal + Finder drag.

### 2.2 Theme drift: your shell is still on the old palette
Ghostty, tmux, yazi and sketchybar migrated to Violet Hour Glass. But `config.fish` hardcodes the full **Neon Nocturne** palette for fish syntax highlighting AND for FZF colors (`#0a0e14` background against your `#0D0D2C` terminal). There is a `violet-hour-tide.fish` in conf.d, so the prompt migrated but the syntax colors and FZF did not. For someone who invests this much in theming, the layer you stare at most (the command line itself) is on the abandoned palette. Either finish the migration or, better, take it as evidence for the v1 meta-point: theming is never finished, cap it.

### 2.3 Commit hygiene collapsed
Recent history: "Update", "Updates", "New things", "Setup cleanup". Older history: "fish: stop versioning plugin code; fish_plugins is single source of truth". Your dotfiles history was your changelog and your inline comments are excellent ("auditoria 2026-06"). The commit messages no longer match that standard. Cheap fix, real value when future-you asks "when did X break".

### 2.4 nvim details (from the deep pass)
- `shopify_theme_ls` is in `vim.lsp.enable()` but not in mason's ensure_installed. If it is installed out-of-band, document it; if not, it silently never attaches.
- `foldexpr`/`indentexpr` set in both options.lua and treesitter.lua. One source of truth.
- Missing cheap polish for 0.12: `completeopt` tuning, `pumblend`/`winblend` now that you are on stable.

### 2.5 tmux: you are 2 versions of features behind, and 2 plugins are abandonware
tmux 3.6b (May 2026) gives you native `pane-scrollbars` and dark/light theme reporting (Mode 2031). Meanwhile tmux-resurrect and tmux-continuum have had zero pushes since August 2024 with ~380 combined open issues. They are unmaintained. Your real session flow is sessionx + zoxide + auto-session and you restore nvim manually anyway. Cut resurrect + continuum, you lose almost nothing and drop two dead dependencies. Also `rm -rf tmux/plugins/vim-tmux-navigator`.

### 2.6 ghostty 1.3: your vim-mode keytable is now half redundant
1.3 (March 2026) added native scrollback search (cmd+F), native scrollbars, click-to-move-cursor, and `progress-style` for OSC 9;4 progress bars (your tools like cargo/topgrade can surface progress in the title bar). Your alt+v vim keytable for scrollback navigation predates native search; keep it for j/k scrolling if you like it, but cmd+F likely covers the actual use case (finding something in scrollback). Also still unused: `quick-terminal` as a global dropdown, faster than Raycast for one-off commands.

### 2.7 yazi plugin suggestions, corrected for macOS
v1 suggested restore.yazi, but it is built on Linux trash-cli and you use `macos-trash`. Verify compatibility before adopting; it may be a no-op on macOS. ouch.yazi (unified archive handling) and mediainfo.yazi remain good fits. Yazi itself is current (25.x, May 2026 release) and your config syntax is up to date.

### 2.8 Tools you did not think of (web-verified June 2026)
- **jujutsu (jj)**, v0.42, 27k stars, used inside Google: a git-compatible VCS where the working copy is always a commit, undo is universal, and rebase conflicts do not block you. It coexists with your git repos (`jj git init --colocate`). Of everything in this list, this is the one with real ceiling for your daily work. Trial it on one repo, not on dotfiles.
- **posting**: TUI API client. You carry both `httpie` and the Insomnia cask; posting could replace Insomnia and keep you in the terminal.
- **television (tv)**: fast fuzzy-finder with channels (files, git, env). Overlaps with fzf, only worth it if fzf ever feels limiting. Low priority.
- **sidekick.nvim** (from v1, re-verified): active, April 2026 push, Copilot Next Edit Suggestions + AI CLI terminal with tmux persistence. Still the highest-leverage nvim change available to you.

### 2.9 mise, re-verified
2026 mise has native Rust backends for node, python, go, java, ruby, rust (manages rustup-style toolchains), plus cargo/npm/pipx/ubi backends, a task runner, and env management. Everything currently spread across brew language formulas (elixir aside), rustup, `go install`, and ad-hoc npm/uv installs can live in one `mise.toml` with per-project pinning. Your Brewfile's `go "..."` and `cargo "..."` sections would shrink to mise config. The half-state (mise installed, managing one tool) remains the worst option.

---

## 3. What is genuinely excellent (unchanged from v1, confirmed)

git config (delta, zdiff3, rerere, fsmonitor), the tmux/AeroSpace modifier contract, the popup workflow (lazygit, git-orchard, scratch), smart-splits with @pane-is-vim, the yazi opener fallbacks with documented reasoning, conform/lint layering, the inline audit-trail comments. Top tier. Nothing to fix here.

---

## 4. Risk register (ordered by expected damage)

1. **Plaintext secrets** on disk, readable by every process you run, while 1Password + `op` sit installed. One malicious npm postinstall away from exfiltration. This is the only item here with real blast radius.
2. **AI completion on a hostile free tier** (Windsurf/Cognition). Will degrade without notice.
3. **Two unmaintained tmux plugins** in the persistence path of every session.
4. **Toolchain sprawl**: five managers, no per-project pinning outside node. Bites you the day two projects need different go/python versions.

---

## 5. The plan (do in order, no new audits until 1-3 are done)

1. **Today, 30 min:** wire `~/.secrets.fish` through `op` (`op run` wrapper or 1Password fish shell plugin). Delete the plaintext file.
2. **This week, 1 evening:** trial sidekick.nvim next to NeoCodeium. Decide, keep one paradigm.
3. **This week, 15 min:** cut resurrect + continuum, `rm -rf` vim-tmux-navigator dir, delete the dead dragon keybind in yazi, drop InsertLeave from nvim-lint.
4. **This month:** move go/cargo/python/java tool management into mise. Shrink the Brewfile.
5. **This month, only after 1-4:** finish or freeze the Violet Hour migration in fish/FZF. Timebox: one evening, then it is done, permanently.
6. **Optional curiosity budget:** jj on one work repo, posting instead of Insomnia.

The meta-point from v1 stands and v2 found more evidence for it (theme drift, commit messages). The config is a finished product being polished; the workflow has four real gaps being ignored. Invert the energy.
