# Glacier Signal

Glacier Signal is the active palette across the public configuration. The
canonical contract lives in `themes/glacier-signal.json`; `scripts/check-theme.sh`
uses it to detect missing consumers, inactive references, legacy colors, and
semantic color drift.

For structured JSON consumers, the `semantic` contract performs exact semantic
checks: each dotted field path must resolve to its assigned palette color. It
supports numeric array indices, `#RRGGBB` strings with optional alpha, and RGB
arrays. The `required` contract performs presence checks for unstructured
consumers; presence checks do not prove which setting uses each color.

## Canonical semantic palette

| Name | Hex | Role |
| --- | --- | --- |
| abyss | `#04141c` | deepest terminal surface |
| night | `#062230` | primary background |
| fjord | `#0d3547` | raised blue-green surfaces |
| panel | `#113e51` | elevated panels and borders |
| branch | `#214c5e` | active surfaces and borders |
| selection | `#0f526f` | selected search surface |
| muted | `#839b9e` | comments and inactive text |
| snow | `#f3faf7` | primary frost text |
| signal | `#22b8f5` | primary cyan identity accent |
| glow | `#a8ecff` | bright cyan accent |
| mint | `#5ff2cf` | cursor and interactive accent |
| frost | `#e0fbff` | strongest cool highlight |
| steel | `#5f9bd8` | subdued blue structure |
| ice | `#7fe0ff` | focus and active state |
| coral | `#ff7a6e` | errors and destructive state |
| gold | `#ffd873` | warnings and attention |
| green | `#8fdc8f` | success and added state |
| teal | `#5ff2cf` | semantic alias for information state |
| azure | `#b8f1ff` | links and blue state |

## Tracked consumers

- Neovim: `nvim/lua/alex/themes/glacier-signal.lua`
- Ghostty: `ghostty/config`
- tmux: `tmux/tmux.conf`
- Fish and Tide: `fish/config.fish` and
  `fish/conf.d/glacier-signal-tide.fish`
- Yazi: `yazi/flavors/glacier-signal.yazi/flavor.toml` and `yazi/theme.toml`
- bat and delta: `bat/themes/Glacier Signal.tmTheme`, `bat/config`, and `git/config`
- btop, SketchyBar, and lazygit: `btop/`, `sketchybar/`, and
  `lazygit/config.yml`
- JankyBorders: `borders/bordersrc`
- Slack: `Styles/glacier-signal-slack-theme.txt`
- Chrome, Raycast, and Zed: `chrome-theme/`, `raycast/glacier-signal.json`, and
  `zed/themes/glacier-signal.json`

Some tools require duplicated literal colors because their formats cannot
reference a shared palette. The palette contract and checker make that
duplication explicit and catch drift.

The supplied wallpaper lives at
`personal/assets/wallpapers/glacier-signal-source.jpg` in the private layer.
`scripts/generate_wallpaper.py` derives ignored per-display crops and the Chrome
new-tab image, keeping third-party artwork out of the public repository.

## Apply and verify

Chrome and Raycast require manual import, Zed requires manual theme selection,
and Slack requires manual application using the paste string or slot values in
`Styles/glacier-signal-slack-theme.txt`. Follow each consumer's tracked
instructions. The checker validates repository files and configured references
only; it cannot inspect or change live GUI state.

Run the static theme check from the repository root:

```sh
bash scripts/check-theme.sh "$PWD"
```

The setup script rebuilds bat's theme cache, generates local wallpaper assets,
and applies the safe macOS visual layer: wallpaper and the closest system accent.
Pointer colors are intentionally manual because their protected preferences are
not a stable scripting interface. Use fill `22B8F5` and outline `F3FAF7` in
System Settings > Accessibility > Display > Pointer.
GUI application imports remain a manual per-machine step.
