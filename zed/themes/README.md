# Zed — Violet Hour · Glass

The theme file is already in Zed's XDG theme directory at
`~/.config/zed/themes/violet-hour.json`. Zed discovers the file, but selecting
the theme is a manual GUI step. The repository checker validates the tracked
JSON and active reference; it cannot inspect Zed's live state.

## Activate

1. Launch Zed.
2. Open the command palette with `Cmd+Shift+P`.
3. Run **theme selector: toggle**.
4. Select **Violet Hour**.

The tracked `zed/settings.json` also activates it as `"theme": "Violet Hour"`.

## Semantic mapping

- Editor and terminal background: night `#0D0D2C`.
- Raised elements: indigo `#1A1745`; active tabs and elements: branch
  `#2F365A`.
- Primary text: star `#ECE6FF`; focus and links: ice `#A8C9FF`.
- Keywords: orchid `#B39DFF`; titles: lilac `#D6C8FF`; functions: rose
  `#E2BCFF`; constants and numbers: bloom `#F0D2FF`.
- Errors and deletions: coral `#FF9E9E`; warnings and modifications: gold
  `#FFCF7A`; success and additions: green `#9EE87F`.
- Information uses teal `#5FE0C8`; hints and blue terminal slots use azure
  `#7FB0FF`.

If Zed rejects an edited theme, run `zed --log` and inspect the JSON parse or
schema error; Zed may otherwise fall back to its default theme.
