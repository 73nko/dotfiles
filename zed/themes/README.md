# Zed - Violet Hour · Glass

Este archivo vive donde Zed lo espera por defecto: `~/.config/zed/themes/`. Zed lo detecta al
arranque sin mas.

## Activar

1. Lanza Zed.
2. `Cmd+Shift+P` → "theme selector: toggle".
3. Escribe "Violet Hour" → Enter.
4. Queda persistido en tu `settings.json` como `"theme": "Violet Hour"`.

Alternativa via settings:
```json
{
  "theme": {
    "mode": "dark",
    "dark": "Violet Hour"
  }
}
```

## Decisiones de la paleta (por si quieres tocar)

- Keywords orchid, functions rose-mist, strings ice, numbers bloom, types cyan-mist. Mismo
  mapeo que el nvim theme (violet-hour.lua): asi el cerebro no hace context-switching al
  saltar entre Zed y Neovim.
- Active tab usa `#2f365a` (branch_bg, ice @ 22%) en vez de indigo. El tint frio marca el
  foco de la pane activa igual que en tmux.
- `players` 1-8 (multi-cursor / multiplayer): orchid, ice, bloom, rose-mist, periwinkle,
  cyan-mist, lilac, horizon.
- Comments usan `#5b6b96` (ice @ 50%) italic. Legibles pero no roban foco.
- ANSI terminal idéntico al ghostty config (§07): red+magenta al eje violeta, blue+cyan al
  azul frio. Intencional: el terminal integrado de Zed se debe ver como Ghostty.

## Pitfall real

Zed valida el schema en cada carga. Si tocas el JSON y el parse falla, Zed cae a One Dark sin
avisar visualmente. Si un dia abres Zed y "desaparecio" el theme, ejecuta `zed --log` en una
terminal y mira stderr para el error de parse.
