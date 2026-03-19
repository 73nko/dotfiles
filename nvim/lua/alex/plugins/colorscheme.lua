return {
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { italic = false },
        variables = { italic = false },
        sidebars = "transparent",
        floats = "dark",
      },
      sidebars = { "qf", "help", "terminal" },
      on_colors = function(c)
        -- Deep blue-purple foundation (matched to cheatsheet palette)
        c.bg = "#06080f"
        c.bg_dark = "#04060b"
        c.bg_float = "#0b0f1a"
        c.bg_popup = "#0b0f1a"
        c.bg_sidebar = "#04060b"
        c.bg_statusline = "#0b0f1a"
        c.bg_highlight = "#111827"
        c.fg_gutter = "#1b2436"
        c.border = "#1b2436"
        c.border_highlight = "#c4a7ff"
      end,
      on_highlights = function(hl, c)
        -- Base UI
        hl.WinSeparator = { fg = "#1b2436" }
        hl.CursorLine = { bg = "#0d1117" }
        hl.CursorLineNr = { fg = "#c4a7ff", bold = true }
        hl.LineNr = { fg = "#283350" }
        hl.Visual = { bg = "#1e2d4a" }
        hl.VisualNOS = { bg = "#1e2d4a" }

        -- Floats and popups
        hl.FloatBorder = { fg = "#c4a7ff", bg = "NONE" }
        hl.FloatTitle = { fg = "#c4a7ff", bold = true }
        hl.NormalFloat = { bg = "#0b0f1a" }

        -- Search
        hl.Search = { bg = "#2e1f5e", fg = "#e2e8f0" }
        hl.IncSearch = { bg = "#c4a7ff", fg = "#06080f", bold = true }
        hl.CurSearch = { bg = "#c4a7ff", fg = "#06080f", bold = true }

        -- Diagnostics: subtle colored backgrounds
        hl.DiagnosticVirtualTextError = { fg = "#f472b6", bg = "#1a0e18" }
        hl.DiagnosticVirtualTextWarn = { fg = "#fde68a", bg = "#1a180e" }
        hl.DiagnosticVirtualTextInfo = { fg = "#56d4e0", bg = "#0e1a1a" }
        hl.DiagnosticVirtualTextHint = { fg = "#6ee7a0", bg = "#0e1a12" }

        -- Snacks indent / scope
        hl.SnacksIndent = { fg = "#141b2d" }
        hl.SnacksIndentScope = { fg = "#2e3d5f" }

        -- Snacks words (replaces illuminate)
        hl.SnacksWordsCurrent = { bg = "#1e2d4a", bold = true }
        hl.SnacksWords = { bg = "#151c2e" }

        -- Which-key
        hl.WhichKey = { fg = "#c4a7ff" }
        hl.WhichKeyDesc = { fg = "#e2e8f0" }
        hl.WhichKeyGroup = { fg = "#56d4e0" }
        hl.WhichKeySeparator = { fg = "#3b4566" }

        -- Git signs
        hl.GitSignsAdd = { fg = "#6ee7a0" }
        hl.GitSignsChange = { fg = "#56d4e0" }
        hl.GitSignsDelete = { fg = "#f472b6" }

        -- blink.cmp completion
        hl.BlinkCmpMenu = { bg = "#0b0f1a" }
        hl.BlinkCmpMenuBorder = { fg = "#232f4a" }
        hl.BlinkCmpMenuSelection = { bg = "#1e2d4a" }
        hl.BlinkCmpLabel = { fg = "#e2e8f0" }
        hl.BlinkCmpLabelMatch = { fg = "#c4a7ff", bold = true }
        hl.BlinkCmpKind = { fg = "#64748b" }
        hl.BlinkCmpDoc = { bg = "#0b0f1a" }
        hl.BlinkCmpDocBorder = { fg = "#232f4a" }
        hl.BlinkCmpSignatureHelp = { bg = "#0b0f1a" }
        hl.BlinkCmpSignatureHelpBorder = { fg = "#232f4a" }

        -- Snacks notifier
        hl.SnacksNotifierInfo = { fg = "#56d4e0" }
        hl.SnacksNotifierWarn = { fg = "#fde68a" }
        hl.SnacksNotifierError = { fg = "#f472b6" }

        -- ---- SYNTAX (blue-purple dominant, teal + mint accents) ----

        -- Keywords: soft purple, italic
        hl["@keyword"] = { fg = "#c4a7ff", italic = true }
        hl["@keyword.return"] = { fg = "#f472b6", italic = true }
        hl["@keyword.function"] = { fg = "#c4a7ff", italic = true }
        hl["@keyword.operator"] = { fg = "#89b4fa" }
        hl["@keyword.import"] = { fg = "#c4a7ff", italic = true }
        hl["@keyword.conditional"] = { fg = "#c4a7ff", italic = true }

        -- Functions: clean blue
        hl["@function"] = { fg = "#89b4fa" }
        hl["@function.call"] = { fg = "#89b4fa" }
        hl["@function.method"] = { fg = "#89b4fa" }
        hl["@function.method.call"] = { fg = "#89b4fa" }
        hl["@function.builtin"] = { fg = "#7dcfff" }

        -- Variables
        hl["@variable"] = { fg = "#e2e8f0" }
        hl["@variable.parameter"] = { fg = "#fdba74", italic = true }
        hl["@variable.member"] = { fg = "#89b4fa" }

        -- Types: teal
        hl["@type"] = { fg = "#56d4e0" }
        hl["@type.builtin"] = { fg = "#56d4e0", italic = true }

        -- Constants / numbers: warm orange
        hl["@constant"] = { fg = "#fdba74" }
        hl["@constant.builtin"] = { fg = "#fdba74", italic = true }
        hl["@number"] = { fg = "#fdba74" }
        hl["@boolean"] = { fg = "#fdba74" }

        -- Strings: mint green
        hl["@string"] = { fg = "#6ee7a0" }
        hl["@string.escape"] = { fg = "#56d4e0" }
        hl["@string.regex"] = { fg = "#fde68a" }

        -- Properties / operators: blue
        hl["@property"] = { fg = "#89b4fa" }
        hl["@operator"] = { fg = "#89b4fa" }

        -- Comments: muted, italic
        hl["@comment"] = { fg = "#3b4566", italic = true }
        hl["@comment.todo"] = { fg = "#fde68a", bold = true }
        hl["@comment.note"] = { fg = "#56d4e0", bold = true }

        -- JSX / HTML tags
        hl["@tag"] = { fg = "#89b4fa" }
        hl["@tag.builtin"] = { fg = "#56d4e0" }
        hl["@tag.attribute"] = { fg = "#c4a7ff" }
        hl["@tag.delimiter"] = { fg = "#3b4566" }
        hl["@punctuation.bracket"] = { fg = "#94a3b8" }
        hl["@punctuation.delimiter"] = { fg = "#64748b" }
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
