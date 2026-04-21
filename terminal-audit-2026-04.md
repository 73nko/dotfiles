# Auditoría Terminal + Nvim, 21 de abril 2026

Autor: Claude (revisión adversarial, sin filtro).
Ámbito: ghostty, fish, tmux, yazi, nvim.
Foco: stack TS / React / Next / CSS, modernización 2026, colisiones, deuda.

---

## 0. Resumen ejecutivo sin anestesia

Tu setup está MUY por encima de la media. La auditoría de marzo te sirvió: migraste a `blink.cmp`, mataste Comment.nvim / lsp_signature / vim-illuminate / alpha-nvim / vim-fugitive, arreglaste las APIs deprecadas de `vim.loop`, `foldexpr`, `sign_define`, `goto_prev/next`, pasaste a `vim.lsp.config()` + `vim.lsp.enable()` (patrón correcto 0.11+), y limpiaste OMF y thefuck.

Pero te estás mintiendo si crees que está "terminado". Encontré hallazgos nuevos o pendientes. Dos son bugs silenciosos (plugin muerto referenciado, path hardcodeado en `dy.fish`), varios son redundancia cognitiva que te cuesta contexto mental cada vez que dudas qué keymap existe.

Nota de alcance: Tailwind no aplica a tu trabajo (confirmado por ti el 21/abril). Los diffs D4 y D19 (instalar `tailwindcss-language-server` y `tailwind-tools.nvim`) quedan descartados. No los apliques.

Prioridades honestas:

1. Arregla los dos bugs silenciosos, son dos minutos.
2. Mata nvim-tree. No mantienes dos exploradores de archivos. Estás pagando cost mental por indecisión.
3. Consolida duplicados LSP y unifica keymaps AI.
4. El resto son quality of life.

Tiempo total para hacer 1 a 4: entre 15 y 30 minutos.

---

## 1. Estado de las auditorías previas

Cosas hechas desde marzo y que ya no hay que discutir:

Fish: OMF eliminado, paths hardcodeados reemplazados por `$HOME` en `config.fish` (sigue vivo uno en `functions/dy.fish`, ver abajo), thefuck reemplazado por pay-respects, abbreviations limpias, ship-it peligroso eliminado, conf.d modular.

Tmux: resize con `H/J/K/L` en mayúscula, `@resurrect-strategy-nvim 'session'` activo, scrollback 100000 ya en ghostty, theme Neon Nocturne unificado.

Ghostty: scrollback aumentado, theme custom alineado con el resto.

Yazi: plugins modernos instalados (smart-enter, smart-filter, bookmarks, chmod, git, full-border).

Nvim: blink.cmp en producción, smart-splits con integración tmux, snacks dashboard, Comment.nvim muerto, alpha.lua muerto, vim-fugitive muerto, lsp_signature muerto, vim-illuminate muerto, APIs 0.11+ en uso. Tabs movidos a `<leader>T`, line-move movido a `<S-A-j>/<S-A-k>`, `<Esc>` limpia highlights.

**Pendientes explícitos de AUDIT.md nvim que NO se ejecutaron:**

- `nvim-tree` sigue vivo. La auditoría dijo literalmente "fully commit to snacks explorer or oil.nvim". Decidiste nada.
- Harpoon sigue en `<leader>m*`. Menor, pero documentado como confuso.
- `<leader>ca` (custom) + `gra` (default Neovim 0.11) son la misma code action, mapeados dos veces.
- `<leader>rn` (custom) + `grn` (default Neovim 0.11) son el mismo rename, mapeados dos veces.

---

## 2. Hallazgos nuevos

### CRÍTICO (romper o engañarte silenciosamente)

**C1. Dashboard "e" referencia plugin muerto (`snacks.lua:36`)**

```lua
{ icon = "󰙅 ", key = "e", desc = "File Exporer", action = ":lua require('ranger-nvim').open(true)" },
```

`ranger-nvim` NO está instalado (lo confirmé contra `lazy-lock.json`). Presionar `e` en el dashboard lanza un error `module 'ranger-nvim' not found`. Además la descripción tiene typo: "Exporer" en lugar de "Explorer". Corrige ambas cosas.

