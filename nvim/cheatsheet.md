# Neovim Cheatsheet

This is a cheatsheet for your Neovim configuration. It contains all the keymaps, commands, and plugins that are configured in your setup.

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
