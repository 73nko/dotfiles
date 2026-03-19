# Terminal Setup Audit

## Executive Summary

Your setup is solid and well-thought-out. Consistent Nebula theme across all tools, modern CLI replacements (eza, bat, fd, ripgrep, zoxide), and a vim-centric philosophy throughout. That said, there are dead dependencies, keybinding collisions, redundancies between tools, and a few components that are either deprecated or have significantly better alternatives available now.

Below is everything I found, organized by severity and tool.

---

## Critical Issues

### 1. Neofetch is Dead - Replace with Fastfetch

Neofetch was archived in April 2024 and hasn't received updates in years. It's in your Brewfile but no longer maintained. Fastfetch (written in C) is the direct successor: faster, more accurate, actively maintained, and supports Wayland.

**Action:** `brew install fastfetch && brew uninstall neofetch`. Migrate your `~/.config/neofetch/config.conf` (865 lines of customization) to Fastfetch's JSONC format, or start fresh since Fastfetch's defaults are already good.

### 2. Oh-My-Fish (OMF) is Abandoned - Remove It

You have both Fisher AND Oh-My-Fish installed. OMF has been [officially declared end-of-life](https://github.com/oh-my-fish/oh-my-fish/issues/947) with broken plugins, unmaintained code, and it trips up new users. Your `omf/bundle` file shows `plugin-git` and `default` theme, but you're already loading `plugin-git` through Fisher and using Tide for your prompt.

OMF is pure dead weight. It adds startup overhead, injects non-standard hooks (`init.fish`, `before.init.fish`, vendor variables), and creates framework lock-in for zero benefit since Fisher already handles everything.

**Action:** `omf destroy` to remove it, then delete `~/.config/omf/`. Fisher is doing all the real work already.

### 3. OpenClaw Completion Uses Hardcoded Absolute Path

Line 172 of your `config.fish`:
```fish
source "$HOME/.openclaw/completions/openclaw.fish"
```
This will break on any machine where your username isn't `YOUR-USER`. Same issue with the Antigravity path on line 169.

**Action:** Replace with:
```fish
source "$HOME/.openclaw/completions/openclaw.fish"
fish_add_path "$HOME/.antigravity/antigravity/bin"
```

---

## Redundancies & Dead Weight

### 4. Four Unused tmux Theme Plugins

Your tmux plugins directory contains `tmux-tokyo-night`, `tmux-colors-solarized`, and `tmux-themepack`, none of which are referenced in `tmux.conf`. You built a custom Nebula theme (which looks good), making all three irrelevant. Also `tmux-yank` is installed but not in your plugin list.

This is clutter that slows down `prefix + I` updates and wastes disk space.

**Action:** Remove these directories from `~/.config/tmux/plugins/` and ensure they're not listed anywhere TPM can pick them up.

### 5. Magnet + Yabai/skhd = Redundant

You have Magnet installed from the Mac App Store AND a full yabai + skhd tiling setup. These serve the same purpose. Magnet is a basic window snapper; yabai is a full tiling WM. Running both means potential conflicts when both try to manage window positions.

Beyond that, you should seriously consider **AeroSpace** as a replacement for yabai + skhd. It doesn't require SIP to be partially disabled, uses a single TOML config instead of two separate daemons, has a migration tool for yabai configs, and is under very active development. Your skhd config even says "migrated from AeroSpace" which suggests you already tried it.

**Action:** Uninstall Magnet. Then evaluate whether to stay on yabai+skhd or switch back to AeroSpace (which would also eliminate the dependency on `skhd` and `borders` as separate processes).

### 6. Double Git Abbreviations

You define git abbreviations in TWO places: manually in `config.fish` (lines 63-70) AND through `jhillyerd/plugin-git` which generates 190+ abbreviations via `__git.init`. The plugin already covers `g`, `gcount`, etc. Your manual definitions either duplicate or potentially conflict with the plugin's.

**Action:** Remove the manual git abbreviations from `config.fish` and rely on the plugin. If you need custom ones the plugin doesn't provide, add them AFTER the plugin loads in a separate conf.d file.

### 7. `bash-completion` is Useless

You have `bash-completion` in your Brewfile but your shell is Fish. Fish has its own completion system that's incompatible with bash completions.

**Action:** `brew uninstall bash-completion` unless you occasionally use bash interactively.

### 8. Duplicate `fd` Installation

You have `fd` installed via both Homebrew (`brew "fd"`) and Cargo (`cargo "fd-find"`). The Cargo version is the same tool.

**Action:** Pick one. Homebrew is simpler to maintain.

---

## Keybinding Collisions & Conflicts

### 9. tmux `h/j/k/l` Resize vs vim-tmux-navigator

Your tmux config binds `prefix + h/j/k/l` to resize panes. Meanwhile, `vim-tmux-navigator` uses `Ctrl-h/j/k/l` for navigation between vim and tmux panes. These don't technically collide (different modifiers), but the resize bindings shadow tmux's default last-window (`l`) and other navigation after prefix. More importantly, if you're in prefix mode and accidentally hit `h` you'll resize instead of navigating.

Consider using `prefix + H/J/K/L` (uppercase) or `prefix + Alt-h/j/k/l` for resize to keep the prefix+hjkl namespace free.

### 10. skhd `alt-e` Conflicts with Shell Usage

`alt-e` is bound to toggle split type in skhd. But with `macos-option-as-alt = true` in Ghostty, pressing Option+E in the terminal sends Alt+E to the shell, which in Fish vi mode is used for editing commands. This means you can't use Option+E in the terminal without triggering a yabai action.

This applies to several other skhd bindings: `alt-r` (rotate), `alt-x` (mirror), `alt-y` (mirror), `alt-minus`, `alt-equal`, all the `alt-{1-7}` workspace switches. Every one of these will intercept keystrokes that would otherwise reach your terminal.

**Action:** Since you use `macos-option-as-alt = true`, consider prefixing skhd bindings with a modifier that doesn't clash, like `ctrl+alt` for all single-alt bindings. Or selectively disable skhd interception for Ghostty.

### 11. Yazi `g+s` (lazygit) vs Default `g+s`

Yazi's default keymap uses `g` as a "go-to" prefix. Your custom `g+s` for lazygit works but occupies a slot in that namespace. This is fine as long as you're aware the default `g+s` (if any) is overridden.

---

## Performance & Startup Improvements

### 12. Replace `thefuck` with `pay-respects`

`thefuck` is written in Python, barely maintained, and adds ~150ms+ to shell startup because it needs to evaluate its alias on every new shell. `pay-respects` is a Rust replacement that starts in ~3ms, uses 1.8MB RAM vs 36MB, supports Fish natively, and has AI-assisted suggestions.

**Action:** `cargo install pay-respects` or `brew install pay-respects`, then replace the thefuck block in config.fish.

### 13. Fish Startup Has Six `| source` Pipelines

Every new Fish shell runs: `fzf --fish | source`, `fnm env | source`, `thefuck --alias | source`, `zoxide init fish | source`, and `direnv hook fish | source`. Each one spawns a subprocess and pipes output. While the `command -q` guards are good, this adds up.

**Optimization options:**
- Cache the output of static initializations. For example, `fnm env` output rarely changes. You could cache it to a file and source the file, regenerating only when fnm is updated.
- Move fzf, zoxide, and direnv initialization to `conf.d/` files so they're loaded once at shell init rather than on every config reload.
- Replace thefuck entirely (see point 12).

### 14. Ghostty Scrollback is Low

You have `scrollback-limit = 10000`. For a power user running builds, logs, and long commands, this will fill up quickly. Ghostty handles large scrollback efficiently.

**Action:** Bump to `scrollback-limit = 100000` or even higher. Memory cost is negligible.

---

## Missing Opportunities

### 15. Ghostty Can Replace Some tmux Functionality

You're using Ghostty which has native splits, tabs, and working directory inheritance, but you're still using tmux for everything. For local development, Ghostty's built-in multiplexing is faster and more native-feeling. tmux is still necessary for remote sessions (SSH detach/reattach) and session persistence, but for local splits and tabs, you could simplify.

This isn't "drop tmux" but rather "use Ghostty splits for quick local work, tmux for persistent sessions."

### 16. Yazi Plugins Are Outdated (Pinned to rev 1962818)

All your Yazi plugins are pinned to the same commit hash. Yazi moves fast and plugins need to match the installed version. Consider running `ya pkg upgrade` regularly.

Also missing useful plugins worth evaluating:
- **smart-filter.yazi** for fuzzy filtering inside Yazi
- **bookmarks.yazi** or **whoosh.yazi** for persistent bookmarks
- **mediainfo.yazi** for richer media file previews
- **ouch.yazi** for better archive handling

### 17. No `direnv` in Brewfile

You source `direnv hook fish` in config.fish but `direnv` isn't in your Brewfile. If you rebuild from the Brewfile, direnv won't be installed.

**Action:** Add `brew "direnv"` to your Brewfile.

### 18. Tmux Resurrect Doesn't Save Neovim Sessions

You have `@resurrect-capture-pane-contents 'on'` but you're missing `@resurrect-strategy-nvim 'session'` which would restore Neovim sessions inside tmux panes. Since you're a heavy Neovim user, this is a missed opportunity.

**Action:** Add to tmux.conf:
```
set -g @resurrect-strategy-nvim 'session'
```

### 19. Missing `dragon` from Brewfile

Your Yazi keymap uses `dragon -x -i -T` for drag-and-drop but `dragon` isn't in your Brewfile.

### 20. `ship-it` Alias is Dangerous

```fish
abbr -a ship-it 'git push --force origin main:production'
```
A force push to production from main with a cute abbreviation name. This is one typo away from disaster. At minimum, use `--force-with-lease` instead of `--force`.

### 21. FZF Colors Don't Match Nebula Theme

Your FZF colors use a different palette (`#011628` background, `#CBE0F0` foreground) than your Nebula theme (`#0D0F1E` background, `#CDD6F4` foreground). It's close but not consistent. Minor, but given the effort you put into theme consistency everywhere else, worth aligning.

### 22. `python@3.12` AND `python@3.13` in Brewfile

Both versions are installed. Unless you specifically need 3.12 for compatibility, this is unnecessary duplication.

---

## Summary of Priority Actions

**Do Now (5 minutes each):**
1. Fix hardcoded paths in config.fish (point 3)
2. Change `ship-it` to use `--force-with-lease` (point 20)
3. Remove OMF: `omf destroy` and delete `~/.config/omf/` (point 2)
4. Remove unused tmux theme plugins (point 4)
5. Bump Ghostty scrollback to 100000 (point 14)

**Do This Week:**
6. Replace neofetch with fastfetch (point 1)
7. Replace thefuck with pay-respects (point 12)
8. Clean up double git abbreviations (point 6)
9. Fix skhd alt-key conflicts with Ghostty (point 10)
10. Add missing Brewfile entries: direnv, dragon (points 17, 19)

**Evaluate When You Have Time:**
11. AeroSpace vs yabai+skhd+borders (point 5)
12. Yazi plugin upgrades (point 16)
13. Fish startup caching (point 13)
14. Ghostty as local multiplexer (point 15)
