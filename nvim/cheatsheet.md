# Neovim Cheatsheet

This is a cheatsheet for your Neovim configuration. It contains all the keymaps, commands, and plugins that are configured in your setup.

---

## Daily Workflows

### Abrir y navegar archivos

```
# Abrir un archivo por nombre (fuzzy)
<leader><leader>

# Volver a un archivo reciente
<leader>sr

# Archivos del repo git (más rápido que fuzzy en repos grandes)
<leader>sG

# Archivo que usas constantemente → añádelo a Harpoon
<leader>ma    → añadir
<leader>mm    → menú harpoon
<leader>m1-4  → saltar directo al fichero 1-4

# Saltar al fichero anterior (toggle rápido)
<leader>bb
```

---

### Navegar dentro del código

```
# Ir a definición / volver
gd   →  ir a definición
<C-o>  →  volver atrás (jump list)
<C-i>  →  avanzar en jump list

# Ver referencias / implementaciones
gR   →  todas las referencias
gi   →  implementaciones
K    →  documentación hover

# Ver estructura del fichero (funciones, clases…)
<leader>O  →  Aerial outline lateral

# Buscar símbolo en el proyecto
<leader>ss  →  LSP symbols (fichero actual)
<leader>sg  →  live grep (texto en todo el proyecto)
<leader>sw  →  grep de la palabra bajo el cursor
```

---

### Trabajar con splits y paneles

```
# Abrir splits
|   →  split vertical
-   →  split horizontal

# Moverse entre splits (y paneles tmux)
<C-h> / <C-l>  →  izquierda / derecha
<C-j> / <C-k>  →  abajo / arriba

# Redimensionar
<A-h/j/k/l>  →  redimensionar split

# Cerrar / igualar
<leader>sx  →  cerrar split actual
<leader>se  →  igualar tamaños

# Abrir definición en split sin perder foco
<leader>shd  →  horizontal
<leader>svd  →  vertical
```

---

### Trabajar con tabs

```
<leader>to  →  nueva tab
<leader>tx  →  cerrar tab actual
<leader>tn  →  siguiente tab
<leader>tp  →  tab anterior
<leader>tf  →  abrir buffer actual en nueva tab (útil para "zoom")
```

---

### Trabajar con buffers

```
<S-h> / <S-l>  →  buffer anterior / siguiente
<leader>bb     →  toggle último buffer (muy útil)
<leader>sb     →  picker de buffers abiertos
<leader>bd     →  cerrar buffer actual
<leader>bo     →  cerrar todos menos el actual
<leader>bp     →  pin buffer (no lo cierra con bo/bP)
```

---

### Flujo de trabajo con Git

```
# Ver qué cambió en el fichero actual
]h / [h          →  saltar entre hunks (cambios)
<leader>hp       →  preview del hunk bajo el cursor
<leader>hb       →  blame de la línea actual

# Staging rápido hunk a hunk (sin salir de nvim)
<leader>hs       →  stage hunk
<leader>hu       →  undo stage hunk
<leader>hr       →  reset hunk (descarta cambio)

# Revisar todos los cambios antes de commit
<leader>gd       →  DiffviewOpen (diff completo del working dir)
<leader>gf       →  historial del fichero actual
<leader>gc       →  cerrar diffview

# Commit / push → LazyGit
<leader>lg       →  LazyGit (desde aquí: stage, commit, push, rebase…)
```

---

### Flujo de trabajo con código (LSP)

```
# Diagnósticos
[d / ]d          →  prev / next error o warning
<leader>d        →  ver diagnóstico de la línea
<leader>xw       →  todos los diagnósticos del workspace (Trouble)

# Refactor
<leader>rn       →  renombrar símbolo
<leader>ca       →  code actions (fix imports, extraer función…)
<leader>mf       →  formatear fichero

# Cuando el LSP se cuelga
<leader>rs       →  reiniciar LSP
```

---

### Edición eficiente

