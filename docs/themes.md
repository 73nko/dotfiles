# Themes

Two custom palettes applied coherently across the whole stack (nvim, tmux,
fish, ghostty, yazi, sketchybar, glow, delta, fzf).

## Violet Hour

The current palette. Blue-night vibe leaning iridescent. Cool base with
violet accents and pink highlights over a night background.

### Palette

| Role | Hex | Usage |
|-----|-----|-------|
| bg | `#0d0d2c` | base background (dusk) |
| bg raised | `#1a1745` | elevated surfaces |
| bg elevated | `#211e45` | cursor line, matches |
| border | `#2f365a` | separators, pane borders |
| muted | `#777494` | comments, hidden files |
| blue | `#8da7ff` | functions, keyword types |
| light blue | `#a8c9ff` | params, italic |
| violet | `#b39dff` | primary accent, keywords |
| light violet | `#d6c8ff` | strings, muted headings |
| pink violet | `#e2bcff` | numbers, secondary |
| cream | `#ece6ff` | base text |
| pink highlight | `#f0d2ff` | strong, H1, bold |

### Where it applies

- **nvim:** `lua/alex/themes/violet-hour.lua` (full colorscheme with
  highlight groups for LSP, treesitter, snacks picker/explorer/dashboard,
  gitsigns, cmp/blink, diagnostics, etc.).
- **tmux:** `tmux/tmux.conf` in the Bar appearance section (status bar,
  borders, window states).
- **fish/tide:** `fish/conf.d/violet-hour-tide.fish` (prompt item colors:
  pwd, git, character, cmd_duration, context, plus layout seeding).
- **fish syntax:** `fish/config.fish` in the Neon Nocturne section (legacy
  name; now uses the Violet Hour palette).
- **ghostty:** `ghostty/config` palette 0-15 and background/foreground.
- **yazi:** `yazi/theme.toml` or `yazi/flavors/`.
- **sketchybar:** `sketchybar/colors.sh` variables `$BAR_COLOR`,
  `$PEACH`, `$MUTED`, `$MAGENTA_HI`, etc.
- **glow:** `glow/violet-hour.json` glamour style with full chroma for
  code blocks.
- **fzf:** `fish/config.fish` FZF section (`FZF_DEFAULT_OPTS`).
- **delta:** `git/config` `[delta]` section (references
  `syntax-theme Sunset Pool Splash` as chroma theme; update to Violet
  Hour when migrated).

### Philosophy

- Deep cool background (`#0d0d2c`) that doesn't tire the eye.
- A single warm accent (`#f0d2ff` pink highlight) for the important
  stuff: H1, bold, generic_deleted in diffs.
- Violet scale for emphasis gradients (violet → light violet →
  pink violet).
- Cool blues for semantic roles (functions, types) distinct from the
  violet series.
- Cream for base text, not pure white. Less glare.

## Sunset Pool Splash

Previous palette. Sunset-over-pool vibe, warm with cool accents. Still
referenced in some files for historical visual consistency.

### Palette

| Role | Hex | Usage |
|-----|-----|-------|
| dusk (bg) | `#1A0A28` | base background |
| plum (bg alt) | `#3A1550` | elevated surfaces |
| pane_border | `#331127` | warm separators |
| pane_active | `#2E5260` | active cool separators |
| branch_bg | `#1F3E48` | pool cool background |
| rosegold (fg) | `#FFC6A0` | base text |
| muted | `#A58670` | comments |
| magenta | `#FF3D8A` | warm high emphasis |
| magenta_hi | `#FFB8D5` | luminous accent |
| turquoise | `#4EC9D7` | cool primary |
| turquoise_hi | `#7FE0EB` | luminous cool |
| aqua | `#8FE3E8` | cool success |
| tangerine | `#FF8A3D` | warm warning |
| gold | `#FFD67A` | attention |
| cream | `#F5ECD7` | brightest |
| peach | `#FFB07A` | bright yellow slot |

### Where it applies

- **nvim:** `lua/alex/themes/sunset-pool.lua` (if present, deprecated in
  favor of violet-hour).
- **bat:** `Styles/Sunset Pool Splash.tmTheme` for syntax highlighting in
  `bat`, delta, less.
- Historical references in tmux status bar, sketchybar item colors, etc.,
  until migrated to Violet Hour.

### Philosophy

- Warm/cool contrast playing with the sunset metaphor (rosegold, magenta,
  tangerine) over pool splash (turquoise, aqua, cool blues).
- Every UI element lives on one of the two axes: never neutral dead colors.
- High readability over dusk background thanks to the rosegold base.

## Coordination between themes and UI

Rule when creating a new theme or migrating:

1. Define the hex palette in a single reference file (`colors.sh` in
   sketchybar, `M.colors` in the theme lua, `--color=` in fzf opts).
2. All consumers REFERENCE that palette, they never duplicate it.
3. Theme swap = edit the palette file, done; the rest of the UI follows.
4. Exception: ghostty and yazi don't support dynamic references and
   duplication is required. Accepted as a known cost.

These themes belong to this dotfiles. Fork, adapt, publish yours under
another name. There is no explicit palette licensing beyond the repo's
MIT license.
