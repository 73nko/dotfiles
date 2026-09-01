# Zed — Glacier Signal

The theme file is already in Zed's XDG theme directory at
`~/.config/zed/themes/glacier-signal.json`. Zed discovers the file, but selecting
the theme is a manual GUI step. The repository checker validates the tracked
JSON and active reference; it cannot inspect Zed's live state.

## Activate

1. Launch Zed.
2. Open the command palette with `Cmd+Shift+P`.
3. Run **theme selector: toggle**.
4. Select **Glacier Signal**.

The tracked `zed/settings.json` also activates it as `"theme": "Glacier Signal"`.

## Semantic mapping

- Editor and terminal background: night `#062230`.
- Raised elements: fjord `#0d3547`; active tabs and elements: branch
  `#214c5e`.
- Primary text: snow `#f3faf7`; focus and links: ice `#7fe0ff`.
- Keywords: signal `#22b8f5`; titles: glow `#a8ecff`; functions: mint
  `#5ff2cf`; constants and numbers: frost `#e0fbff`.
- Errors and deletions: coral `#ff7a6e`; warnings and modifications: gold
  `#ffd873`; success and additions: green `#8fdc8f`.
- Information uses teal `#5ff2cf`; hints and blue terminal slots use azure
  `#b8f1ff`.

If Zed rejects an edited theme, run `zed --log` and inspect the JSON parse or
schema error; Zed may otherwise fall back to its default theme.
