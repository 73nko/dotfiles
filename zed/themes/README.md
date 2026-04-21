# Zed - Sunset Pool Splash

Este archivo vive donde Zed lo espera por defecto: `~/.config/zed/themes/`. Zed lo detecta al
arranque sin mas.

## Activar

1. Lanza Zed.
2. `Cmd+Shift+P` → "theme selector: toggle".
3. Escribe "Sunset Pool Splash" → Enter.
4. Queda persistido en tu `settings.json` como `"theme": "Sunset Pool Splash"`.

Alternativa via settings:
```json
{
  "theme": {
    "mode": "dark",
    "dark": "Sunset Pool Splash"
  }
}
```

## Decisiones de la paleta (por si quieres tocar)

- Keywords magenta, functions turquoise_hi, strings gold, numbers peach. Mismo mapeo que el
  nvim theme: asi el cerebro no hace context-switching al saltar entre Zed y Neovim.
- Active tab usa `#1F3E48` (branch_bg) en vez de plum. Turquoise tint marca el foco de la pane
  activa igual que en tmux.
- `players` 1-8 (multi-cursor / multiplayer): tangerine, turquoise_hi, gold, magenta, peach,
  aqua, magenta_hi, sunburn. Tu cursor principal (player 0) es tangerine.
- Comments usan `#3E9AA5` (aqua bajado) italic. Legibles pero no roban foco.
- ANSI terminal idéntico al ghostty config (red+magenta al eje rosa, blue+cyan al turquesa).
  Intencional: el terminal integrado de Zed se debe ver como Ghostty.

## Pitfall real

Zed valida el schema en cada carga. Si tocas el JSON y el parse falla, Zed cae a One Dark sin
avisar visualmente. Si un dia abres Zed y "desaparecio" el theme, ejecuta `zed --log` en una
terminal y mira stderr para el error de parse.
