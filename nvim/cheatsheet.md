# Neovim Cheatsheet

Referencia completa de la config de Neovim. Todos los keymaps, workflows y plugins actualizados.

`<leader>` = Space

---

## Daily Workflows

### Abrir archivos rapido

```
<leader><leader>     Fuzzy find — busca por nombre en el proyecto
<leader>sr           Archivos recientes
<leader>sG           Solo ficheros del repo git (mas rapido en repos grandes)
<leader>bb           Toggle al fichero anterior instantaneo

# Harpoon — ficheros que usas constantemente
<leader>ma           Añadir fichero a la lista
<leader>mm           Menu harpoon
<leader>m1-m4        Saltar directo al fichero 1-4
<leader>mj / mk      Siguiente / anterior en lista
```

---

### Revision de cambios Git

```
]h / [h              Saltar entre hunks del fichero actual
<leader>hp           Preview del hunk bajo el cursor
<leader>hb           Blame de la linea actual

# Staging rapido hunk a hunk
<leader>hs           Stage hunk
<leader>hu           Unstage hunk (toggle de stage)
<leader>hr           Reset hunk (descartar cambio)

# Revisar todos los cambios
<leader>gd           DiffviewOpen (diff completo del working dir)
<leader>gf           Historial del fichero actual
<leader>gc           Cerrar diffview

# Commit / push
<leader>lg           LazyGit (stage, commit, push, rebase...)
```

---

### Flujo de refactor

```
gd                   Ir a la definicion del simbolo
grr                  Ver todas las referencias (Snacks picker)
grn                  Renombrar simbolo (built-in 0.11+)
gra                  Code actions (built-in 0.11+)
<leader>ri           Incremental rename con preview inline
<leader>rr           (visual) Menu de refactor (extract, inline...)
<leader>cf           Formatear fichero al acabar
```

---

### Buscar y reemplazar multi-fichero

```
<leader>sg           Live grep, busca el texto en el proyecto
                     En el picker: <C-q> manda resultados al quickfix
<leader>sF           Find and replace global con grug-far (preview en buffer)
:cfdo s/viejo/nuevo/g | w    Reemplaza en todos los ficheros del quickfix
```

---

### Debug de un test Jest

```
<leader>db           Poner breakpoint en la linea que falla
<leader>td           Debug del test mas cercano al cursor
<leader>di           Step into — entrar en la funcion
<leader>do           Step over — siguiente linea
<leader>dt           Toggle UI de DAP para ver variables
```

---

### Editar JSX/HTML rapido

```
cit                  Cambiar contenido del tag (change inner tag)
dat                  Borrar tag completo (delete around tag)
ysiw"                Envolver palabra en comillas (surround)
cs"'                 Cambiar comillas dobles a simples
                     nvim-ts-autotag cierra y renombra tags automaticamente
```

---

### Substitute — pegar sin perder registro

```
yiw                  Copiar la palabra que quieres replicar
s{motion}            Sustituye el target con lo copiado (ej: siw)
ss                   Sustituye la linea entera con lo copiado
S                    Sustituye hasta el final de la linea
v{select} s          En visual: selecciona y s para sustituir
```

---

### Resolver errores de linting

```
<leader>cd           Ver diagnostico de la linea actual
]d / [d              Saltar al siguiente / anterior diagnostico
]e / [e              Saltar al siguiente / anterior error (solo ERROR)
gra                  Code action, auto-fix si hay sugerencia
<leader>xw           Ver todos los errores del workspace en Trouble
<leader>cf           Formatear para resolver problemas de estilo
```

---

### AI Pair Programming (sidekick.nvim, 2026-06)

```
<leader>ac           Claude (sesion persistente via tmux)
<leader>ao           opencode (sesion persistente via tmux)
<leader>aa           Toggle del ultimo CLI usado
<leader>ap           Seleccionar prompt predefinido
<leader>av           Enviar seleccion visual al CLI
<Tab> (normal)       Saltar/aplicar Next Edit Suggestion (NES)
<Tab> (insert)       Aceptar ghost text (vim.lsp.inline_completion)
```

