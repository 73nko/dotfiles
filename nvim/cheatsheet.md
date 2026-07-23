# Neovim Cheatsheet

Complete reference for the Neovim config. All keymaps, workflows and plugins up to date.

`<leader>` = Space

---

## Daily Workflows

### Open files fast

```
<leader><leader>     Fuzzy find — search by name in the project
<leader>sr           Recent files
<leader>sG           Only git-tracked files (faster on large repos)
<leader>bb           Toggle to the previous file instantly

# Harpoon — files you use constantly
<leader>ma           Add file to the list
<leader>mm           Harpoon menu
<leader>m1-m4        Jump directly to file 1-4
<leader>mj / mk      Next / previous in list
```

---

### Reviewing Git changes

```
]h / [h              Jump between hunks in the current file
<leader>hp           Preview hunk under cursor
<leader>hb           Blame current line

# Fast hunk-by-hunk staging
<leader>hs           Stage hunk
<leader>hu           Unstage hunk (stage toggle)
<leader>hr           Reset hunk (discard change)

# Review all changes
<leader>gd           DiffviewOpen (full working dir diff)
<leader>gf           Current file history
<leader>gc           Close diffview

# Commit / push
<leader>lg           LazyGit (stage, commit, push, rebase...)
```

---

### Refactor flow

```
gd                   Go to symbol definition
grr                  Show all references (Snacks picker)
grn                  Rename symbol (built-in 0.11+)
gra                  Code actions (built-in 0.11+)
<leader>ri           Incremental rename with inline preview
<leader>rr           (visual) Refactor menu (extract, inline...)
<leader>cf           Format file when done
```

---

### Multi-file search and replace

```
<leader>sg           Live grep, search text in the project
                     In the picker: <C-q> sends results to quickfix
<leader>sF           Global find and replace with grug-far (buffer preview)
:cfdo s/old/new/g | w    Replace across all quickfix files
```

---

### Debugging a Jest test

```
<leader>db           Set breakpoint on failing line
<leader>td           Debug the test nearest the cursor
<leader>di           Step into — enter the function
<leader>do           Step over — next line
<leader>dt           Toggle DAP UI to see variables
```

---

### Editing JSX/HTML fast

```
cit                  Change inner tag content
dat                  Delete around tag (whole tag)
ysiw"                Surround word with quotes
cs"'                 Change double quotes to single quotes
                     nvim-ts-autotag closes and renames tags automatically
```

---

### Substitute — paste without losing the register

```
yiw                  Yank the word you want to replicate
s{motion}            Substitute target with what's yanked (e.g. siw)
ss                   Substitute the entire line with what's yanked
S                    Substitute up to end of line
v{select} s          In visual: select and s to substitute
```

---

### Fixing lint errors

```
<leader>cd           Show diagnostic for the current line
]d / [d              Jump to next / previous diagnostic
]e / [e              Jump to next / previous error (ERROR only)
gra                  Code action, auto-fix if a suggestion exists
<leader>xw           Show all workspace errors in Trouble
<leader>cf           Format to fix style issues
```

---

### AI Pair Programming (sidekick.nvim, 2026-06)

```
<leader>ac           Claude (persistent session via tmux)
<leader>af           send current file to the CLI (claude)
<leader>aa           Toggle the last used CLI
<leader>ap           Pick a preset prompt
<leader>av           Send visual selection to the CLI
<Tab> (normal)       Jump/apply Next Edit Suggestion (NES)
<C-y> (insert)       ALWAYS accept ghost text (dedicated, predictable key)
<Tab> (insert)       Accept ghost text if no blink/NES menu (chain)
```

