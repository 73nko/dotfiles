# Zed - Violet Hour · Glass

This file lives where Zed expects it by default: `~/.config/zed/themes/`. Zed
detects it at startup, nothing extra needed.

## Activate

1. Launch Zed.
2. `Cmd+Shift+P` → "theme selector: toggle".
3. Type "Violet Hour" → Enter.
4. Persisted in your `settings.json` as `"theme": "Violet Hour"`.

Alternative via settings:
```json
{
  "theme": {
    "mode": "dark",
    "dark": "Violet Hour"
  }
}
```

## Palette decisions (in case you want to tweak)

- Keywords orchid, functions rose-mist, strings ice, numbers bloom, types
  cyan-mist. Same mapping as the nvim theme (violet-hour.lua): your brain
  doesn't context-switch when jumping between Zed and Neovim.
- Active tab uses `#2f365a` (branch_bg, ice @ 22%) instead of indigo. The
  cool tint marks the active pane focus the same way tmux does.
- `players` 1-8 (multi-cursor / multiplayer): orchid, ice, bloom, rose-mist,
  periwinkle, cyan-mist, lilac, horizon.
- Comments use `#5b6b96` (ice @ 50%) italic. Readable but they don't steal
  focus.
- ANSI terminal identical to the ghostty config (§07): red+magenta on the
  violet axis, blue+cyan on the cool blue axis. Intentional: Zed's
  integrated terminal should look like Ghostty.

## Real pitfall

Zed validates the schema on every load. If you edit the JSON and parsing
fails, Zed silently falls back to One Dark with no visual warning. If one
day you open Zed and the theme "disappeared", run `zed --log` in a terminal
and check stderr for the parse error.