**C2. Path hardcodeado en `functions/dy.fish`**

```fish
java ... -Djava.library.path="$HOME/Library/Mobile Documents/com~apple~CloudDocs/dynamo/DynamoDBLocal_lib" ...
```

Mismo bug que arreglaste en `config.fish`. Si abres este dotfile en otra máquina o tu usuario cambia, esto revienta. Usa `$HOME`.

**C3. Plugin folder zombie en tmux: `tmux-neolazygit` y otros**

```
~/.config/tmux/plugins/
├── tmux-continuum      (usado)
├── tmux-neolazygit     (NO usado, reemplazado por display-popup en tmux.conf:64)
├── tmux-resurrect      (usado)
├── tmux-sessionx       (usado)
├── tpm                 (usado)
└── vim-tmux-navigator  (usado)
```

`tmux-neolazygit` ya no está en la lista de plugins de tu `tmux.conf`. Es basura en disco. La auditoría previa marcó tres plugins de tema muertos que ya limpiaste, pero este se quedó.

---

### ALTO (fricción real que pagas cada día)

**A1. ~~Tailwind LSP~~ — DESCARTADO**

No usas Tailwind en tu trabajo ni lo usarás (confirmado por ti). Hallazgo cerrado. Diff D4 y D19 inaplicables.

**A2. Redundancia file explorer: nvim-tree vs snacks.explorer**

`nvim-tree.lua` define `<leader>ee`, `<leader>ef`, `<leader>ec`, `<leader>er`. `snacks.lua` define `<leader>st` para `Snacks.explorer.reveal`. Dashboard botón `e` apunta a un tercer plugin muerto. Tres soluciones para el mismo problema. Elige una.

Recomendación: borrar `nvim-tree.lua`. Snacks explorer es moderno, se integra con el resto del ecosistema Snacks (picker, notifier, etc.) y ya está mapeado. Si te falta algún feature específico (git integration visible tipo árbol), `oil.nvim` es la alternativa moderna (edit as buffer), pero para UX tipo árbol lateral, snacks cubre el caso.

**A3. Keymaps LSP duplicados (`lspconfig.lua:161,164`)**

```lua
-- Defaults de Neovim 0.11+ ya existen:
--   gra -> code action
--   grn -> rename
-- Y tú defines ADEMÁS:
keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
```

Tres opciones:
- Mantén solo los defaults `gra`/`grn` y borra los customs. Tu memoria muscular se adapta en 2 semanas.
- Borra los defaults (no se puede, son built-in).
- Acepta la redundancia explícitamente.

Lo peor es dejarlo sin decisión. Tu auditoría de marzo ya señaló este tipo de duplicación en `gd/gR/gi/gt`.

**A4. Colisión sutil `<C-j>` (supermaven vs blink.cmp)**

```lua
-- supermaven.lua:10
accept_word = "<C-j>"

-- nvim-cmp.lua:30
["<C-j>"] = { "select_next", "fallback" }
```

Ambos se ejecutan en insert mode. Si el popup de blink está visible, blink gana. Si no, supermaven acepta palabra. El comportamiento es inconsistente según contexto, lo que es peor que no tener el atajo. Para tu flujo (Tab acepta blink o supermaven), `<C-j>` para "acepta una palabra de supermaven" es útil pero al chocar con blink select_next se vuelve impredecible. Mueve supermaven a `<C-;>`, `<M-l>`, o `<C-Right>`.

**A5. `auto-session` usa opción deprecada**

```lua
auto_session_suppress_dirs = { ... }
```

La API actual (desde hace unas releases) prefiere `suppressed_dirs`. Sigue funcionando por backward compat, pero está marcado como legacy. Actualiza.

**A6. `<leader>O` para Aerial está huérfano**

Único keymap top level con una sola letra mayúscula sin grupo. Se pierde en which-key. Muévelo a `<leader>co` (code outline) o `<leader>ao` si defines un grupo `<leader>a` = "aerial/AI".

---

### MEDIO (cruft que no duele hoy pero suma)

**M1. `supermaven.lua:11` filtra `"minifiles"`**

No usas mini.files. Este filtro es copy paste de otra config. Debería filtrar `snacks_dashboard` y posiblemente `snacks_picker_input`. Cambia la lista.