> Primer uso: `:LspCopilotSignIn` (cuenta GitHub; Copilot Free vale).
> El ghost text lo sirve el Copilot LSP nativo; NES aplica refactors
> multi-linea. Los CLIs sobreviven al cierre de nvim (mux tmux).

---

### Navegar codigo como un pro

```
]m / [m              Saltar a la siguiente / anterior funcion
]c / [c              Saltar a la siguiente / anterior clase
]t / [t              Saltar al siguiente / anterior TODO
; / ,                Repetir ultimo salto treesitter (adelante / atras)
<leader>co           Aerial, vista panoramica de la estructura
<leader>ut           Toggle treesitter-context (sticky header con scope actual)
```

---

## Vim Basico

| Keymap | Descripcion |
| --- | --- |
| `i` | Insert mode |
| `v` | Visual mode |
| `V` | Visual Line mode |
| `<C-v>` | Visual Block mode |
| `Esc` / `jk` | Normal mode |
| `w` / `b` | Siguiente / anterior palabra |
| `0` / `$` | Inicio / fin de linea |
| `gg` / `G` | Inicio / fin de fichero |
| `<C-u>` / `<C-d>` | Scroll media pagina arriba / abajo |
| `u` / `<C-r>` | Undo / Redo |
| `y` / `p` | Yank (copiar) / Paste |
| `dd` | Borrar linea |
| `ciw` | Cambiar palabra bajo cursor |
| `ci"` | Cambiar contenido entre comillas |
| `cit` | Cambiar contenido de tag HTML |
| `>>` / `<<` | Indentar / Desindentar |
| `/pattern` | Buscar hacia adelante |
| `n` / `N` | Siguiente / anterior resultado |
| `*` | Buscar palabra bajo cursor |

## Keymaps Core

| Keymap | Descripcion |
| --- | --- |
| `jk` | Salir de insert mode |
| `<Esc>` | Limpiar search highlights |
| `<leader>w` | Guardar buffer |
| `<leader>q` | Salir |
| `\|` | Split vertical |
| `-` | Split horizontal |
| `<leader>se` | Igualar splits |
| `<leader>sx` | Cerrar split actual |
| `<C-S-j>` / `<C-S-k>` | Mover linea abajo / arriba |
| `gw` | Toggle line wrap |
| `<leader>bb` | Ultimo buffer (toggle) |
| `<leader>+` / `<leader>-` | Incrementar / decrementar numero |

## Windows & Tmux (smart-splits)

| Keymap | Descripcion |
| --- | --- |
| `<C-h>` / `<C-l>` | Mover izquierda / derecha |
| `<C-j>` / `<C-k>` | Mover abajo / arriba |
| `<C-A-h>` / `<C-A-l>` | Redimensionar izquierda / derecha |
| `<C-A-j>` / `<C-A-k>` | Redimensionar abajo / arriba |
| `<leader>shd` | Definicion en split horizontal |
| `<leader>svd` | Definicion en split vertical |

> Contrato de modificadores: Alt es de AeroSpace (ventanas macOS), Ctrl navega panes, Ctrl-Alt redimensiona. Funciona igual en panes de tmux y splits de nvim.

## Buscar Archivos (Snacks Picker)

| Keymap | Descripcion |
| --- | --- |
| `<leader><leader>` | Find files (fuzzy) |
| `<leader>sg` | Live grep (proyecto) |
| `<leader>sw` | Grep palabra bajo cursor |
| `<leader>sr` | Archivos recientes |
| `<leader>sb` | Buffers abiertos |
| `<leader>sG` | Git files |
| `<leader>sl` | Lineas del buffer actual |
| `<leader>sd` | Diagnosticos |
| `<leader>ss` | LSP symbols |
| `<leader>sh` | Help pages |
| `<leader>sk` | Keymaps |
| `<leader>sc` | Historial de comandos |
| `<leader>sm` | Marks |
| `<leader>sj` | Jump list |
| `<leader>sq` | Quickfix list |
| `<leader>sp` | Proyectos |
| `<leader>sR` | Reanudar ultimo picker |
| `<leader>sF` | Find & Replace global (grug-far) |
| `<leader>s"` | Registros |
| `<leader>st` | File tree (reveal) |

## Harpoon v2

