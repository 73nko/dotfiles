# Nvim Config Audit - Alex

## 1. KEYMAP COLLISIONS (breaking things silently)

### Critical - Same key, different actions

| Key | Location 1 | Location 2 | Winner |
|-----|-----------|-----------|--------|
| `<leader>nh` | `keymaps.lua` - Clear search highlights | `snacks.lua` - Hide notification | Snacks (loaded later) |
| `<leader>to` | `keymaps.lua` - Open new tab | `neotest.lua` - Show Test Output | Neotest (buffer-local wins) |
| `<leader>sm` | `vim-maximizer.lua` - Maximize split | `snacks.lua` - Marks picker | Snacks (loaded later) |
| `<A-j>` | `keymaps.lua` - Move line down | `colorscheme.lua` (smart-splits) - Resize down | smart-splits (loaded later) |
| `<A-k>` | `keymaps.lua` - Move line up | `colorscheme.lua` (smart-splits) - Resize up | smart-splits (loaded later) |
| `{` / `}` | Vim default - Paragraph motion | `aerial.lua` - AerialPrev/Next | Aerial (you lose paragraph navigation) |

### Redundant - Same function mapped twice

| Function | Key 1 (lspconfig.lua) | Key 2 (snacks.lua keys) |
|----------|----------------------|------------------------|
| LSP definitions | `gd` (LspAttach autocmd) | `gd` (global lazy key) |
| LSP references | `gR` | `gr` |
| LSP implementations | `gi` | `gI` |
| LSP type definitions | `gt` | `gy` |
| LSP diagnostics | `<leader>D` (buffer) | `<leader>sd` (workspace) |

The snacks.lua global `keys` table overrides the LspAttach mappings for `gd`. The others use different keys for the same thing, which is confusing. **Pick one source of truth and delete the other.**

---

## 2. DUPLICATE DASHBOARDS

You have **both** `alpha-nvim` AND `snacks.nvim` dashboard configured. They fight each other on VimEnter. Delete `alpha.lua` entirely since your snacks dashboard is more complete. Also, your alpha config still references keymaps that don't exist anymore (`SPC ff`, `SPC fs`).

---

## 3. DEPRECATED APIs (will break on future Neovim updates)

| File | Deprecated | Replacement |
|------|-----------|-------------|
| `lazy.lua` | `vim.loop.fs_stat` | `vim.uv.fs_stat` (Neovim 0.10+) |
| `options.lua` | `nvim_treesitter#foldexpr()` | `vim.treesitter.foldexpr()` (native Lua) |
| `lspconfig.lua` | `vim.fn.sign_define` for diagnostics | `vim.diagnostic.config({ signs = { text = {...} } })` |
| `lspconfig.lua` | `vim.diagnostic.goto_prev/goto_next` | `vim.diagnostic.jump({ count = 1 })` / `vim.diagnostic.jump({ count = -1 })` (Neovim 0.11+) |

---

## 4. PLUGINS TO REPLACE OR REMOVE

### Remove (redundant with what you already have)

| Plugin | Why | Already covered by |
|--------|-----|-------------------|
| `alpha-nvim` | Duplicate dashboard | `snacks.nvim` dashboard |
| `vim-tmux-navigator` | Duplicate tmux integration | `smart-splits.nvim` (already configured with tmux) |
| `vim-maximizer` | VimScript, one feature | `snacks.nvim` zen mode (already enabled) or just use `<C-w>o` |
| `vim-illuminate` | Triple redundancy | `snacks.nvim` words (already enabled) + treesitter refactor highlight_definitions (already enabled). Pick ONE. |
| `Comment.nvim` | Neovim 0.10+ has native `gc`/`gcc` | Built-in. For JSX/TSX context, hook `ts_context_commentstring` into the native comment via `vim.g.skip_ts_context_commentstring_module = true` |
| `lsp_signature.nvim` | Neovim 0.10+ has native signature help | `vim.lsp.buf.signature_help()` - bind it to `<C-s>` in insert mode |
| `vim-fugitive` + `vim-rhubarb` | You have lazygit, gitsigns, diffview, snacks git | Unless you actively use `:Git` commands, this is dead weight |
| `nvim-web-devicons.lua` (separate file) | It's already a dependency of other plugins | Delete the standalone file, it adds nothing |

### Replace (better alternatives exist)

| Current | Replace with | Why |
|---------|-------------|-----|
| `nvim-cmp` + 5 dependencies | `blink.cmp` | Written in Rust, 10-50x faster fuzzy matching, simpler config, native snippet support, fewer dependencies. This is the single biggest upgrade you can make. |
| `ts_ls` (TypeScript LSP) | `vtsls` | Significantly faster, better monorepo support, actively maintained. `ts_ls` is the legacy wrapper. |
| `emmet_ls` | `emmet-language-server` | `emmet_ls` is archived/unmaintained. The new one is actively developed. |
| `nvim-tree` | Fully commit to `snacks.nvim` explorer OR `oil.nvim` | You already have `<leader>st` for snacks explorer. Having nvim-tree too is cognitive overhead. If you want edit-as-buffer semantics, `oil.nvim` is the modern choice. |

