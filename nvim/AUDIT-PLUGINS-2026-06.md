# Auditoría plugin por plugin · Junio 2026

37 plugins + core. Veredicto por plugin, estado del ecosistema y hallazgos de keymaps.
Leyenda: OK = mejor versión posible hoy. FIX = corregir. EVAL = decisión de gusto.

## Core e infraestructura

| Plugin | Veredicto | Notas |
|---|---|---|
| lazy.nvim | OK | checker activo sin notify, change_detection silencioso. Correcto. |
| plenary.nvim | OK | Solo dependencia. |
| snacks.nvim | OK | Uso extenso y bien razonado (dashboard, picker, explorer, indent, zen...). Pendiente: `image = { enabled = false }` por bug con la API de treesitter de 0.12. Snacks itera rápido: reintentar tras cada `:Lazy update` hasta que funcione. |
| which-key v3 | FIX | Falta el grupo `<leader>C` (crates, nuevo de hoy). El grupo `<leader>w` "workspace/session" provoca el shadow del save (ver Keymaps). |

## LSP y completion

| Plugin | Veredicto | Notas |
|---|---|---|
| nvim-lspconfig | OK | Patrón vim.lsp.config/enable nativo de 0.12. Estado del arte, nada que tocar. |
| mason (mason-org) | OK | Migrado hoy a la org nueva. |
| blink.cmp 1.x | EVAL | Actual y correcto. Único punto: `auto_brackets` activado conviviendo con nvim-autopairs (ver abajo). |
| lazydev | OK | Config mínima correcta con la library de snacks. |
| schemastore | OK | jsonls + yamlls con schemas. taplo añadido hoy cubre TOML. |
| nvim-lsp-file-operations | FIX (eliminar) | Solo se integra con nvim-tree/neo-tree, que no usas. Con Snacks explorer no hace NADA: peso muerto desde que migraste de nvim-tree. Snacks `rename` (que ya tienes activado) cubre el rename LSP-aware en su explorer. |

## Edición

| Plugin | Veredicto | Notas |
|---|---|---|
| nvim-autopairs | EVAL | Mantenido y correcto, con check_ts. Solapa parcialmente con blink `auto_brackets`: autopairs cierra al TECLEAR, blink al ACEPTAR una función del menú. Pueden convivir, pero si alguna vez ves `(())` tras aceptar un completion, este es el motivo. Recomendación: desactivar `auto_brackets` de blink y dejar que autopairs sea el único dueño de los brackets. |
| nvim-surround | OK | version="*", config por defecto. |
| substitute.nvim | OK | Pisa `s`/`S` nativos a propósito (gr-style substitute). Coherente con tu flujo documentado. |
| ts-context-commentstring | OK | Hook al gc nativo, sin Comment.nvim. Patrón moderno exacto. |
| nvim-ts-autotag | OK | |
| nvim-treesitter (main) | OK | Branch main con install programático e incremental selection manual sobre 0.12. Por delante de la curva; la mayoría sigue en master congelado. |
| nvim-treesitter-textobjects (main) | OK | API nueva. Cobertura de textobjects excelente (assignments, properties, params, calls...). |
| treesitter-context | OK | max_lines 3, toggle en `<leader>ut`. |

## UI

| Plugin | Veredicto | Notas |
|---|---|---|
| lualine | OK | En modo mantenimiento upstream pero estable y ubicuo. Migrar a heirline/mini.statusline sería churn sin ganancia. Tu theme custom está bien hecho. |
| bufferline | FIX | `<leader>bc` usa `:bd` pelado, que destruye el layout de ventanas. Tienes Snacks.bufdelete (preserva layout) y lo usas en `<leader>bd`. Incoherencia: dos maneras de cerrar buffer con comportamiento distinto. Unificar a Snacks.bufdelete. |
| nvim-colorizer.lua | FIX | Apuntas a `NvChad/nvim-colorizer.lua`; el repo vive ahora en `catgoose/nvim-colorizer.lua` (NvChad redirige). Actualizar el spec antes de que el redirect muera. |
| render-markdown | OK | |
| aerial | OK (cosmético) | Tiene `opts = {}` Y `config = function()`: lazy ignora opts cuando hay config. Borrar el opts redundante. `[a`/`]a` para símbolos preservando `{`/`}` nativos: bien resuelto. |
| violet-hour (tema custom) | OK | El truco del dummy spec con priority 1000 es legítimo. smart-splits viviendo dentro de colorscheme.lua es confuso: muévelo a su propio fichero cuando toque (cosmético). |

## Git

| Plugin | Veredicto | Notas |
|---|---|---|
| gitsigns | FIX (suave) | `next_hunk`/`prev_hunk` y `undo_stage_hunk` están deprecados upstream. Migrar a `nav_hunk("next"/"prev")` y al toggle de `stage_hunk` (stage sobre hunk staged = unstage). Funciona hoy, avisará mañana. |
| diffview | OK (vigilar) | Mantenimiento upstream casi parado desde 2024, pero estable y sin reemplazo equivalente. Mantener hasta que duela. |
| lazygit.nvim (kdheepak) | FIX (eliminar) | Lo tienes por TRIPLICADO: este plugin (`<leader>lg`), Snacks.lazygit (módulo ya disponible en un plugin que ya cargas) y el popup de tmux (prefix+g). El plugin de kdheepak es el más viejo de los tres. Eliminarlo y mapear `<leader>lg` a `Snacks.lazygit()`: misma UX, un plugin menos. |
| snacks git pickers | OK | blame, log, status, branches. |