| Keymap | Descripcion |
| --- | --- |
| `<leader>ma` | Añadir fichero a la lista |
| `<leader>mm` | Toggle menu harpoon |
| `<leader>m1` | Saltar al fichero 1 |
| `<leader>m2` | Saltar al fichero 2 |
| `<leader>m3` | Saltar al fichero 3 |
| `<leader>m4` | Saltar al fichero 4 |
| `<leader>mj` | Siguiente fichero |
| `<leader>mk` | Anterior fichero |

## File Explorer (Snacks)

nvim-tree eliminado el 2026-04-21. Snacks.explorer es ahora la unica via.

| Keymap | Descripcion |
| --- | --- |
| `<leader>ee` | Toggle explorador |
| `<leader>ef` | Reveal fichero actual en el explorador |
| `<leader>st` | Alias de reveal (legacy, Snacks search/tree) |

### Dentro del explorador

| Keymap | Accion |
| --- | --- |
| `a` | Crear fichero (nombre + Enter) |
| `a` + `carpeta/` | Crear directorio (termina en `/`) |
| `r` | Renombrar |
| `d` | Borrar |
| `c` / `x` / `p` | Copiar / Cortar / Pegar |
| `<CR>` | Abrir fichero |
| `<C-v>` | Abrir en split vertical |
| `<C-s>` | Abrir en split horizontal |
| `H` | Toggle ficheros ocultos |
| `q` | Cerrar explorador |

## Buffers & Tabs

| Keymap | Descripcion |
| --- | --- |
| `<S-h>` / `<S-l>` | Buffer anterior / siguiente |
| `<leader>bb` | Toggle ultimo buffer |
| `<leader>sb` | Picker de buffers |
| `<leader>bd` | Cerrar buffer |
| `<leader>bo` | Cerrar todos menos el actual |
| `<leader>bp` | Pin buffer |
| `<leader>bP` | Cerrar buffers no-pinned |
| `<leader>br` | Cerrar buffers a la derecha |
| `<leader>bl` | Cerrar buffers a la izquierda |
| `<leader>To` | Nueva tab |
| `<leader>Tx` | Cerrar tab |
| `<leader>Tn` / `<leader>Tp` | Siguiente / anterior tab |
| `<leader>Tf` | Buffer actual en nueva tab |

## LSP & Codigo

### Built-in Neovim 0.12 (funcionan sin config)

| Keymap | Descripcion |
| --- | --- |
| `K` | Hover docs (default 0.12) |
| `grn` | Rename symbol (default 0.12) |
| `gra` | Code actions (default 0.12) |
| `grr` | References (override: Snacks picker) |
| `gri` | Implementations (override: Snacks picker) |
| `grt` | Type definitions (override: Snacks picker) |
| `grx` | Run codelens (default 0.12) |
| `gO` | Document symbols (default 0.12) |
| `<C-s>` | Signature help en insert mode (default 0.12) |

### Custom keymaps

`<leader>ca` y `<leader>rn` eliminados el 2026-04-21: duplicaban los defaults 0.11+ (`gra`, `grn`).

| Keymap | Descripcion |
| --- | --- |
| `gd` | Go to definition (Snacks picker) |
| `gD` | Go to declaration |
| `<C-o>` / `<C-i>` | Jump back / forward (jumplist) |
| `<leader>ri` | Incremental rename (preview inline) |
| `<leader>rr` (visual) | Menu de refactor (extract, inline...) |
| `<leader>co` | Toggle Aerial (code outline) |
| `<leader>cp` | Toggle render-markdown preview (en buffers markdown) |
| `<leader>cd` | Line diagnostics |
| `<leader>cD` | Buffer diagnostics |
| `[d` / `]d` | Prev / Next diagnostic |
| `[e` / `]e` | Prev / Next error (solo ERROR) |
| `<leader>rs` | Restart LSP (`:lsp restart`) |
| `<leader>shd` | Definicion en split horizontal |
| `<leader>svd` | Definicion en split vertical |

## Completion (blink.cmp)