**M2. `aerial.lua:35` mantiene icono `Codeium = "󰘦 "`**

No usas Codeium. Usas Supermaven. Icon muerto.

**M3. `claude.lua` y `gemini.lua` abusan del plugin spec de snacks**

```lua
-- claude.lua
return {
  "folke/snacks.nvim",
  keys = { ... },
  init = function() vim.o.autoread = true end,
}
```

Registras el mismo plugin `folke/snacks.nvim` en tres archivos (snacks.lua, claude.lua, gemini.lua). Lazy los fusiona pero es frágil y confunde. Además `init = function() vim.o.autoread = true end` no debería estar escondido ahí, ese option global se pone en `options.lua`. La auditoría previa marcó este patrón.

Mueve los keys de claude/gemini al bloque `keys` de `snacks.lua` y pon `autoread` en `options.lua`. Borra los dos archivos.

**M4. `<leader>mp` (render-markdown toggle) en grupo "harpoon"**

which-key etiqueta `<leader>m` como "harpoon" pero `<leader>mp` es render-markdown preview. Tendrás "Harpoon: toggle preview" en el popup lo cual no tiene sentido. Mueve `<leader>mp` a `<leader>cp` (code preview) o usa un grupo `<leader>md` = "markdown" aunque solo haya un binding ahí.

**M5. `<leader>r` en visual triggera refactoring.select_refactor, pero `<leader>r` es también grupo "refactor/rename"**

```lua
-- refactoring.lua:26
{
  "<leader>r",
  function() require("refactoring").select_refactor(...) end,
  mode = "v",
}
```

Y en which-key:
```lua
{ "<leader>r", group = "refactor/rename" },
```

which-key asume que `<leader>r` es un prefijo de grupo. En visual mode es un mapping directo. Esto causa delay perceptible (which-key espera `timeoutlen` antes de ejecutar). Renómbralo a `<leader>rr` en visual (refactor refactor) para consistencia y para eliminar el delay.

**M6. `init.lua` vacío, todo en `alex/core`**

Correcto estructuralmente. No es un problema, pero añadir una línea `vim.g.mapleader = " "` en `init.lua` antes del require garantiza que si algo carga antes del core/keymaps.lua no se descoloque el leader. Es un micro paranoia. Opcional.

**M7. Yazi package.toml pineado a commit estático `442d908`**

Los plugins oficiales de Yazi (`yazi-rs/plugins:*`) están todos al mismo rev. Yazi se mueve muy rápido. Corre `ya pkg upgrade` periódicamente (una vez al mes) o pinéalos a una tag, no a un commit.

**M8. Snacks `image = { enabled = false }` con nota "incompatible with 0.12.0"**

Escribiste esa nota y no volviste. Estamos en abril 2026, Neovim 0.12 ya estable. Snacks tiene commit `ad9ede6` (reciente). Vuelve a probar `image.enabled = true`. Si sigue rompiendo, abre un issue upstream.

**M9. `mql5` plugin es el único que no sigue el patrón del resto (sin config)**

`vim-mql5` es VimScript legacy, archivado en 2020. Si realmente trabajas MQL5 (lo dudo para YOUR-ORG), mantén. Si fue experimento, borra. Si no lo has usado en 6 meses, borra.

**M10. DAP solo tiene config "launch" para Next.js server, nada para debug del browser frontend**

Tu `dap.lua` tiene pwa-chrome como adapter pero no lo usa en la `configurations`. Para debugear un componente React tendrías que escribir la config ad hoc. Añade una config "Attach to Chrome" con webRoot.

---

### BAJO (cosmético, pero estás a un paso de obsesionarte)

**B1. `aerial.lua` usa tabs en indentación, el resto 2-spaces**

`.stylua.toml` presumiblemente define 2 espacios. Pasa `stylua` sobre `lua/**/*.lua`.

**B2. `neotest.lua` mismo problema de indent inconsistente (línea 5 empieza con tab, línea 4 con 2 espacios)**

Idem.

**B3. `ssh.fish` function**

```fish
env TERM=xterm-256color command ssh $argv
```

