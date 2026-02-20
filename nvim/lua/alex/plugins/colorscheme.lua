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
          fg = "#FF79C6",
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
          fg = "#BD93F9",
          bold = true,
        }

        -- Nebula: JSX/HTML tag overrides
        -- Tags como <Frame>, <div>, <Layout> → azul eléctrico
        hl["@tag"]               = { fg = "#7AB9F5", bold = false }
        -- Componentes React (PascalCase) → violeta
        hl["@tag.builtin"]       = { fg = "#4DD0E1" }
        -- Atributos (selected="bundles", className) → lavanda
        hl["@tag.attribute"]     = { fg = "#CBA6F7" }
        -- Angle brackets < > → muted, no llaman la atención
        hl["@tag.delimiter"]     = { fg = "#4A5480" }
        -- JSX expressions {} → texto normal
        hl["@punctuation.bracket"] = { fg = "#CDD6F4" }
        -- String values en JSX → verde menta (ya heredado)
        hl["@string"]            = { fg = "#A6E3A1" }
      end,
    },
    init = function()
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      require("smart-splits").setup({
        multiplexer_integration = "tmux",
      })
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
