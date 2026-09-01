local opt = vim.opt

-- Ensure Homebrew binaries are in PATH (needed for tree-sitter CLI when Neovim
-- is launched from a GUI and doesn't inherit the shell's full PATH)
local homebrew_paths = { "/opt/homebrew/bin", "/usr/local/bin" }
local current_path = vim.env.PATH or ""
for _, p in ipairs(homebrew_paths) do
  if not current_path:find(p, 1, true) then
    vim.env.PATH = p .. ":" .. current_path
    current_path = vim.env.PATH
  end
end

-- general
opt.title = true
opt.relativenumber = true
opt.number = true
opt.hlsearch = true
opt.showcmd = true
opt.cmdheight = 0
opt.cursorline = true
opt.wrap = false

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one
opt.smartindent = true
opt.smarttab = true
opt.breakindent = true

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- persistent undo
opt.undofile = true
opt.sessionoptions:append("localoptions")

-- reread file when modified externally (needed for Claude/Gemini CLI edits)
opt.autoread = true

-- faster CursorHold events (used by LSP, gitsigns, etc.)
opt.updatetime = 200

-- keep cursor away from top/bottom edges
opt.scrolloff = 8
opt.sidescrolloff = 8

-- better completion experience
opt.pumheight = 10 -- limit completion menu height

-- show substitution preview in split
opt.inccommand = "split"

-- open folds by default
-- folding (use native treesitter foldexpr, not deprecated VimScript function)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99

-- previously missing quality-of-life options
opt.timeoutlen = 300 -- faster which-key popup (default 1000ms is slow)
opt.confirm = true -- ask to save instead of erroring on :q with unsaved changes
opt.virtualedit = "block" -- allow cursor beyond line end in visual block mode
opt.smoothscroll = true -- smooth Ctrl-D/U scrolling (Neovim 0.10+)
opt.jumpoptions = "stack" -- make jumplist behave like a stack (Neovim 0.11+)

-- filetype-specific overrides
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "go" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- Netrw esta desactivado en init.lua. Este hook redirige cualquier :e directorio/
-- hacia el comportamiento adecuado segun el contexto:
--   - Arranque (nvim . o nvim ~/proyecto): cd al dir y dispara Snacks.dashboard
--     explicitamente tras VimEnter. NO abrimos explorer: el dashboard es la
--     pantalla de inicio.
--   - Post arranque (:e dir/): abrimos Snacks.explorer() directamente.
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("alex_dir_hijack", { clear = true }),
  callback = function(args)
    local bufname = vim.api.nvim_buf_get_name(args.buf)
    if bufname == "" then
      return
    end
    local stat = vim.uv.fs_stat(bufname)
    if not (stat and stat.type == "directory") then
      return
    end

    vim.api.nvim_buf_delete(args.buf, { force = true })
    vim.cmd.cd(bufname)

    if vim.v.vim_did_enter == 0 then
      -- Arranque: vim.schedule posterga hasta despues de VimEnter, que es
      -- cuando Snacks esta cargado y dashboard.open puede tomar el buffer
      -- scratch que dejamos detras.
      vim.cmd("enew")
      vim.schedule(function()
        if pcall(require, "snacks") and _G.Snacks and Snacks.dashboard then
          Snacks.dashboard.open()
        end
      end)
      return
    end

    -- Post arranque: abrir explorer como lo pediste con :e dir/.
    if pcall(require, "snacks") then
      require("snacks").explorer()
    end
  end,
})