Ghostty exporta `TERM=xterm-ghostty` que muchos servers no reconocen. El workaround es correcto. Alternativa: instalar el terminfo de ghostty en el server (`infocmp -x | ssh host tic -x -`) una vez, eliminando la necesidad del wrapper. No es un bug, es una decisión consciente. Solo menciono por si quieres simplificar.

**B4. `gemini.lua` pega `vim.o.autoread = true` via `init` en el init de snacks en `claude.lua`**

Ya lo mencioné en M3, lo repito porque es raro: una opción editor-wide escondida en el archivo de un plugin. Si mañana borras claude.lua sin notar, pierdes autoread. Anti-patrón.

**B5. `fish/config.fish` tiene dos abreviaciones peligrosas implícitas**

```fish
abbr -a cat 'bat --paging=never'
abbr -a ls 'eza --icons=always'
```

Abbr se expande inline, así que en scripts y pipes sigue siendo el `cat` y `ls` reales. Pero cuando copias un comando de docs con `cat file | grep x` y lo pegas, fish NO expande `cat` en ese contexto (en scripts). Bien. Pero en interactive, si escribes `cat` y tabulas, fish inserta el texto expandido, lo que puede ser confuso para una persona mirando por encima de tu hombro. Trivial, solo consciencia.

**B6. `tmux.conf` `bind g display-popup ... lazygit` colisiona con defaults**

Default de tmux: `prefix + g` no hace nada, estás seguro.  
Default de tmux 3.4+: `prefix + C-o` rota pane. Tu `@sessionx-bind 'o'` es diferente (`prefix + o` abre sessionx). OK, no hay colisión real.

**B7. Los comentarios inline de colorscheme.lua sobre qué es cada color son muy útiles, mantenlos como plantilla para futuros temas**

No es un bug, es un halago. Sigue haciéndolo.

---

## 3. Gaps específicos stack TS / React / Next / CSS

Qué tienes y funciona:

- vtsls (correcto sobre ts_ls)
- eslint con eslint_d
- prettier via conform
- emmet_language_server
- graphql LSP
- prismals
- nvim-ts-autotag
- ts-context-commentstring nativo
- package-info.nvim (para ver versiones dentro de `package.json`)
- DAP con pwa-node para Next.js server, Jest y Vitest en neotest
- render-markdown para MDX (filetype "mdx" incluido)

Qué NO tienes y necesitas o deberías evaluar:

1. ~~`tailwindcss-language-server`~~. Descartado: no usas Tailwind.

2. ~~`tailwind-tools.nvim`~~. Descartado: no usas Tailwind.

3. **`nvim-treesitter-context`**. Cuando estás dentro de un componente React de 200 líneas, ves el nombre de la función/componente sticky en la parte superior de la ventana. Sin esto, te pierdes en JSX anidado. Altamente recomendado para tu stack.

4. **`grug-far.nvim`**. Find and replace en todo el proyecto con preview en buffer. Tu flujo actual es `<leader>sg` (grep) y luego editar archivo por archivo. grug-far es el spectre/far moderno y se integra con ripgrep. Muy útil en refactors grandes de monorepos.

5. **Neotest adapter para Playwright** (`thenbe/neotest-playwright`). Solo si usas Playwright. Si usas solo Jest/Vitest, ignora.

6. **CSS Variables LSP** (`chrlafleur/css-variables-language-server`) para workspaces con muchas custom props. Opcional.

7. **Biome como alternativa a ESLint+Prettier**. Si YOUR-ORG no está casado con ESLint, Biome es 10x más rápido. Pero si ya tienes ESLint config en repos, no vale la pena cambiar.

8. **Schemastore.nvim** ya lo tienes en jsonls/yamlls. Bien.

9. **Neoconf** (`folke/neoconf.nvim`). Permite tener `.neoconf.json` por repo para settings de LSP por proyecto. En un monorepo tipo YOUR-ORG con Next + Lambda + Shopify es muy útil para sobreescribir cosas tipo `typescript.tsdk` por subdirectorio. Opcional pero profesional.

---

## 4. Colisiones de keymap que quedan

Estado actual verificado (no inventado, cross-referencing archivos):