| Keymap | Descripcion |
| --- | --- |
| `<C-Space>` | Mostrar completions |
| `<C-e>` | Cerrar menu |
| `<CR>` | Confirmar seleccion |
| `<Tab>` | Confirmar / NES / ghost text (ver cadena abajo) |
| `<C-k>` / `<C-j>` | Item anterior / siguiente |
| `<C-b>` / `<C-f>` | Scroll docs arriba / abajo |
| `<Tab>` / `<S-Tab>` | Siguiente / anterior placeholder (snippets) |
| `<C-s>` | Signature help (insert mode) |

> Cadena de Tab: blink.cmp si el menu esta visible -> NES de sidekick (saltar/aplicar) -> ghost text nativo (Copilot LSP) -> placeholder de snippet -> tab normal.

## Formato & Linting

| Keymap | Descripcion |
| --- | --- |
| `<leader>cf` | Formatear fichero / seleccion (conform) |
| `<leader>l` | Trigger linting del fichero actual |

Formateadores por tipo:
- JS/TS/CSS/HTML/JSON/YAML/GraphQL/Liquid: `prettier`
- Lua: `stylua`
- Python: `ruff` (format + organize imports)
- Go: `gofmt`
- Rust: `rustfmt`

Linters por tipo:
- JS/TS: LSP `eslint` (diagnosticos + code actions; eslint_d eliminado por duplicar warnings)
- Python: `ruff`
- Go: `golangci-lint`
- Shell: `shellcheck`
- Dockerfile: `hadolint`
- TOML: LSP `taplo` (schema de Cargo.toml incluido)

## Git

### Gitsigns