```
# Moverse por palabras / objetos
w / b            →  siguiente / anterior palabra
ciw              →  cambiar palabra bajo cursor
cit / cat        →  cambiar contenido de tag HTML
ci" / ca"        →  cambiar contenido entre comillas

# Mover líneas
<A-j> / <A-k>   →  mover línea abajo / arriba

# Surround
ysiw"            →  rodear palabra con "
cs"'             →  cambiar " por '
ds"              →  eliminar "

# Comentar
gcc              →  toggle comentario línea
gc + movimiento  →  comentar rango (ej. gc3j)

# Selección con treesitter
<C-space>        →  expandir selección por nodo
<bs>             →  contraer selección

# Seleccionar función entera
vam              →  visual around method/function
```

---

### Búsqueda y reemplazo

```
# Buscar en el fichero
/texto           →  buscar hacia adelante
*                →  buscar palabra bajo cursor
n / N            →  siguiente / anterior resultado
<leader>nh       →  limpiar highlights

# Buscar en el proyecto
<leader>sg       →  live grep interactivo
<leader>sw       →  grep de la palabra bajo cursor

# Reemplazar en fichero
:%s/viejo/nuevo/g        →  reemplazar todo
:%s/viejo/nuevo/gc       →  reemplazar con confirmación

# Reemplazar en múltiples ficheros
1. <leader>sg  →  busca el texto
2. En el picker: <C-q>  →  manda resultados al quickfix
3. :cfdo s/viejo/nuevo/g | w  →  sustituye en todos
```

---

## Basic Vim Shortcuts

| Keymap            | Description                  |
| ----------------- | ---------------------------- |
| **Modes** |                              |
| `i`               | Insert mode                  |
| `v`               | Visual mode                  |
| `V`               | Visual Line mode             |
| `<C-v>`           | Visual Block mode            |
| `Esc` / `jk`      | Normal mode                  |
| **Navigation** |                              |
| `h` `j` `k` `l`   | Left, Down, Up, Right        |
| `w` / `b`         | Next / Previous word         |
| `0` / `$`         | Start / End of line          |
| `gg` / `G`        | Start / End of file          |
| `<C-u>` / `<C-d>` | Scroll Up / Down (half page) |
| **Editing** |                              |
| `u` / `<C-r>`     | Undo / Redo                  |
| `y` / `p`         | Yank (copy) / Paste          |
| `dd`              | Delete (cut) line            |
| `ciw`             | Change inner word            |
| `>>` / `<<`       | Indent / Outdent             |
| **Search** |                              |
| `/pattern`        | Search forward               |
| `?pattern`        | Search backward              |
| `n` / `N`         | Next / Previous match        |

## Core Keymaps

| Keymap                | Description                     |
| --------------------- | ------------------------------- |
| `<leader>` = Space    |                                 |
| `jk`                  | Exit insert mode                |
| `<leader>nh`          | Clear search highlights         |
| `<leader>+`           | Increment number                |
| `<leader>-`           | Decrement number                |
| `\|`                  | Split window vertically         |
| `-`                   | Split window horizontally       |
| `<leader>se`          | Make splits equal size          |
| `<leader>sx`          | Close current split             |
| `<leader>to`          | Open new tab                    |
| `<leader>tx`          | Close current tab               |
| `<leader>tn` / `tp`   | Next / Prev tab                 |
| `<leader>tf`          | Open current buffer in new tab  |
| `<A-j>` / `<A-k>`    | Move line down / up             |
| `<leader>w`           | Save the current buffer         |
| `<leader>q`           | Quit                            |
| `gw`                  | Toggle line wrap                |
| `<leader>bb`          | Switch to last buffer           |

## Window Navigation (smart-splits + tmux)

| Keymap  | Description              |
| ------- | ------------------------ |
| `<C-h>` | Move cursor / pane left  |
| `<C-j>` | Move cursor / pane down  |
| `<C-k>` | Move cursor / pane up    |
| `<C-l>` | Move cursor / pane right |
| `<C-c>` | Close split              |
| `<A-h>` | Resize split left        |
| `<A-j>` | Resize split down        |
| `<A-k>` | Resize split up          |
| `<A-l>` | Resize split right       |

## AI Tools

| Keymap       | Description                                   |
| ------------ | --------------------------------------------- |
| `<leader>ac` | Toggle **Claude Code** CLI (right sidebar)    |
| `<leader>ag` | Toggle **Gemini** CLI (right sidebar)         |