| Key | Conflictos / comentario |
|---|---|
| `<leader>m` | which-key: "harpoon", pero `<leader>mp` es render-markdown. Mover mp. |
| `<leader>r` | Grupo "refactor/rename" en which-key + mapping directo en visual via refactoring.nvim. Delay de timeoutlen en visual. |
| `<leader>ca` | Duplica default `gra` (code action). |
| `<leader>rn` | Duplica default `grn` (rename). |
| `<C-j>` | insert mode: blink select_next vs supermaven accept_word. Contextualmente ambiguo. |
| `<leader>O` | Huérfano, no en grupo. |
| `<leader>l` | lazygit. Fine, pero consistencia: podría ser `<leader>gg` o `<leader>gl`. Actualmente `<leader>gl` es git log picker de snacks. Así que mantén `<leader>l`. |

Estado sin colisión real (auditoría antigua resuelta o falso positivo):

| Key | Explicación |
|---|---|
| `<A-j>/<A-k>` | Ya no colisiona con line-move porque line-move se movió a `<S-A-j>/<S-A-k>`. smart-splits tiene el dominio de Alt+hjkl. OK. |
| `<C-space>` | Insert mode (blink) vs normal/visual (treesitter incremental select). Modos diferentes, no chocan. OK. |
| `C-h/j/k/l` tmux vs nvim | smart-splits + vim-tmux-navigator tmux plugin: el par correcto. OK. |
| `{` / `}` | Aerial ya no los usa, usa `[a/]a`. Paragraph motion funciona. OK. |

---

## 5. Diffs listos para aplicar

Los diffs están por severidad. Aplica los CRÍTICO primero.

### D1. Fix dashboard referencia a ranger-nvim muerto, y typo

Archivo: `/sessions/loving-eloquent-johnson/mnt/.config/nvim/lua/alex/plugins/snacks.lua`, línea 36.

Antes:
```lua
            { icon = "󰙅 ", key = "e", desc = "File Exporer", action = ":lua require('ranger-nvim').open(true)" },
```

Después:
```lua
            { icon = "󰙅 ", key = "e", desc = "File Explorer", action = ":lua Snacks.explorer()" },
```

---

### D2. Fix path hardcodeado en `functions/dy.fish`

Archivo: `/sessions/loving-eloquent-johnson/mnt/.config/fish/functions/dy.fish`.

Antes:
```fish
function dy --description 'Start DynamoDB Local'
    java --enable-native-access=ALL-UNNAMED \
        -Djava.library.path="$HOME/Library/Mobile Documents/com~apple~CloudDocs/dynamo/DynamoDBLocal_lib" \
        -jar "$HOME/Library/Mobile Documents/com~apple~CloudDocs/dynamo/DynamoDBLocal.jar" \
        -dbPath "$HOME/Library/Mobile Documents/com~apple~CloudDocs/dynamo/" \
        -sharedDb
end
```

Después:
```fish
function dy --description 'Start DynamoDB Local'
    set -l DYNAMO_DIR "$HOME/Library/Mobile Documents/com~apple~CloudDocs/dynamo"
    java --enable-native-access=ALL-UNNAMED \
        -Djava.library.path="$DYNAMO_DIR/DynamoDBLocal_lib" \
        -jar "$DYNAMO_DIR/DynamoDBLocal.jar" \
        -dbPath "$DYNAMO_DIR/" \
        -sharedDb
end
```

---

### D3. Borrar folder zombie `tmux-neolazygit`

Comando:
```fish
rm -rf ~/.config/tmux/plugins/tmux-neolazygit
```

No es un archivo a editar, es disco a liberar.

---

### D4. ~~Instalar Tailwind LSP~~ — DESCARTADO

No aplica. Salta a D5.

---

### D5. Borrar nvim-tree, consolidar en Snacks.explorer

Comando:
```fish
rm /sessions/loving-eloquent-johnson/mnt/.config/nvim/lua/alex/plugins/nvim-tree.lua
```

Añadir keymaps equivalentes en `snacks.lua` dentro del array `keys = { ... }` (después de la entrada `<leader>st`):

Antes:
```lua
      {
        "<leader>st",
        function()
          Snacks.explorer.reveal({ hidden = true })
        end,
        desc = "[T]ree",
      },
```