| Keymap | Descripcion |
| --- | --- |
| `]h` / `[h` | Siguiente / anterior hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hu` | Unstage hunk (toggle de stage) |
| `<leader>hS` | Stage buffer completo |
| `<leader>hR` | Reset buffer completo |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |
| `<leader>hB` | Toggle line blame |
| `<leader>hd` | Diff this |
| `ih` | Seleccionar hunk (text object) |

### Diffview

| Keymap | Descripcion |
| --- | --- |
| `<leader>gd` | Abrir diff (working dir) |
| `<leader>gc` | Cerrar diffview |
| `<leader>gf` | Historial fichero actual |
| `<leader>gF` | Historial repo completo |

### Snacks Git + LazyGit

| Keymap | Descripcion |
| --- | --- |
| `<leader>gb` | Git blame |
| `<leader>gl` | Git log |
| `<leader>gs` | Git status |
| `<leader>lg` | LazyGit |

## Edicion

| Keymap | Descripcion |
| --- | --- |
| `gcc` | Toggle comentario linea |
| `gbc` | Toggle comentario bloque |
| `gc{motion}` | Comentar con movimiento (ej: gc3j) |
| `<C-space>` | Expandir seleccion (treesitter node) |
| `<bs>` | Contraer seleccion |
| `<C-S-j>` / `<C-S-k>` | Mover linea abajo / arriba |

## Surround

| Keymap | Descripcion |
| --- | --- |
| `ys{motion}{char}` | Añadir surround (ysiw" ysiw) ysiw}) |
| `ysiw"` | Envolver palabra en comillas |
| `yss"` | Envolver linea entera |
| `cs{old}{new}` | Cambiar surround (cs"' cambia " por ') |
| `ds{char}` | Borrar surround (ds" borra comillas) |
| `S{char}` | Surround en visual mode |

## Substitute (Paste-Replace)

| Keymap | Descripcion |
| --- | --- |
| `s{motion}` | Sustituir con lo copiado (ej: siw) |
| `ss` | Sustituir linea entera |
| `S` | Sustituir hasta fin de linea |
| `s` (visual) | Sustituir seleccion |

## Treesitter Text Objects

### Seleccion (usar con v, d, y, c)

| Keymap | Descripcion |
| --- | --- |
| `im` / `am` | Inner / Around funcion |
| `ic` / `ac` | Inner / Around clase |
| `ia` / `aa` | Inner / Around parametro |
| `ii` / `ai` | Inner / Around condicional |
| `il` / `al` | Inner / Around loop |
| `if` / `af` | Inner / Around function call |
| `iB` / `aB` | Inner / Around bloque {} |
| `i=` / `a=` | Inner / Around assignment |
| `l=` / `r=` | Left / Right de assignment |
| `i:` / `a:` | Inner / Around propiedad (JS/TS) |
| `l:` / `r:` | Left / Right de propiedad |

### Movimiento

| Keymap | Descripcion |
| --- | --- |
| `]m` / `[m` | Siguiente / anterior funcion |
| `]M` / `[M` | Siguiente / anterior fin de funcion |
| `]c` / `[c` | Siguiente / anterior clase |
| `;` / `,` | Repetir / invertir ultimo movimiento treesitter |

### Swap

| Keymap | Descripcion |
| --- | --- |
| `<leader>na` / `<leader>pa` | Swap argumento siguiente / anterior |
| `<leader>n:` / `<leader>p:` | Swap propiedad siguiente / anterior |
| `<leader>nm` / `<leader>pm` | Swap funcion siguiente / anterior |

## AI Tools (sidekick.nvim)

| Keymap | Descripcion |
| --- | --- |
| `<leader>ac` | Toggle Claude (persistente via tmux) |
| `<leader>ao` | Toggle opencode (persistente via tmux) |
| `<leader>aa` | Toggle del ultimo CLI |
| `<leader>ap` | Seleccionar prompt (normal/visual) |
| `<leader>av` | Enviar seleccion visual al CLI |
| `<Tab>` (normal) | Saltar/aplicar Next Edit Suggestion |
| `<Tab>` (insert) | Aceptar ghost text si no hay menu/NES |

> Ghost text: `vim.lsp.inline_completion` nativo (Neovim 0.12) servido por el Copilot LSP. NES: refactors multi-linea con diff resaltado. Login: `:LspCopilotSignIn`. Los ficheros editados por el CLI se recargan solos.

## Debug (DAP)

| Keymap | Descripcion |
| --- | --- |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Breakpoint condicional |
| `<leader>dc` | Continue |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>dO` | Step out |
| `<leader>dl` | Run last |
| `<leader>dr` | Abrir REPL |
| `<leader>dt` | Toggle DAP UI |

Configuraciones DAP disponibles:
- Launch file: ejecutar fichero actual con Node
- Attach to process: conectar a proceso Node corriendo
- Debug Jest Tests: debug con --inspect-brk
- Debug Next.js server: Next.js dev con debugger
- Launch Chrome against localhost:3000: debug frontend React/Next con source maps
- Python: via nvim-dap-python
- Go: via dap-go + delve
- Rust: via codelldb (rustaceanvim)

## Testing (Neotest)

| Keymap | Descripcion |
| --- | --- |
| `<leader>tt` | Run test mas cercano |
| `<leader>tT` | Run tests del fichero |
| `<leader>td` | Debug test mas cercano |
| `<leader>ts` | Toggle resumen |
| `<leader>to` | Mostrar output |

Adapters: Jest (detecta pnpm/npm por lockfile), Vitest, Go, Rust (via rustaceanvim).

## Rust (rustaceanvim + crates.nvim)

### En ficheros .rs

| Keymap | Descripcion |
| --- | --- |
| `<leader>ca` | Code action de rust-analyzer (agrupadas) |
| `<leader>cm` | Expandir macro bajo el cursor |
| `<leader>ce` | Diagnostico renderizado como lo pinta cargo |

Comandos utiles: `:RustLsp runnables` (run/test/bench del cursor), `:RustLsp debuggables` (debug via codelldb), `:RustLsp openCargo` (saltar al Cargo.toml), `:RustLsp explainError` (explicacion larga del error).

> Check on save usa `clippy` con todas las features: mismos warnings que CI.

### En Cargo.toml (crates.nvim)

| Keymap | Descripcion |
| --- | --- |
| `<leader>Ct` | Toggle versiones inline |
| `<leader>Cv` | Popup de versiones del crate |
| `<leader>Cf` | Popup de features del crate |
| `<leader>Cu` / `<leader>CU` | Update / upgrade crate bajo el cursor |
| `<leader>CA` | Upgrade TODOS los crates |
| `<leader>Cd` | Abrir docs.rs |
| `<leader>Cc` | Abrir crates.io |
| `<leader>Cr` | Recargar info de crates |

> Completions de nombres/versiones/features salen solas via LSP in-process. En terminal: `cargo nextest run` para tests rapidos y `bacon` para feedback de compilacion continuo.

## Trouble & Diagnostics

| Keymap | Descripcion |
| --- | --- |
| `<leader>xw` | Diagnosticos del workspace |
| `<leader>xd` | Diagnosticos del documento |
| `<leader>xq` | Quickfix list |
| `<leader>xl` | Location list |
| `<leader>xt` | TODOs |
| `<leader>cd` | Diagnostico de la linea |
| `<leader>cD` | Diagnosticos del buffer |
| `]d` / `[d` | Siguiente / anterior diagnostico |
| `]e` / `[e` | Siguiente / anterior error (solo ERROR) |
| `]t` / `[t` | Siguiente / anterior TODO |

## Vim Power Moves

| Keymap | Descripcion |
| --- | --- |
| `.` | Repetir ultimo cambio (el mas poderoso de vim) |
| `q{reg}` | Grabar macro (qa ... q graba en "a") |
| `@{reg}` | Ejecutar macro (@a ejecuta, @@ repite ultima) |
| `{N}@{reg}` | Ejecutar macro N veces (10@a) |
| `r{char}` | Reemplazar caracter bajo cursor |
| `R` | Replace mode (sobreescribir) |
| `J` | Juntar linea actual con la siguiente |
| `gv` | Reseleccionar ultimo visual |
| `%` | Ir al bracket que cierra/abre |
| `<C-a>` / `<C-x>` | Incrementar / decrementar numero |
| `I` / `A` | Insertar al inicio / final de linea |
| `o` / `O` | Abrir linea abajo / arriba |
| `D` / `C` | Borrar / cambiar hasta fin de linea |
| `P` | Pegar antes del cursor |
| `"_d{motion}` | Borrar sin copiar (black hole) |
| `"+y` | Copiar al clipboard del sistema |
| `<C-o>` / `<C-i>` | Atras / adelante en jumplist |
| `m{a-z}` | Marcar posicion (ma marca, 'a salta) |
| `'{a-z}` | Ir a marca |

## Command Line Tips

| Keymap | Descripcion |
| --- | --- |
| `:%s/old/new/g` | Reemplazar en todo el fichero |
| `:%s/old/new/gc` | Reemplazar con confirmacion |
| `:s/old/new/g` | Reemplazar en seleccion (V primero) |
| `:!{cmd}` | Ejecutar comando shell |
| `:r !{cmd}` | Insertar output de comando en buffer |
| `:sort` | Ordenar lineas |
| `:sort u` | Ordenar y eliminar duplicados |
| `:g/pattern/d` | Borrar lineas que matchean |
| `:v/pattern/d` | Quedarse solo con lineas que matchean |
| `:set ft={type}` | Cambiar filetype (:set ft=json) |

## Aerial (Code Outline)

| Keymap | Descripcion |
| --- | --- |
| `<leader>co` | Toggle vista de estructura (code outline) |
| `[a` / `]a` | Anterior / siguiente simbolo |

## Sessions (auto-session)

| Keymap | Descripcion |
| --- | --- |
| `<leader>Sr` | Restaurar sesion del cwd |
| `<leader>Ss` | Guardar sesion |

> Movidos de `<leader>w*` a `<leader>S*`: ahora `<leader>w` (guardar fichero) es instantaneo, sin los 300ms de espera del prefijo.

## Notifications (Snacks)

| Keymap | Descripcion |
| --- | --- |
| `<leader>Ns` | Historial de notificaciones |
| `<leader>Nh` | Ocultar notificaciones |

## UI Toggles

| Keymap | Descripcion |
| --- | --- |
| `<leader>cp` | Toggle render-markdown preview |
| `<leader>ut` | Toggle treesitter-context (sticky header) |
| `<leader>co` | Toggle Aerial (code outline) |
| `:ColorizerToggle` | Toggle preview de colores |

## Misc

| Keymap | Descripcion |
| --- | --- |
| `<leader>l` | Trigger lint |
| `:Lazy` | Plugin manager |
| `:Mason` | LSP/formatter/linter manager |
| `<leader>ri` | Incremental rename (preview inline) |
| `<leader>rr` (visual) | Menu de refactor (extract, inline...) |