## Navegación

| Plugin | Veredicto | Notas |
|---|---|---|
| harpoon2 | OK (vigilar) | Mantenimiento esporádico upstream pero estable. Las alternativas (grapple, arrow) no son claramente mejores. No tocar lo que funciona en memoria muscular. |
| grug-far | OK | Activo y excelente. |
| smart-splits | OK | Integración tmux correcta. Nota: `<C-c>` mapeado a cerrar ventana pisa el Ctrl-C nativo (cancelar comando pendiente). Riesgo de cierre accidental; valora si lo usas de verdad. |

## Sesiones

| Plugin | Veredicto | Notas |
|---|---|---|
| auto-session | OK | auto_restore=false deliberado con restore desde dashboard. Mantenido. La alternativa folke/persistence no aporta nada que no tengas. |

## Lint, formato, debug, test

| Plugin | Veredicto | Notas |
|---|---|---|
| conform | OK | format_after_save razonado y documentado. |
| nvim-lint | OK | Tras quitar eslint_d hoy, sin solapamientos. |
| nvim-dap (+ui, virtual-text, go, python) | OK | Adapter pwa-node nativo desde hoy. |
| neotest | OK | |
| neotest-go | FIX (reemplazar) | El propio ecosistema lo da por superado: su autor de facto recomienda `fredrikaverpil/neotest-golang` (parsing por AST, table tests, monorepos, integración dap-go y gotestsum, que ya instalas via Brewfile). Es EL adapter de Go en 2026 y requiere treesitter main, que ya usas. |
| neotest-jest / neotest-vitest | OK | Repo correcto desde hoy + pnpm dinámico. |
| rustaceanvim v9 + crates.nvim | OK | Estado del arte tras lo de hoy. |

## AI

| Plugin | Veredicto | Notas |
|---|---|---|
| neocodeium | ELIMINADO (2026-06) | Sustituido por sidekick.nvim + Copilot LSP (ghost text nativo 0.12). El free tier de Windsurf era el mismo patron de riesgo que supermaven. |
| sidekick.nvim | OK | NES + CLIs (claude/opencode) con persistencia tmux. Login: :LspCopilotSignIn. |
| package-info | OK (vigilar) | Mantenimiento lento upstream pero función única y sin reemplazo. |

## Hallazgos de keymaps

### Shadows con espera (el coste invisible)
Cuando un mapping es prefijo de otro, vim espera `timeoutlen` (300ms) antes de ejecutar el corto. Tienes dos:

1. `<leader>w` (guardar, usado decenas de veces al dia) espera 300ms por culpa de `<leader>wr`/`<leader>ws` (sesiones, usados una vez al dia). El keymap mas frecuente de todo el setup paga impuesto por el menos frecuente. Fix propuesto: sesiones a `<leader>Sr`/`<leader>Ss` (prefijo `<leader>S` libre) y `<leader>w` queda instantaneo.
2. `<leader>l` (lint manual) espera por `<leader>lg` (lazygit). Menor: lint corre solo por autocmd y el trigger manual es raro. Se acepta.

### Overrides de nativos (deliberados, documentados aqui para que sean decision y no accidente)
- `s`/`S` → substitute.nvim (pierdes substitute-char nativo; `cl` lo reemplaza)
- `-`/`|` → splits (pierdes line-up nativo en `-`)
- `gw` → toggle wrap (pierdes el format-motion nativo `gw`)
- `<C-c>` → cerrar ventana (pierdes cancel nativo)
- `{`/`}` preservados (aerial movido a `[a`/`]a`)

### Muertos o incoherentes
- `<leader>ag` (Gemini) → corregido hoy a `<leader>ao` (opencode)
- bufferline `<leader>bc` con `:bd` vs snacks `<leader>bd` → unificar
- Falta grupo which-key para `<leader>C` (crates)

## Resumen de acciones

| # | Accion | Tipo |
|---|---|---|
| 1 | neotest-go → neotest-golang | FIX |
| 2 | colorizer → catgoose/nvim-colorizer.lua | FIX |
| 3 | Eliminar lazygit.nvim, `<leader>lg` → Snacks.lazygit() | FIX |
| 4 | Eliminar nvim-lsp-file-operations | FIX |
| 5 | bufferline `<leader>bc` → Snacks.bufdelete() | FIX |
| 6 | gitsigns: nav_hunk + stage toggle (APIs no deprecadas) | FIX |
| 7 | which-key: grupo `<leader>C` crates | FIX |
| 8 | aerial: borrar opts redundante | FIX |
| 9 | Sesiones a `<leader>S*` para save instantaneo | EVAL (memoria muscular) |
| 10 | Desactivar blink auto_brackets (autopairs único dueño) | EVAL |
| 11 | Reintentar snacks image tras updates | Recordatorio |
| 12 | `<C-c>` cerrar ventana: ¿lo usas? Si no, eliminar | EVAL |
