# Violet Hour

Violet Hour, in its Glacier Signal variant (2026-07), is the active palette across the public configuration. The
canonical contract lives in `themes/violet-hour.json`; `scripts/check-theme.sh`
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
| indigo | `#0d3547` | raised surfaces |
| panel | `#113e51` | elevated panels and borders |
| branch | `#214c5e` | active surfaces and borders |
| selection | `#0f526f` | selected search surface |
| muted | `#839b9e` | comments and inactive text |
| star | `#f3faf7` | primary text |
| orchid | `#22b8f5` | primary identity accent |
| lilac | `#a8ecff` | secondary violet accent |
| rose | `#5ff2cf` | warm violet accent |
| bloom | `#e0fbff` | strongest highlight |
| periwinkle | `#5f9bd8` | cool accent |
| ice | `#7fe0ff` | focus and active state |
| coral | `#ff7a6e` | errors and destructive state |
| gold | `#ffd873` | warnings and attention |
| green | `#8fdc8f` | success and added state |
| teal | `#5ff2cf` | information and cyan state |
| azure | `#b8f1ff` | links and blue state |

## Tracked consumers

- Neovim: `nvim/lua/alex/themes/violet-hour.lua`
- Ghostty: `ghostty/config`
- tmux: `tmux/tmux.conf`
- Fish and Tide: `fish/config.fish` and
  `fish/conf.d/violet-hour-tide.fish`
- Yazi: `yazi/flavors/violet-hour.yazi/flavor.toml` and `yazi/theme.toml`
- bat and delta: `bat/themes/Violet Hour.tmTheme`, `bat/config`, and `git/config`
- btop, SketchyBar, and lazygit: `btop/`, `sketchybar/`, and
  `lazygit/config.yml`
- JankyBorders: `borders/bordersrc`
- Slack: `Styles/violet-hour-slack-theme.txt`
- Chrome, Raycast, and Zed: `chrome-theme/`, `raycast/violet-hour.json`, and
  `zed/themes/violet-hour.json`

Some tools require duplicated literal colors because their formats cannot
reference a shared palette. The palette contract and checker make that
duplication explicit and catch drift.

## Apply and verify

Chrome and Raycast require manual import, Zed requires manual theme selection,
and Slack requires manual application using the paste string or slot values in
`Styles/violet-hour-slack-theme.txt`. Follow each consumer's tracked
instructions. The checker validates repository files and configured references
only; it cannot inspect or change live GUI state.

Run the static theme check from the repository root:

```sh
bash scripts/check-theme.sh "$PWD"
```

The setup script rebuilds bat's theme cache and applies the macOS visual layer.
GUI application imports remain a manual per-machine step.