### Supermaven (AI inline completion)

| Keymap  | Description                        |
| ------- | ---------------------------------- |
| `<Tab>` | Accept full AI suggestion          |
| `<C-j>` | Accept next word of suggestion     |
| `<C-]>` | Dismiss suggestion                 |

> Suggestions appear as grey ghost text while you type. `<Tab>` only triggers Supermaven when the cmp menu is closed and no snippet is active.

## File Navigation

### Snacks Picker

| Keymap             | Description                  |
| ------------------ | ---------------------------- |
| `<leader><leader>` | Find files (fuzzy)           |
| `<leader>sg`       | Grep (live search in cwd)    |
| `<leader>sw`       | Grep word under cursor       |
| `<leader>sr`       | Recent files                 |
| `<leader>sb`       | Open buffers                 |
| `<leader>sG`       | Git files                    |
| `<leader>sl`       | Lines in current buffer      |
| `<leader>sB`       | Grep open buffers            |
| `<leader>sd`       | Diagnostics                  |
| `<leader>ss`       | LSP symbols                  |
| `<leader>sh`       | Help pages                   |
| `<leader>sk`       | Keymaps                      |
| `<leader>sc`       | Command history              |
| `<leader>sC`       | Commands                     |
| `<leader>sm`       | Marks                        |
| `<leader>sj`       | Jump list                    |
| `<leader>sq`       | Quickfix list                |
| `<leader>so`       | Colorschemes                 |
| `<leader>sp`       | Projects                     |
| `<leader>sR`       | Resume last picker           |
| `<leader>s"`       | Registers                    |
| `<leader>st`       | Snacks file tree             |

### Harpoon v2

| Keymap       | Description                      |
| ------------ | -------------------------------- |
| `<leader>ma` | Add current file to Harpoon list |
| `<leader>mm` | Toggle Harpoon quick menu        |
| `<leader>mj` | Jump to next Harpoon file        |
| `<leader>mk` | Jump to previous Harpoon file    |
| `<leader>m1` | Go to Harpoon file 1             |
| `<leader>m2` | Go to Harpoon file 2             |
| `<leader>m3` | Go to Harpoon file 3             |
| `<leader>m4` | Go to Harpoon file 4             |

### nvim-tree

| Keymap       | Description                     |
| ------------ | ------------------------------- |
| `<leader>ee` | Toggle file explorer            |
| `<leader>ef` | Toggle explorer on current file |
| `<leader>ec` | Collapse file explorer          |
| `<leader>er` | Refresh file explorer           |

#### Dentro del explorador

| Keymap | Acción |
| ------ | ------ |
| `a`    | Crear fichero (escribe nombre + Enter) |
| `a` + `carpeta/` | Crear directorio (termina con `/`) |
| `a` + `ruta/fichero.ts` | Crear fichero con directorios intermedios |
| `r`    | Renombrar fichero / directorio |
| `d`    | Borrar |
| `c`    | Copiar |
| `x`    | Cortar |
| `p`    | Pegar |
| `Enter` / `o` | Abrir fichero |
| `v`    | Abrir en split vertical |
| `s`    | Abrir en split horizontal |
| `H`    | Mostrar/ocultar ficheros ocultos |
| `W`    | Colapsar todo el árbol |
| `q`    | Cerrar explorador |

## LSP

| Keymap        | Description                              |
| ------------- | ---------------------------------------- |
| `gd`          | Go to definition (Snacks)               |
| `gD`          | Go to declaration                        |
| `gR`          | Show references (Snacks)                |
| `gi`          | Show implementations (Snacks)           |
| `gt`          | Show type definitions (Snacks)          |
| `gr`          | References (Snacks)                     |
| `gI`          | Go to implementation (Snacks)           |
| `gy`          | Go to type definition (Snacks)          |
| `K`           | Show documentation (hover)              |
| `<leader>ca`  | Code actions                            |
| `<leader>rn`  | Smart rename (LSP)                      |
| `<leader>ri`  | Smart rename (IncRename — inline preview)|
| `<leader>d`   | Show line diagnostics                   |
| `<leader>D`   | Show buffer diagnostics (Snacks)        |
| `[d` / `]d`   | Prev / Next diagnostic                  |
| `<leader>rs`  | Restart LSP                             |
| `<leader>shd` | Open definition in horizontal split     |
| `<leader>svd` | Open definition in vertical split       |
| `<A-n>`       | Illuminate — next reference             |
| `<A-p>`       | Illuminate — previous reference         |

