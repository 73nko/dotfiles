return {
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    priority = 1000,
    opts = {
      style = "storm", -- Puedes cambiar a "night" o "day" según prefieras
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { italic = false },
        variables = { italic = false },
        sidebars = "transparent", -- Cambia a "transparent" si prefieres que las sidebars sean transparentes
        floats = "dark", -- Cambia a "transparent" si prefieres que los floats sean transparentes
      },
      sidebars = { "qf", "help", "terminal", "packer" },
      on_highlights = function(hl, c)
        hl.WinSeparator = {
          fg = c.border_highlight,
        }
        hl.CursorLineNr = {
          fg = c.orange,
          bold = true,
        }
        hl.NvimTreeNormal = {
          bg = c.bg_dark,
          fg = c.fg_dark,
        }
        hl.NvimTreeWinSeparator = {
          fg = c.bg_dark,
          bg = c.bg_dark,
        }
        hl.NvimTreeFolderName = {
          fg = c.blue,
        }
        hl.NvimTreeOpenedFolderName = {
          fg = c.blue,
          bold = true,
        }
        hl.NvimTreeEmptyFolderName = {
          fg = c.gray,
        }
        hl.NvimTreeIndentMarker = {
          fg = c.fg_gutter,
        }
        hl.NvimTreeRootFolder = {
          fg = c.red,
          bold = true,
        }
        -- Agrega más personalizaciones aquí si lo deseas
      end,
    },
    init = function()
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
    end,
  }, -- {
  --    "levouh/tint.nvim",
  --    opts = {
  --       window_ignore_function = function(winid)
  --          local floating = vim.api.nvim_win_get_config(winid).relative ~= ""
  --          return floating
  --       end,
  --       highlight_ignore_patterns = { "WinSeparator", "Status.*" },
  --    },
  -- },
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
      vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
      vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
      vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
      vim.keymap.set("n", "<C-c>", "<C-w>c")

      vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left)
      vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down)
      vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up)
      vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right)
    end,
  },
}
