# Violet Hour

Violet Hour is the active palette across the public configuration. The
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
| abyss | `#06061A` | deepest terminal surface |
| night | `#0D0D2C` | primary background |
| indigo | `#1A1745` | raised surfaces |
| panel | `#211E45` | elevated panels and borders |
| branch | `#2F365A` | active surfaces and borders |
| selection | `#322D5A` | selected search surface |
| muted | `#777494` | comments and inactive text |
| star | `#ECE6FF` | primary text |
| orchid | `#B39DFF` | primary identity accent |
| lilac | `#D6C8FF` | secondary violet accent |
| rose | `#E2BCFF` | warm violet accent |
| bloom | `#F0D2FF` | strongest highlight |
| periwinkle | `#8DA7FF` | cool accent |
| ice | `#A8C9FF` | focus and active state |
| coral | `#FF9E9E` | errors and destructive state |
| gold | `#FFCF7A` | warnings and attention |
| green | `#9EE87F` | success and added state |
| teal | `#5FE0C8` | information and cyan state |
| azure | `#7FB0FF` | links and blue state |

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