## Formatting & Linting

| Keymap       | Description                      |
| ------------ | -------------------------------- |
| `<leader>mf` | Format file / selection (conform)|
| `<leader>l`  | Trigger linting for current file |

Formatters by type:
- **JS/TS/CSS/HTML/JSON/YAML/GraphQL/Liquid** → `prettier`
- **Lua** → `stylua`
- **Python** → `ruff` (format + organize imports)
- **Go** → `gofmt`
- **Rust** → `rustfmt`

Linters by type:
- **JS/TS** → `eslint_d`
- **Python** → `ruff`
- **Go** → `golangci-lint`
- **Shell** → `shellcheck`
- **Dockerfile** → `hadolint`

## Git

### Snacks Git

| Keymap       | Description    |
| ------------ | -------------- |
| `<leader>gb` | Git blame line |
| `<leader>gl` | Git log        |
| `<leader>gs` | Git status     |
| `<leader>sG` | Git files      |

### Gitsigns

| Keymap         | Description            |
| -------------- | ---------------------- |
| `]h` / `[h`    | Next / Prev hunk       |
| `<leader>hs`   | Stage hunk             |
| `<leader>hr`   | Reset hunk             |
| `<leader>hS`   | Stage buffer           |
| `<leader>hR`   | Reset buffer           |
| `<leader>hu`   | Undo stage hunk        |
| `<leader>hp`   | Preview hunk           |
| `<leader>hb`   | Blame line (full)      |
| `<leader>hB`   | Toggle line blame      |
| `<leader>hd`   | Diff this              |
| `<leader>hD`   | Diff this ~            |
| `ih`           | Select hunk (text obj) |

### Diffview

| Keymap       | Description                   |
| ------------ | ----------------------------- |
| `<leader>gd` | Open diff (working dir)       |
| `<leader>gc` | Close diffview                |
| `<leader>gf` | File history (current file)   |
| `<leader>gF` | File history (whole repo)     |
| `q`          | Close from any diffview panel |

### LazyGit

| Keymap       | Description  |
| ------------ | ------------ |
| `<leader>lg` | Open LazyGit |

## Buffers

| Keymap       | Description                |
| ------------ | -------------------------- |
| `<S-h>`      | Go to previous buffer      |
| `<S-l>`      | Go to next buffer          |
| `[b`         | Go to previous buffer      |
| `]b`         | Go to next buffer          |
| `<leader>bd` | Delete buffer (Snacks)     |
| `<leader>ba` | Delete all buffers (Snacks)|
| `<leader>bo` | Delete other buffers (Snacks)|
| `<leader>bp` | Toggle pin buffer          |
| `<leader>bP` | Close non-pinned buffers   |
| `<leader>br` | Close buffers to the right |
| `<leader>bl` | Close buffers to the left  |
| `<leader>bc` | Close current buffer       |
| `<leader>bb` | Switch to last buffer      |
| `<leader>sb` | Pick buffer (Snacks)       |

## Diagnostics & Trouble

| Keymap       | Description                     |
| ------------ | ------------------------------- |
| `<leader>xw` | Workspace diagnostics (Trouble) |
| `<leader>xd` | Document diagnostics (Trouble)  |
| `<leader>xq` | Quickfix list (Trouble)         |
| `<leader>xl` | Location list (Trouble)         |
| `<leader>xt` | TODOs in Trouble                |

## Debugging (DAP)

| Keymap        | Description               |
| ------------- | ------------------------- |
| `<leader>db`  | Toggle Breakpoint         |
| `<leader>dB`  | Conditional Breakpoint    |
| `<leader>dc`  | Continue                  |
| `<leader>di`  | Step Into                 |
| `<leader>do`  | Step Over                 |
| `<leader>dO`  | Step Out                  |
| `<leader>dr`  | Open REPL                 |
| `<leader>dt`  | Toggle DAP UI             |
| `<leader>dl`  | Run Last                  |

