# Antigravity / VSCode / Cursor / Windsurf - Sunset Pool Splash

Extension de theme standard de VSCode. Funciona identico en:
- Antigravity
- VSCode
- Cursor
- Windsurf
- VSCodium
- Code-server (en el browser)

## Instalacion rapida (desarrollo local)

1. Link o copia esta carpeta a la ubicacion de extensions del editor:

   ```fish
   # Antigravity - la ruta exacta puede variar, revisa la app
   ln -s ~/.config/antigravity-theme ~/.antigravity/extensions/sunset-pool-splash-1.0.0

   # VSCode
   ln -s ~/.config/antigravity-theme ~/.vscode/extensions/sunset-pool-splash-1.0.0

   # Cursor
   ln -s ~/.config/antigravity-theme ~/.cursor/extensions/sunset-pool-splash-1.0.0

   # Windsurf
   ln -s ~/.config/antigravity-theme ~/.windsurf/extensions/sunset-pool-splash-1.0.0
   ```

2. Reinicia el editor completo (Cmd+Q, no basta recargar la ventana - el extension host cachea
   los manifests).

3. `Cmd+Shift+P` → "Preferences: Color Theme" → "Sunset Pool Splash".

## Instalacion como .vsix empaquetado

Si prefieres un artefacto portable:

```fish
cd ~/.config/antigravity-theme
npm install -g @vscode/vsce
vsce package --skip-license --no-dependencies
# Genera sunset-pool-splash-1.0.0.vsix
```

Luego en el editor: `Cmd+Shift+P` → "Extensions: Install from VSIX..." → selecciona el .vsix.

## Que cubre

- `colors`: chrome completo del editor (activity bar, sidebar, tabs, status bar, terminal
  integrado ANSI, minimap, peek view, notifications, debug toolbar, git decorations).
- `tokenColors`: syntax tradicional (TextMate grammars).
- `semanticTokenColors`: LSP semantic highlighting con overrides para `class`, `variable.
  defaultLibrary`, `macro`, `decorator` y modificadores `*.readonly` / `*.deprecated`.

## Decisiones especificas

- Git gutter: added turquoise_hi, modified gold, deleted magenta. Mismo mapping que nvim
  gitsigns y los gitDecoration resources de la sidebar.
- Bracket pair colorization: ciclo de 6 colores warm→cool→warm (magenta, turquoise_hi, gold,
  tangerine, aqua, magenta_hi). No es monochrome - con TS/JSX anidado ayuda mucho.
- Type `vs interface` `vs enum`: todos en aqua. Semanticamente son "estructura de tipos", no
  los separo por tono. Si lo odias, cambia `semanticTokenColors.interface` a `#FF8A3D`.
- `variable.defaultLibrary` en peach en vez de rosegold: asi `console`, `document`, `window`
  resaltan sobre tus propias variables sin gritar.
- Terminal integrado ANSI idéntico a Ghostty y Zed. Mantiene la regla red+magenta=eje rosa /
  blue+cyan=eje turquesa.

## Pitfalls

- Si Antigravity no muestra el theme tras el symlink, probablemente el directorio de
  extensions es distinto. Busca en `~/Library/Application Support/Antigravity/User/` o
  revisa "Extensions: Show Extensions Folder" desde el command palette.
- Cursor a veces sobrescribe `editor.background` con su AI chat panel. Eso no es este theme,
  es Cursor en Settings → Appearance → "AI Panel Background". Si te choca, matchea al
  `sideBar.background` (#160820).
- VSCode 1.75+ requiere `"semanticHighlighting": true` en el theme para que los semantic
  colors se vean. Ya esta activado en este JSON.
