local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local doctor = vim.env.DOTFILES_DOCTOR == "1"
if not vim.uv.fs_stat(lazypath) then
  if doctor then
    vim.api.nvim_err_writeln("lazy.nvim is missing; doctor mode will not install it")
    vim.cmd("cquit 1")
  else
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "alex.plugins" },
  { import = "alex.plugins.lsp" },
}, {
  install = {
    missing = not doctor,
  },
  checker = {
    enabled = not doctor,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
