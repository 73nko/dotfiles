-- Añade esto en tu configuración de Neovim
vim.cmd([[
  augroup Illuminate_Colors
    autocmd!
    autocmd ColorScheme * highlight IlluminatedWordText guibg=#444b6a guisp=#565f89 gui=bold
    autocmd ColorScheme * highlight IlluminatedWordRead guibg=#444b6a guisp=#565f89 gui=bold
    autocmd ColorScheme * highlight IlluminatedWordWrite guibg=#444b6a guisp=#565f89 gui=bold
  augroup END
]])

local opt = vim.opt

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