Después:
```lua
      {
        "<leader>st",
        function()
          Snacks.explorer.reveal({ hidden = true })
        end,
        desc = "[T]ree (reveal current)",
      },
      {
        "<leader>ee",
        function() Snacks.explorer() end,
        desc = "Toggle file explorer",
      },
      {
        "<leader>ef",
        function() Snacks.explorer.reveal({ hidden = true }) end,
        desc = "Reveal file in explorer",
      },
```

(Así preservas memoria muscular de `<leader>ee` y `<leader>ef`.)

---

### D6. Eliminar keymaps LSP duplicados con defaults de 0.11+

Archivo: `/sessions/loving-eloquent-johnson/mnt/.config/nvim/lua/alex/plugins/lsp/lspconfig.lua`, líneas 160 a 164.

Antes:
```lua
        -- Keep custom leader keymaps for muscle memory
        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
```

Después:
```lua
        -- Defaults gra (code action) and grn (rename) handled by Neovim 0.11+.
        -- Custom leader mappings removed on 2026-04-21 to avoid duplication.
```

Opcional si no quieres re-educar tu memoria muscular: mantén uno de los dos (`<leader>ca` es el más usado en ecosistema LazyVim) y borra el otro.

---

### D7. Mover `<C-j>` de supermaven para no chocar con blink

Archivo: `/sessions/loving-eloquent-johnson/mnt/.config/nvim/lua/alex/plugins/supermaven.lua`, línea 9.

Antes:
```lua
      keymaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
      },
      ignore_filetypes = { "snacks_picker_input", "minifiles" },
```

Después:
```lua
      keymaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion = "<C-]>",
        accept_word = "<M-l>",
      },
      ignore_filetypes = { "snacks_picker_input", "snacks_dashboard" },
```

`<M-l>` (Alt+L) es "aceptar palabra siguiente" en Copilot.vim desde hace años, es convención. `snacks_dashboard` evita que supermaven moleste en la pantalla de inicio.

---

### D8. Actualizar auto-session a API moderna

Archivo: `/sessions/loving-eloquent-johnson/mnt/.config/nvim/lua/alex/plugins/auto-session.lua`.

Antes:
```lua
    auto_session.setup({
      auto_restore_enabled = false,
      auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
    })
```

Después:
```lua
    auto_session.setup({
      auto_restore = false,
      suppressed_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
    })
```

---

### D9. Mover render-markdown preview fuera del grupo harpoon

Archivo: `/sessions/loving-eloquent-johnson/mnt/.config/nvim/lua/alex/plugins/markdown.lua`, línea 26.

Antes:
```lua
  keys = {
    { "<leader>mp", "<cmd>RenderMarkdown toggle<CR>", ft = "markdown", desc = "Toggle Markdown Preview" },
  },
```

Después:
```lua
  keys = {
    { "<leader>cp", "<cmd>RenderMarkdown toggle<CR>", ft = "markdown", desc = "Toggle Markdown Preview" },
  },
```

`<leader>c` ya es el grupo "code" (tiene cf, ca, cd, cD). Preview de markdown cabe ahí.

---

### D10. Eliminar el delay de `<leader>r` en visual mode

Archivo: `/sessions/loving-eloquent-johnson/mnt/.config/nvim/lua/alex/plugins/refactoring.lua`, línea 27.

Antes:
```lua
    keys = {
      {
        "<leader>r",
        function()
          require("refactoring").select_refactor({
            show_success_message = true,
          })
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
      },
    },
```

Después:
```lua
    keys = {
      {
        "<leader>rr",
        function()
          require("refactoring").select_refactor({
            show_success_message = true,
          })
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
        desc = "Refactor menu",
      },
    },
```

---

### D11. Consolidar claude.lua y gemini.lua en snacks.lua

Paso 1: En `snacks.lua`, añadir al array `keys` (puede ser justo antes del cierre):