DAP configurations available:
- **Launch file** — run current file with Node
- **Attach to process** — attach to running Node process
- **Debug Jest Tests** — debug test file with `--inspect-brk`
- **Debug Next.js server** — launch Next.js dev with debugger
- **Python** — via nvim-dap-python (LangGraph / YOUR-ORG-brain)
- **Go** — via dap-go + delve (SmoothMQ)
- **Rust** — via codelldb (rustaceanvim)

## Testing (Neotest)

| Keymap        | Description        |
| ------------- | ------------------ |
| `<leader>tt`  | Run Nearest Test   |
| `<leader>tT`  | Run File Tests     |
| `<leader>td`  | Debug Nearest Test |
| `<leader>ts`  | Toggle Summary     |
| `<leader>to`  | Show Test Output   |

## Treesitter Text Objects

| Keymap        | Description |
| ------------- | ----------- |
| **Select** | **(use with `v`, `d`, `y`, `c`)** |
| `iB` / `aB`   | Inner / Around **Block**           |
| `ia` / `aa`   | Inner / Around **Argument**        |
| `i:` / `a:`   | Inner / Around **Object Property** |
| `l:` / `r:`   | Left / Right of **Property**       |
| `i=` / `a=`   | Inner / Around **Assignment**      |
| `l=` / `r=`   | Left / Right of **Assignment**     |
| `im` / `am`   | Inner / Around **Function/Method** |
| `if` / `af`   | Inner / Around **Function Call**   |
| `ic` / `ac`   | Inner / Around **Class**           |
| `ii` / `ai`   | Inner / Around **Conditional**     |
| `il` / `al`   | Inner / Around **Loop**            |
| **Move** | |
| `]m` / `[m`   | Next / Prev **Function** start     |
| `]M` / `[M`   | Next / Prev **Function** end       |
| `]c` / `[c`   | Next / Prev **Class** start        |
| `]f` / `[f`   | Next / Prev **Function Call** start|
| **Swap** | |
| `<leader>na` / `<leader>pa` | Swap **Argument** next / prev |
| `<leader>n:` / `<leader>p:` | Swap **Property** next / prev |
| `<leader>nm` / `<leader>pm` | Swap **Function** next / prev |
| **Repeatable Moves** | |
| `;` / `,`     | Repeat / Opposite last treesitter move |
| `f` `F` `t` `T` | Repeatable with `;` and `,`     |

## Comments

| Keymap        | Description                     |
| ------------- | ------------------------------- |
| `gcc`         | Toggle comment line             |
| `gbc`         | Toggle comment block            |
| `gc` + motion | Toggle comment for motion       |
| `gb` + motion | Toggle block comment for motion |

## Surround

| Keymap   | Description                          |
| -------- | ------------------------------------ |
| `ys`     | Add surround (`ysiw"` → wrap word)   |
| `ds`     | Delete surround (`ds"` → remove `"`) |
| `cs`     | Change surround (`cs"'` → `"` → `'`) |
| `S`      | Surround selection (visual mode)     |

## Aerial (Code Outline)

| Keymap      | Description             |
| ----------- | ----------------------- |
| `<leader>O` | Toggle Aerial code view |
| `{`         | Go to previous symbol   |
| `}`         | Go to next symbol       |

## Sessions (auto-session)

| Keymap       | Description              |
| ------------ | ------------------------ |
| `<leader>wr` | Restore session for cwd  |
| `<leader>ws` | Save session             |

## Notifications (Snacks)

| Keymap       | Description             |
| ------------ | ----------------------- |
| `<leader>ns` | Show notification history |
| `<leader>nh` | Hide notification       |

## Markdown (render-markdown.nvim)

| Keymap       | Description               |
| ------------ | ------------------------- |
| `<leader>mp` | Toggle Markdown rendering |

## Misc

| Keymap      | Description                         |
| ----------- | ----------------------------------- |
| `grr`       | Smart rename (Treesitter refactor)  |
| `<C-space>` | Expand treesitter selection         |
| `<bs>`      | Shrink treesitter selection         |
