# dotfiles

Full macOS config: fish, nvim, tmux, ghostty, yazi, AeroSpace, sketchybar, and
the Violet Hour Glass visual layer. Everything converges with ONE command.

(README rewritten 2026-06: the previous one was the auto-generated dotfyle
version, only covered nvim and described plugins that no longer exist.)

## Replicating on a fresh Mac

```sh
# 1. Clone INTO ~/.config (the repo IS the XDG config dir)
git clone git@github.com:YOUR-USER/dotfiles.git ~/.config

# 2. Converge the machine (installs Xcode CLT, brew, the full Brewfile,
#    rustup, fish as shell, fisher, mise, tmux/yazi plugins, theme,
#    macOS defaults, services). Idempotent: re-running = everything SKIPs.
bash ~/.config/scripts/setup.sh
```

`setup.sh` is the single orchestration entry point. Subcommands:

```sh
setup.sh            # converge (= sync)
setup.sh doctor     # health check, touches nothing
setup.sh export     # re-export the Brewfile (filters .brewfile-exclude)
setup.sh --upgrade  # sync + upgrade of existing packages
```

From fish, shortcuts are `up-mac` (sync) and `mac-doctor`.

## Manual steps (once per machine)

Things that require login or permissions macOS won't automate:

1. `gh auth login` and re-run setup.sh (installs the gh extensions).
2. nvim: open, let lazy/mason install, and `:LspCopilotSignIn`
   (ghost text + NES via sidekick.nvim, GitHub account).
3. 1Password: sign in. Shell secrets: `~/.secrets.fish`
   (NOT versioned; migration to `op run` pending).
4. macOS permissions: Screen Recording for sketchybar, Accessibility for
   AeroSpace, Calendar for icalBuddy. macOS resets these after some updates;
   `setup.sh doctor` reminds you.
5. `atuin login` if you want history sync across machines.

## Where each thing lives

| Layer | File(s) |
| --- | --- |
| Packages (brew/cask/mas) | `.Brewfile` (+ `.brewfile-exclude` for the export) |
| Toolchains (node/go/python/java/deno/pnpm + go/cargo/pipx tools) | `mise/config.toml` |
| Rust | rustup (deliberately outside mise) |
| Shell | `fish/` (plugins in `fish_plugins`, fisher's source of truth) |
| Editor | `nvim/` (lazy.nvim; cheatsheet at `nvim/cheatsheet.md`, `ncheat`) |
| Multiplexer | `tmux/tmux.conf` (TPM; tpm/smart-splits/sessionx, nothing else) |
| Terminal | `ghostty/config` |
| File manager | `yazi/` |
| Window manager | `aerospace/`, `borders/`, `sketchybar/` |
| macOS defaults | `scripts/macos-tweaks.sh` (reversible with `-revert`) |
| Visual layer | `scripts/macos-violet-hour.sh`, `wallpapers/`, `Styles/` |

Repo principle: each value lives in ONE place. setup.sh never duplicates
config, it only converges against these files.

## Audits

Recent state and decisions are documented in `CONFIG-AUDIT-2026-06.md` and
`nvim/AUDIT-PLUGINS-2026-06.md`.

## Personal layer (`personal/`)

The `personal/` directory is gitignored except for its README. It contains
what should not be published: tmux session-specific abbrs, bindings for
private GitHub orgs, internal tools, work monorepo paths.

Public files perform conditional `source` over this layer:

- `fish/config.fish` loads `personal/fish/*.fish` if the directory exists
- `tmux/tmux.conf` loads `personal/tmux/*.conf` the same way
- `gh-dash/config.yml` uses `YOUR-ORG` placeholders you replace in your own
  copy (or in a private fork you use locally)

To replicate the mechanism in your fork, create the `personal/` tree with
your own files. See `personal/README.md` for details.

## Themes

The custom themes (Sunset Pool Splash and Violet Hour) are documented in
`docs/themes.md`, with hex palette, visual philosophy, and files where
they are applied.

## Credits

This dotfiles integrates the following projects. Each has its own license;
check the corresponding repo if you derive from it.

- [Neovim](https://neovim.io) + lazy.nvim and snacks.nvim ecosystem
  (folke), blink.cmp (saghen), gitsigns (lewis6991), treesitter, LSP,
  nvim-dap, neotest, harpoon, auto-session.
- [fish shell](https://fishshell.com) + fisher (jorgebucaran),
  tide (IlanCosman), plugin-git (jhillyerd).
- [tmux](https://github.com/tmux/tmux) + TPM, resurrect, continuum,
  sessionx, smart-splits.
- [Ghostty](https://ghostty.org).
- [yazi](https://github.com/sxyazi/yazi) + full-border, git, chmod,
  max-preview, smart-enter, smart-filter, bookmarks.
- [sketchybar](https://github.com/FelixKratz/SketchyBar) + [borders](https://github.com/FelixKratz/JankyBorders).
- [AeroSpace](https://github.com/nikitabobko/AeroSpace).
- [charmbracelet/glow](https://github.com/charmbracelet/glow),
  [lazygit](https://github.com/jesseduffield/lazygit),
  [gh-dash](https://github.com/dlvhdr/gh-dash),
  [delta](https://github.com/dandavison/delta),
  [atuin](https://atuin.sh),
  [zoxide](https://github.com/ajeetdsouza/zoxide),
  [fzf](https://github.com/junegunn/fzf),
  [mise](https://mise.jdx.dev).

## License

MIT. See `LICENSE`. Fork freely, adapt whatever you need. A star on the
repo is appreciated but not required.