---

## 5. WHICH-KEY GROUP CONFLICTS

Your prefix organization is messy. Several prefixes serve double or triple duty:

| Prefix | which-key label | Actual uses |
|--------|----------------|-------------|
| `<leader>m` | "format/marks" | Harpoon (`ma`, `mm`, `mj`, `mk`, `m1-4`), Format (`mf`), Markdown (`mp`) |
| `<leader>t` | "test" | Tabs (`to`, `tx`, `tn`, `tp`, `tf`), Tests (`tt`, `tT`, `td`, `ts`, `to`) |
| `<leader>n` | "swap next" | Swap (`na`, `n:`, `nm`), Notifications (`ns`), Clear highlights (`nh`) |
| `<leader>s` | "search/snacks" | Search/Snacks (20+ mappings), Split equal (`se`), Split close (`sx`), Maximize (`sm`) |
| `<leader>d` | "debug" | Debug (`db`, `dc`, `di`, `do`, etc.), Diagnostics (`d` for line, `D` for buffer) |

**Suggested reorganization:**

- Move tabs to `<leader>T` prefix (capital T) or drop tab keymaps entirely if you use bufferline
- Move Harpoon from `<leader>m` to `<leader>h` (currently only git hunks)... or better, use `<leader>1-4` directly for harpoon slots (faster)
- Move notifications to `<leader>N` or keep inside snacks search prefix
- Format should be `<leader>cf` (code format) not `<leader>mf`
- Diagnostic line should move away from `<leader>d` to avoid collision with debug prefix

---

## 6. STRUCTURAL / CONFIG ISSUES

### claude.lua and gemini.lua are broken patterns
Both files return `folke/snacks.nvim` with `opts = function(_, opts)` but never modify the opts table. They just set keymaps as a side effect. This works by accident but is fragile. Move the keymaps into the main snacks.lua `keys` table instead.

### Inconsistent indentation
Some files use tabs (aerial.lua, lsp-signature.lua, ts-context-commentstring.lua), others use 2-space indentation. Your `.stylua.toml` should enforce this. Run `stylua` across your whole config.

### supermaven.lua still references Telescope
`ignore_filetypes` includes `"TelescopePrompt"` but you don't use Telescope. Minor, but shows copy-paste cruft.

### Treesitter refactor smart_rename keymapped to `grr`
This collides with Neovim 0.11+'s default `grr` mapping (LSP references). If you're on 0.11+, this is a problem. If you use `<leader>rn` for rename (which you do via LSP), you probably don't need treesitter's smart_rename at all.

---

## 7. MISSING OPTIONS (low-hanging fruit)

```lua
-- Add to options.lua
opt.timeoutlen = 300        -- faster which-key popup (default 1000 is slow)
opt.confirm = true          -- ask to save instead of erroring on :q with changes
opt.virtualedit = "block"   -- allow cursor beyond line end in visual block
opt.smoothscroll = true     -- smooth Ctrl-D/U scrolling (Neovim 0.10+)
opt.jumpoptions = "stack"   -- make jumplist behave like a stack (Neovim 0.11+)

-- Filetype-specific (add as autocmds or ftplugin files)
-- Python and Go use 4-space tabs by convention
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "go" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})
```

---

## 8. PRIORITY ACTION LIST

Ordered by impact (highest first):

1. **Fix `<A-j>`/`<A-k>` collision** - your line-move keymaps are silently broken by smart-splits. Move line-move to `<A-S-j>`/`<A-S-k>` or use a different binding for resize.

2. **Fix `<leader>nh` collision** - you literally cannot clear search highlights anymore. Remap to `<leader>ch` (clear highlights) or just `<Esc>` via autocmd: `vim.api.nvim_create_autocmd("CursorMoved", { callback = function() vim.cmd("nohlsearch") end })`. Actually, better: use `vim.on_key` or map `<Esc>` in normal mode to also clear highlights.

3. **Fix `<leader>to` collision** - tab vs test output. Move tabs to a different prefix.

4. **Delete alpha.lua** - it's fighting snacks dashboard.

5. **Delete vim-tmux-navigator** from init.lua - smart-splits already handles this.

6. **Remove illuminate.nvim** - snacks words does the same thing.

7. **Remove Comment.nvim** - use native gc/gcc (Neovim 0.10+).

8. **Fix deprecated APIs** - especially `vim.loop` and the fold expression.

9. **Consolidate LSP keymaps** - pick either the LspAttach block or the snacks global keys, not both.

10. **Replace nvim-cmp with blink.cmp** - biggest quality-of-life upgrade, but also the most work.

11. **Replace ts_ls with vtsls** - straightforward swap in mason config.

12. **Reorganize which-key prefixes** - this is a bigger refactor but will make your config navigable.