```lua
      -- AI terminals (migrated from claude.lua and gemini.lua)
      {
        "<leader>ac",
        function()
          Snacks.terminal.toggle("claude", {
            win = { position = "right", width = 0.4, border = "rounded" },
          })
        end,
        desc = "Toggle Claude Code",
      },
      {
        "<leader>ag",
        function()
          Snacks.terminal.toggle("gemini", {
            win = { position = "right", width = 0.4, border = "rounded" },
          })
        end,
        desc = "Toggle Gemini CLI",
      },
```

Paso 2: Mover `vim.o.autoread = true` a `core/options.lua`. Después de `opt.undofile = true`:

Antes:
```lua
-- persistent undo
opt.undofile = true

-- faster CursorHold events (used by LSP, gitsigns, etc.)
opt.updatetime = 200
```

Después:
```lua
-- persistent undo
opt.undofile = true

-- reread file when modified externally (needed for Claude/Gemini CLI edits)
opt.autoread = true

-- faster CursorHold events (used by LSP, gitsigns, etc.)
opt.updatetime = 200
```

Paso 3: Borrar los dos archivos:
```fish
rm /sessions/loving-eloquent-johnson/mnt/.config/nvim/lua/alex/plugins/claude.lua
rm /sessions/loving-eloquent-johnson/mnt/.config/nvim/lua/alex/plugins/gemini.lua
```

---

### D12. Limpiar icono muerto "Codeium" en aerial.lua

Archivo: `/sessions/loving-eloquent-johnson/mnt/.config/nvim/lua/alex/plugins/aerial.lua`, línea 35.

Antes:
```lua
				Class = " ",
				Codeium = "󰘦 ",
				Color = " ",
```

Después:
```lua
				Class = " ",
				Color = " ",
```

---

### D13. Instalar nvim-treesitter-context (sticky headers en JSX largo)

Crea un nuevo archivo `/sessions/loving-eloquent-johnson/mnt/.config/nvim/lua/alex/plugins/treesitter-context.lua`:

```lua
return {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    max_lines = 3,
    min_window_height = 20,
    line_numbers = true,
    multiline_threshold = 1,
    trim_scope = "outer",
    mode = "cursor",
    separator = nil,
    zindex = 20,
  },
  keys = {
    {
      "<leader>ut",
      function() require("treesitter-context").toggle() end,
      desc = "Toggle Treesitter Context",
    },
  },
}
```

---

### D14. (Opcional pero recomendado) Instalar grug-far para find/replace global

Crea `/sessions/loving-eloquent-johnson/mnt/.config/nvim/lua/alex/plugins/grug-far.lua`:

```lua
return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    {
      "<leader>sR",
      function() require("grug-far").open() end,
      desc = "Find and Replace (grug-far)",
      mode = { "n", "v" },
    },
  },
  opts = { headerMaxWidth = 80 },
}
```

Nota: `<leader>sR` actualmente está ocupado por `Snacks.picker.resume()`. Decide:
- Mueve `Snacks.picker.resume()` a `<leader>sp` y libera `<leader>sR` para grug-far, o
- Usa `<leader>sF` para grug-far.

---

### D15. Añadir config DAP pwa-chrome para debug React frontend

Archivo: `/sessions/loving-eloquent-johnson/mnt/.config/nvim/lua/alex/plugins/dap.lua`. Dentro del loop `for _, language in ipairs({...})`, añadir una nueva config al final de la tabla:

Antes (última entrada de la tabla):
```lua
        -- Next.js server debug
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug Next.js server",
          program = "${workspaceFolder}/node_modules/.bin/next",
          args = { "dev" },
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
        },
      }
    end
```

Después:
```lua
        -- Next.js server debug
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug Next.js server",
          program = "${workspaceFolder}/node_modules/.bin/next",
          args = { "dev" },
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
        },
        -- Next.js / React frontend (attach to running Chrome)
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch Chrome against localhost:3000",
          url = "http://localhost:3000",
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
          userDataDir = false,
        },
      }
    end
```

---

### D16. Upgrade yazi plugins (one liner)

Comando:
```fish
ya pkg upgrade
```

No es edit, es mantenimiento periódico. Hazlo una vez al mes.

---

### D17. Corregir indentación inconsistente (stylua pass)

Comando:
```fish
cd ~/.config/nvim && stylua lua/
```

Si no tienes stylua global, `brew install stylua`.

---

