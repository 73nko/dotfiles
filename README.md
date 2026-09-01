# dotfiles

Public, reusable macOS configuration for Fish, Neovim, tmux, Ghostty, Yazi,
AeroSpace, SketchyBar, daily developer tools, and the Glacier Signal visual layer.
The convergence script manages the reusable stack; account logins, macOS
permissions, and GUI theme activation remain manual.

## Replicate on a fresh Mac

Clone the repository as the XDG configuration directory, then converge the
machine:

```sh
git clone https://github.com/73nko/dotfiles.git ~/.config
bash ~/.config/scripts/setup.sh
```

The default sync installs missing declared dependencies and applies tracked
configuration. It is safe to rerun: existing Homebrew packages are not upgraded
unless requested. It preserves unrelated user tools plus private, application,
and account state.

The default sync may prompt for a missing Git name or email. It writes only Git
identity keys to `~/.gitconfig`; all other Git defaults remain in the tracked
XDG configuration.

The four setup commands are:

```sh
bash ~/.config/scripts/setup.sh            # sync the declared machine state
bash ~/.config/scripts/setup.sh doctor     # inspect health without changing config
bash ~/.config/scripts/setup.sh export     # regenerate .Brewfile; review its diff
bash ~/.config/scripts/setup.sh --upgrade  # sync and upgrade existing packages
```

For day-to-day cross-Mac updates, use:

```sh
bash ~/.config/scripts/sync-dotfiles.sh            # fast-forward pull + converge
bash ~/.config/scripts/sync-dotfiles.sh --upgrade  # pull + upgrade declared packages
```

The wrapper refuses to pull over local changes, updates an optional private
Git repository at `~/.config/personal`, and then runs the convergent setup.
From Fish, `up-mac` runs this full update and `mac-doctor` runs the doctor.

## Manual checklist

Complete the steps that require a login, consent, or an application UI:

1. Run `gh auth login`, then rerun setup so GitHub CLI extensions can install.
2. Open Neovim, let lazy.nvim and Mason finish, then run
   `:LspCopilotSignIn` if you use GitHub Copilot.
3. Sign in to 1Password and create `~/.secrets.fish` for any shell secrets; the
   file is intentionally not tracked.
4. Run `atuin login` only if you want cross-machine history sync.
5. Grant Screen Recording to SketchyBar, Accessibility to AeroSpace, and
   Calendar access to icalBuddy.
6. Load the Chrome theme, import the Raycast theme, select the Zed theme, and
   apply the Slack colors from `Styles/glacier-signal-slack-theme.txt` using the
   tracked instructions. Static checks validate the theme files; they cannot
   apply settings inside GUI applications.
7. For gh-dash, copy `gh-dash/config.yml.example` to the ignored
   `gh-dash/config.yml` and replace `YOUR-ORG` locally.
8. For Fastfetch, add an optional private logo as described in
   `personal/README.md`, or change its logo type to `auto`.
9. Set the Glacier Signal pointer colors in System Settings > Accessibility >
   Display > Pointer: fill `22B8F5`, outline `F3FAF7`. Setup applies the rest of
   the macOS visual layer, but deliberately never writes protected pointer
   preferences.

## Reproducible boundary

| Layer | Tracked source of truth |
| --- | --- |
| Homebrew packages and applications | `.Brewfile` and `.brewfile-exclude` |
| Toolchains and language tools | `mise/config.toml`; Rust uses rustup |
| Shell | `fish/` and `fish/fish_plugins` |
| Editor | `nvim/` |
| Multiplexer | `tmux/tmux.conf` |
| Terminal and file manager | `ghostty/` and `yazi/` |
| Git interfaces | `git/config`, `lazygit/config.yml`, `gh-dash/config.yml.example` |
| Window and status bar | `aerospace/`, `borders/`, and `sketchybar/` |
| macOS defaults | `scripts/macos-tweaks.sh` |
| Glacier Signal | `themes/glacier-signal.json`, tool configs, and GUI theme files |
| Static verification | `tests/*.sh`, `scripts/check-config.sh`, and `scripts/check-theme.sh` |

Lazygit uses its native XDG path at `~/.config/lazygit/config.yml`.
Manifest-owned generated dependencies are reconciled and may be installed,
updated, or purged: Fisher follows `fish/fish_plugins`, TPM follows
`tmux/tmux.conf`, and Yazi follows `yazi/package.toml`. Application data,
authentication state, caches, logs, Fish universal variables, and generated
completions are not tracked or treated as dependency manifests.

## personal/ is optional and privately managed

Public setup does not require private files. Fish and tmux expose generic
extension points that load `personal/fish/*.fish` and `personal/tmux/*.conf`
only when those files exist; Fastfetch's optional logo choice is covered in the
manual checklist. Setup does not download, generate, or require the personal
layer.

The recommended cross-Mac setup is a second, private Git repository cloned at
`~/.config/personal`. The public repository ignores that nested checkout, while
`sync-dotfiles.sh` updates it when present. Organization-specific Fish
abbreviations, private repository paths, internal tools, and the licensed
Glacier Signal source wallpaper belong there. See `personal/README.md` for the
one-time setup and manual-copy fallback.

## Themes

Glacier Signal is the active theme. Its canonical semantic palette, tracked
consumers, checker, and manual GUI activation steps are documented in
`docs/themes.md`.

## Credits

This repository integrates projects including:

- [Neovim](https://neovim.io) with lazy.nvim, Snacks, blink.cmp, Treesitter,
  LSP, DAP, Neotest, Harpoon, and auto-session.
- [Fish](https://fishshell.com) with Fisher, Tide, and plugin-git.
- [tmux](https://github.com/tmux/tmux) with TPM, smart-splits, and sessionx.
- [Ghostty](https://ghostty.org).
- [Yazi](https://yazi-rs.github.io) with full-border, git, chmod, toggle-pane,
  smart-enter, smart-filter, and bookmarks.
- [AeroSpace](https://github.com/nikitabobko/AeroSpace),
  [SketchyBar](https://github.com/FelixKratz/SketchyBar), and
  [JankyBorders](https://github.com/FelixKratz/JankyBorders).
- [lazygit](https://github.com/jesseduffield/lazygit),
  [gh-dash](https://github.com/dlvhdr/gh-dash),
  [delta](https://github.com/dandavison/delta),
  [Atuin](https://atuin.sh), [zoxide](https://github.com/ajeetdsouza/zoxide),
  [fzf](https://github.com/junegunn/fzf), and [mise](https://mise.jdx.dev).

## License

MIT. See `LICENSE`.