> First use: `:LspCopilotSignIn` (GitHub account; Copilot Free works).
> Ghost text is served by the native Copilot LSP; NES applies multi-line
> refactors. The CLIs survive nvim closing (tmux mux).
> Use `<C-y>` when you want to accept without thinking about what Tab does
> in that context.
> Native inline limits on 0.12: no word-by-word accept (neovim#35485) and
> may insert extra chars if you accept too fast (neovim#36529). Upstream.

---

### Navigate code like a pro

```
]m / [m              Jump to next / previous function
]c / [c              Jump to next / previous class
]t / [t              Jump to next / previous TODO
; / ,                Repeat last treesitter jump (forward / backward)
<leader>co           Aerial, panoramic view of structure
<leader>ut           Toggle treesitter-context (sticky header with current scope)
```

---

## Vim Basics

| Keymap | Description |
| --- | --- |
| `i` | Insert mode |
| `v` | Visual mode |
| `V` | Visual Line mode |
| `<C-v>` | Visual Block mode |
| `Esc` / `jk` | Normal mode |
| `w` / `b` | Next / previous word |
| `0` / `$` | Start / end of line |
| `gg` / `G` | Start / end of file |
| `<C-u>` / `<C-d>` | Scroll half page up / down |
| `u` / `<C-r>` | Undo / Redo |
| `y` / `p` | Yank (copy) / Paste |
| `dd` | Delete line |
| `ciw` | Change word under cursor |
| `ci"` | Change content between quotes |
| `cit` | Change HTML tag content |
| `>>` / `<<` | Indent / Outdent |
| `/pattern` | Search forward |
| `n` / `N` | Next / previous match |
| `*` | Search word under cursor |

## Core Keymaps

| Keymap | Description |
| --- | --- |
| `jk` | Exit insert mode |
| `<Esc>` | Clear search highlights |
| `<leader>w` | Save buffer |
| `<leader>q` | Quit |
| `\|` | Vertical split |
| `-` | Horizontal split |
| `<leader>se` | Equalize splits |
| `<leader>sx` | Close current split |
| `<C-S-j>` / `<C-S-k>` | Move line down / up |
| `gw` | Toggle line wrap |
| `<leader>bb` | Last buffer (toggle) |
| `<leader>+` / `<leader>-` | Increment / decrement number |

## Windows & Tmux (smart-splits)

| Keymap | Description |
| --- | --- |
| `<C-h>` / `<C-l>` | Move left / right |
| `<C-j>` / `<C-k>` | Move down / up |
| `<C-A-h>` / `<C-A-l>` | Resize left / right |
| `<C-A-j>` / `<C-A-k>` | Resize down / up |
| `<leader>shd` | Definition in horizontal split |
| `<leader>svd` | Definition in vertical split |

> Modifier contract: Alt is AeroSpace's (macOS windows), Ctrl navigates panes, Ctrl-Alt resizes. Works the same in tmux panes and nvim splits.

## Find Files (Snacks Picker)

| Keymap | Description |
| --- | --- |
| `<leader><leader>` | Find files (fuzzy) |
| `<leader>sg` | Live grep (project) |
| `<leader>sw` | Grep word under cursor |
| `<leader>sr` | Recent files |
| `<leader>sb` | Open buffers |
| `<leader>sG` | Git files |
| `<leader>sl` | Lines in current buffer |
| `<leader>sd` | Diagnostics |
| `<leader>ss` | LSP symbols |
| `<leader>sh` | Help pages |
| `<leader>sk` | Keymaps |
| `<leader>sc` | Command history |
| `<leader>sm` | Marks |
| `<leader>sj` | Jump list |
| `<leader>sq` | Quickfix list |
| `<leader>sp` | Projects |
| `<leader>sR` | Resume last picker |
| `<leader>sF` | Global find & replace (grug-far) |
| `<leader>s"` | Registers |
| `<leader>st` | File tree (reveal) |

## Harpoon v2

| Keymap | Description |
| --- | --- |
| `<leader>ma` | Add file to list |
| `<leader>mm` | Toggle harpoon menu |
| `<leader>m1` | Jump to file 1 |
| `<leader>m2` | Jump to file 2 |
| `<leader>m3` | Jump to file 3 |
| `<leader>m4` | Jump to file 4 |
| `<leader>mj` | Next file |
| `<leader>mk` | Previous file |

## File Explorer (Snacks)

nvim-tree removed on 2026-04-21. Snacks.explorer is now the only way.

| Keymap | Description |
| --- | --- |
| `<leader>ee` | Toggle explorer |
| `<leader>ef` | Reveal current file in explorer |
| `<leader>st` | Reveal alias (legacy, Snacks search/tree) |

### Inside the explorer

| Keymap | Action |
| --- | --- |
| `a` | Create file (name + Enter) |
| `a` + `folder/` | Create directory (end with `/`) |
| `r` | Rename |
| `d` | Delete |
| `c` / `x` / `p` | Copy / Cut / Paste |
| `<CR>` | Open file |
| `<C-v>` | Open in vertical split |
| `<C-s>` | Open in horizontal split |
| `H` | Toggle hidden files |
| `q` | Close explorer |

## Buffers & Tabs

| Keymap | Description |
| --- | --- |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<leader>bb` | Toggle last buffer |
| `<leader>sb` | Buffer picker |
| `<leader>bd` | Close buffer |
| `<leader>bo` | Close all but current |
| `<leader>bp` | Pin buffer |
| `<leader>bP` | Close non-pinned buffers |
| `<leader>br` | Close buffers to the right |
| `<leader>bl` | Close buffers to the left |
| `<leader>To` | New tab |
| `<leader>Tx` | Close tab |
| `<leader>Tn` / `<leader>Tp` | Next / previous tab |
| `<leader>Tf` | Current buffer in new tab |

## LSP & Code

### Built-in Neovim 0.12 (work without config)

| Keymap | Description |
| --- | --- |
| `K` | Hover docs (default 0.12) |
| `grn` | Rename symbol (default 0.12) |
| `gra` | Code actions (default 0.12) |
| `grr` | References (override: Snacks picker) |
| `gri` | Implementations (override: Snacks picker) |
| `grt` | Type definitions (override: Snacks picker) |
| `grx` | Run codelens (default 0.12) |
| `gO` | Document symbols (default 0.12) |
| `<C-s>` | Signature help in insert mode (default 0.12) |

### Custom keymaps

`<leader>ca` and `<leader>rn` removed on 2026-04-21: they duplicated the 0.11+ defaults (`gra`, `grn`).

| Keymap | Description |
| --- | --- |
| `gd` | Go to definition (Snacks picker) |
| `gD` | Go to declaration |
| `<C-o>` / `<C-i>` | Jump back / forward (jumplist) |
| `<leader>ri` | Incremental rename (inline preview) |
| `<leader>rr` (visual) | Refactor menu (extract, inline...) |
| `<leader>co` | Toggle Aerial (code outline) |
| `<leader>cp` | Toggle render-markdown preview (in markdown buffers) |
| `<leader>cd` | Line diagnostics |
| `<leader>cD` | Buffer diagnostics |
| `[d` / `]d` | Prev / Next diagnostic |
| `[e` / `]e` | Prev / Next error (ERROR only) |
| `<leader>rs` | Restart LSP (`:lsp restart`) |
| `<leader>shd` | Definition in horizontal split |
| `<leader>svd` | Definition in vertical split |

## Completion (blink.cmp)

| Keymap | Description |
| --- | --- |
| `<C-Space>` | Show completions |
| `<C-e>` | Close menu |
| `<CR>` | Confirm selection |
| `<Tab>` | Confirm / NES / ghost text (see chain below) |
| `<C-k>` / `<C-j>` | Previous / next item |
| `<C-b>` / `<C-f>` | Scroll docs up / down |
| `<Tab>` / `<S-Tab>` | Next / previous placeholder (snippets) |
| `<C-s>` | Signature help (insert mode) |

> Tab chain: blink.cmp if the menu is visible -> sidekick NES (jump/apply) -> native ghost text (Copilot LSP) -> snippet placeholder -> plain tab.

## Format & Lint

| Keymap | Description |
| --- | --- |
| `<leader>cf` | Format file / selection (conform) |
| `<leader>l` | Trigger linting of the current file |

Formatters per type:
- JS/TS/CSS/HTML/JSON/YAML/GraphQL/Liquid: `prettier`
- Lua: `stylua`
- Python: `ruff` (format + organize imports)
- Go: `gofmt`
- Rust: `rustfmt`

Linters per type:
- JS/TS: LSP `eslint` (diagnostics + code actions; eslint_d removed for duplicating warnings)
- Python: `ruff`
- Go: `golangci-lint`
- Shell: `shellcheck`
- Dockerfile: `hadolint`
- TOML: LSP `taplo` (Cargo.toml schema included)

## Git

### Gitsigns

| Keymap | Description |
| --- | --- |
| `]h` / `[h` | Next / previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hu` | Unstage hunk (stage toggle) |
| `<leader>hS` | Stage entire buffer |
| `<leader>hR` | Reset entire buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |
| `<leader>hB` | Toggle line blame |
| `<leader>hd` | Diff this |
| `ih` | Select hunk (text object) |

### Diffview

| Keymap | Description |
| --- | --- |
| `<leader>gd` | Open diff (working dir) |
| `<leader>gc` | Close diffview |
| `<leader>gf` | Current file history |
| `<leader>gF` | Full repo history |

### Snacks Git + LazyGit

| Keymap | Description |
| --- | --- |
| `<leader>gb` | Git blame |
| `<leader>gl` | Git log |
| `<leader>gs` | Git status |
| `<leader>lg` | LazyGit |

## Editing

| Keymap | Description |
| --- | --- |
| `gcc` | Toggle line comment |
| `gbc` | Toggle block comment |
| `gc{motion}` | Comment with motion (e.g. gc3j) |
| `<C-space>` | Expand selection (treesitter node) |
| `<bs>` | Shrink selection |
| `<C-S-j>` / `<C-S-k>` | Move line down / up |

## Surround

| Keymap | Description |
| --- | --- |
| `ys{motion}{char}` | Add surround (ysiw" ysiw) ysiw}) |
| `ysiw"` | Wrap word in quotes |
| `yss"` | Wrap whole line |
| `cs{old}{new}` | Change surround (cs"' swaps " for ') |
| `ds{char}` | Delete surround (ds" removes quotes) |
| `S{char}` | Surround in visual mode |

## Substitute (Paste-Replace)

| Keymap | Description |
| --- | --- |
| `s{motion}` | Substitute with yanked (e.g. siw) |
| `ss` | Substitute whole line |
| `S` | Substitute up to end of line |
| `s` (visual) | Substitute selection |

## Treesitter Text Objects

### Selection (use with v, d, y, c)

| Keymap | Description |
| --- | --- |
| `im` / `am` | Inner / Around function |
| `ic` / `ac` | Inner / Around class |
| `ia` / `aa` | Inner / Around parameter |
| `ii` / `ai` | Inner / Around conditional |
| `il` / `al` | Inner / Around loop |
| `if` / `af` | Inner / Around function call |
| `iB` / `aB` | Inner / Around block {} |
| `i=` / `a=` | Inner / Around assignment |
| `l=` / `r=` | Left / Right side of assignment |
| `i:` / `a:` | Inner / Around property (JS/TS) |
| `l:` / `r:` | Left / Right side of property |

### Movement

| Keymap | Description |
| --- | --- |
| `]m` / `[m` | Next / previous function |
| `]M` / `[M` | Next / previous end of function |
| `]c` / `[c` | Next / previous class |
| `;` / `,` | Repeat / reverse last treesitter movement |

### Swap

| Keymap | Description |
| --- | --- |
| `<leader>na` / `<leader>pa` | Swap next / previous argument |
| `<leader>n:` / `<leader>p:` | Swap next / previous property |
| `<leader>nm` / `<leader>pm` | Swap next / previous function |

## AI Tools (sidekick.nvim)

| Keymap | Description |
| --- | --- |
| `<leader>ac` | Toggle Claude (persistent via tmux) |
| `<leader>af` | Send current file to the CLI |
| `<leader>aa` | Toggle the last CLI |
| `<leader>ap` | Pick a prompt (normal/visual) |
| `<leader>av` | Send visual selection to CLI |
| `<Tab>` (normal) | Jump/apply Next Edit Suggestion |
| `<C-y>` (insert) | ALWAYS accept ghost text (dedicated key) |
| `<Tab>` (insert) | Accept ghost text if no menu/NES (chain) |

> Ghost text: native `vim.lsp.inline_completion` (Neovim 0.12) served by the Copilot LSP. NES: multi-line refactors with highlighted diff. Login: `:LspCopilotSignIn`. Files edited by the CLI reload automatically.

## Debug (DAP)

| Keymap | Description |
| --- | --- |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dc` | Continue |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>dO` | Step out |
| `<leader>dl` | Run last |
| `<leader>dr` | Open REPL |
| `<leader>dt` | Toggle DAP UI |

Available DAP configurations:
- Launch file: run current file with Node
- Attach to process: connect to a running Node process
- Debug Jest Tests: debug with --inspect-brk
- Debug Next.js server: Next.js dev with debugger
- Launch Chrome against localhost:3000: debug React/Next frontend with source maps
- Python: via nvim-dap-python
- Go: via dap-go + delve
- Rust: via codelldb (rustaceanvim)

## Testing (Neotest)

| Keymap | Description |
| --- | --- |
| `<leader>tt` | Run nearest test |
| `<leader>tT` | Run tests in the file |
| `<leader>td` | Debug nearest test |
| `<leader>ts` | Toggle summary |
| `<leader>to` | Show output |

Adapters: Jest (detects pnpm/npm by lockfile), Vitest, Go, Rust (via rustaceanvim).

## Rust (rustaceanvim + crates.nvim)

### In .rs files

| Keymap | Description |
| --- | --- |
| `<leader>ca` | rust-analyzer code action (grouped) |
| `<leader>cm` | Expand macro under cursor |
| `<leader>ce` | Diagnostic rendered like cargo prints it |

Useful commands: `:RustLsp runnables` (run/test/bench at cursor), `:RustLsp debuggables` (debug via codelldb), `:RustLsp openCargo` (jump to Cargo.toml), `:RustLsp explainError` (long error explanation).

> Check on save uses `clippy` with all features: same warnings as CI.

### In Cargo.toml (crates.nvim)

| Keymap | Description |
| --- | --- |
| `<leader>Ct` | Toggle inline versions |
| `<leader>Cv` | Crate versions popup |
| `<leader>Cf` | Crate features popup |
| `<leader>Cu` / `<leader>CU` | Update / upgrade crate under cursor |
| `<leader>CA` | Upgrade ALL crates |
| `<leader>Cd` | Open docs.rs |
| `<leader>Cc` | Open crates.io |
| `<leader>Cr` | Reload crate info |

> Name/version/feature completions come from in-process LSP automatically. In the terminal: `cargo nextest run` for fast tests and `bacon` for continuous compile feedback.

## Trouble & Diagnostics

| Keymap | Description |
| --- | --- |
| `<leader>xw` | Workspace diagnostics |
| `<leader>xd` | Document diagnostics |
| `<leader>xq` | Quickfix list |
| `<leader>xl` | Location list |
| `<leader>xt` | TODOs |
| `<leader>cd` | Line diagnostic |
| `<leader>cD` | Buffer diagnostics |
| `]d` / `[d` | Next / previous diagnostic |
| `]e` / `[e` | Next / previous error (ERROR only) |
| `]t` / `[t` | Next / previous TODO |

## Vim Power Moves

| Keymap | Description |
| --- | --- |
| `.` | Repeat last change (vim's most powerful) |
| `q{reg}` | Record macro (qa ... q records to "a") |
| `@{reg}` | Run macro (@a runs, @@ repeats last) |
| `{N}@{reg}` | Run macro N times (10@a) |
| `r{char}` | Replace character under cursor |
| `R` | Replace mode (overwrite) |
| `J` | Join current line with next |
| `gv` | Reselect last visual |
| `%` | Jump to matching bracket |
| `<C-a>` / `<C-x>` | Increment / decrement number |
| `I` / `A` | Insert at start / end of line |
| `o` / `O` | Open line below / above |
| `D` / `C` | Delete / change to end of line |
| `P` | Paste before cursor |
| `"_d{motion}` | Delete without yanking (black hole) |
| `"+y` | Yank to system clipboard |
| `<C-o>` / `<C-i>` | Back / forward in jumplist |
| `m{a-z}` | Mark position (ma marks, 'a jumps) |
| `'{a-z}` | Jump to mark |

## Command Line Tips

| Keymap | Description |
| --- | --- |
| `:%s/old/new/g` | Replace in whole file |
| `:%s/old/new/gc` | Replace with confirmation |
| `:s/old/new/g` | Replace in selection (V first) |
| `:!{cmd}` | Run shell command |
| `:r !{cmd}` | Insert command output into buffer |
| `:sort` | Sort lines |
| `:sort u` | Sort and remove duplicates |
| `:g/pattern/d` | Delete matching lines |
| `:v/pattern/d` | Keep only matching lines |
| `:set ft={type}` | Change filetype (:set ft=json) |

## Aerial (Code Outline)

| Keymap | Description |
| --- | --- |
| `<leader>co` | Toggle structure view (code outline) |
| `[a` / `]a` | Previous / next symbol |

## Sessions (auto-session)

| Keymap | Description |
| --- | --- |
| `<leader>Sr` | Restore session for cwd |
| `<leader>Ss` | Save session |

> Moved from `<leader>w*` to `<leader>S*`: now `<leader>w` (save file) is instant, without the 300ms prefix wait.

## Notifications (Snacks)

| Keymap | Description |
| --- | --- |
| `<leader>Ns` | Notification history |
| `<leader>Nh` | Hide notifications |

## UI Toggles

| Keymap | Description |
| --- | --- |
| `<leader>cp` | Toggle render-markdown preview |
| `<leader>ut` | Toggle treesitter-context (sticky header) |
| `<leader>co` | Toggle Aerial (code outline) |
| `:ColorizerToggle` | Toggle color preview |

## Misc

| Keymap | Description |
| --- | --- |
| `<leader>l` | Trigger lint |
| `:Lazy` | Plugin manager |
| `:Mason` | LSP/formatter/linter manager |
| `<leader>ri` | Incremental rename (inline preview) |
| `<leader>rr` (visual) | Refactor menu (extract, inline...) |