### D18. Dashboard "e" keymap, descripción mejorada y grupo `<leader>e`

Si aplicaste D1 (reemplazar ranger) y D5 (eliminar nvim-tree con keymaps ee/ef en snacks), añade también un grupo en which-key para que `<leader>e` sea descubrible.

Archivo: `/sessions/loving-eloquent-johnson/mnt/.config/nvim/lua/alex/plugins/which-key.lua`, dentro de `wk.add`:

Antes:
```lua
      { "<leader>d",  group = "debug" },
      { "<leader>g",  group = "git" },
```

Después:
```lua
      { "<leader>d",  group = "debug" },
      { "<leader>e",  group = "explorer" },
      { "<leader>g",  group = "git" },
```

---

### D19. ~~Tailwind tools~~ — DESCARTADO

No aplica. No usas Tailwind.

---

## 6. Script todo-en-uno (si quieres aplicar los CRÍTICO y ALTO de golpe)

```fish
#!/usr/bin/env fish
# Aplicación de diffs CRÍTICOS y ALTOS de la auditoría 2026-04-21

# C3: Borra folder zombie de tmux
rm -rf ~/.config/tmux/plugins/tmux-neolazygit

# A2: Borra nvim-tree (reemplazado por Snacks.explorer)
rm -f ~/.config/nvim/lua/alex/plugins/nvim-tree.lua

# M3: Borra claude.lua y gemini.lua (consolidados en snacks.lua)
rm -f ~/.config/nvim/lua/alex/plugins/claude.lua
rm -f ~/.config/nvim/lua/alex/plugins/gemini.lua

# M7: Actualiza plugins de yazi
ya pkg upgrade

# Refresca plugins nvim (instala nvim-treesitter-context, etc.)
nvim --headless "+Lazy! sync" +qa
nvim --headless "+MasonToolsUpdate" +qa

echo "Listo. Abre nvim y verifica :checkhealth."
```

Los diffs de texto (D1, D2, D6, D7, D8, D9, D10, D11, D12, D13, D15, D18) hay que aplicarlos a mano o pedirme que los aplique directamente. D4 y D19 están descartados.

---

## 7. Qué NO cambiar (lo que ya está bien)

- tokyonight con `on_colors` + `on_highlights` para Neon Nocturne. Es una de las mejores configs de colorscheme que he visto, no la toques.
- El patrón `vim.lsp.config()` + `vim.lsp.enable()` en lspconfig.lua. Moderno y correcto.
- blink.cmp config. Sólida.
- conform.nvim para formatters. No cambies a null-ls (muerto desde 2023).
- nvim-lint para linting. Correcto.
- Neotest con adapters jest + vitest + go + la lógica de `cwd` y `jestConfigFile`. Eso es muy bien pensado para monorepo.
- Tmux: prefix C-a, resize H/J/K/L, resurrect con nvim strategy. Todo bien.
- Yazi: smart-enter, smart-filter, bookmarks, chmod. Stack correcto.
- Ghostty: vim keytable para scrollback, shell-integration detect, scrollback 100000. Impecable.
- Fish: vi mode, pay-respects, tide v6, fisher. Todo moderno.

---

## 8. Métrica final honesta

| Severidad | Count | Tiempo agregado |
|---|---|---|
| CRÍTICO | 3 | 5 minutos |
| ALTO | 6 | 30 minutos |
| MEDIO | 10 | 45 minutos |
| BAJO | 7 | 15 minutos |
| Nuevas features TS/React | 4 | 20 minutos |

Si haces CRÍTICO + ALTO (9 items) en una sentada de 40 minutos, tu setup pasa de "muy bueno" a "estado del arte 2026". El resto es pulido que puedes hacer en sesiones cortas. No hagas todo de golpe, tu config se rompe y te confundes: ejecuta por grupo, verifica con `:checkhealth`, commit, siguiente grupo.

La única cosa que realmente me preocupa de tu disciplina es que la última auditoría tiene buenos pendientes que no cerraste (nvim-tree, keymaps duplicados, path hardcodeado en dy.fish). Son decisiones diferidas. Estás perdiendo impulso en el último tramo por evitar decisiones pequeñas. Decide.
