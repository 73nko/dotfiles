return {
  "folke/which-key.nvim",
  event = "VimEnter", -- Sets the loading event to 'VimEnter'
  opts = {
    delay = 100, -- delay between pressing key & opening which-key (milliseconds) independent of vim.opt.timeoutlen
    preset = "helix", -- "classic" | "modern" | "helix"
    notify = true,
    plugins = {
      marks = true, -- shows a list of your marks on ' and `
      registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      spelling = {
        enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
        suggestions = 20, -- how many suggestions should be shown in the list?
      },
      presets = {
        operators = true, -- adds help for operators like d, y, ...
        motions = true, -- adds help for motions
        text_objects = true, -- help for text objects triggered after entering an operator
        windows = true, -- default bindings on <c-w>
        nav = true, -- misc bindings to work with windows
        z = true, -- bindings for folds, spelling and others prefixed with z
        g = true, -- bindings for prefixed with g
      },
    },
    win = {
      padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
      title = false,
      title_pos = "center",
      wo = {
        winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
      },
    },
    show_help = true,
    show_keys = true,
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Group labels for better discoverability
    wk.add({
      { "<leader>a",  group = "AI" },
      { "<leader>b",  group = "buffer" },
      { "<leader>c",  group = "code" },
      { "<leader>d",  group = "debug" },
      { "<leader>g",  group = "git" },
      { "<leader>h",  group = "git hunks" },
      { "<leader>m",  group = "format/marks" },
      { "<leader>n",  group = "swap next" },
      { "<leader>p",  group = "swap prev" },
      { "<leader>r",  group = "refactor/rename" },
      { "<leader>s",  group = "search/snacks" },
      { "<leader>t",  group = "test" },
      { "<leader>x",  group = "trouble/diagnostics" },
    })
  end,
}
