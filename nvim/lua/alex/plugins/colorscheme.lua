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
        -- Neon Nocturne — surface architecture (The Luminous Editor)
        c.bg = "#0a0e14"            -- surface (Layer 1)
        c.bg_dark = "#000000"       -- surface-container-lowest
        c.bg_float = "#1b2028"      -- surface-container-high (Layer 3)
        c.bg_popup = "#1b2028"      -- surface-container-high (Layer 3)
        c.bg_sidebar = "#0f141a"    -- surface-container-low (Layer 2)
        c.bg_statusline = "#151a21" -- surface-container
        c.bg_highlight = "#0f141a"  -- surface-container-low
        c.fg_gutter = "#1b2028"     -- surface-container-high
        c.border = "#151a21"        -- ghost border (subtle)
        c.border_highlight = "#81d4fa" -- primary
      end,
      on_highlights = function(hl, c)
        -- Base UI — boundaries via background shifts (No-Line Rule)
        hl.WinSeparator = { fg = "#151a21" }
        hl.CursorLine = { bg = "#0f141a" }
        hl.CursorLineNr = { fg = "#81d4fa", bold = true }
        hl.LineNr = { fg = "#1b2028" }
        hl.Visual = { bg = "#24502c" }
        hl.VisualNOS = { bg = "#24502c" }

        -- Floats and popups — surface-container-high (Layer 3)
        hl.FloatBorder = { fg = "#81d4fa", bg = "NONE" }
        hl.FloatTitle = { fg = "#81d4fa", bold = true }
        hl.NormalFloat = { bg = "#1b2028" }

        -- Search — primary accent
        hl.Search = { bg = "#1a3040", fg = "#f1f3fc" }
        hl.IncSearch = { bg = "#81d4fa", fg = "#0a0e14", bold = true }
        hl.CurSearch = { bg = "#81d4fa", fg = "#0a0e14", bold = true }

        -- Diagnostics: subtle tinted backgrounds
        hl.DiagnosticVirtualTextError = { fg = "#ffa8a3", bg = "#1a0a0a" }
        hl.DiagnosticVirtualTextWarn = { fg = "#ffd54f", bg = "#1a180e" }
        hl.DiagnosticVirtualTextInfo = { fg = "#81d4fa", bg = "#0e141a" }
        hl.DiagnosticVirtualTextHint = { fg = "#abddad", bg = "#0e1a12" }

        -- Snacks indent / scope
        hl.SnacksIndent = { fg = "#0f141a" }
        hl.SnacksIndentScope = { fg = "#1b2028" }

        -- Snacks words
        hl.SnacksWordsCurrent = { bg = "#24502c", bold = true }
        hl.SnacksWords = { bg = "#0f141a" }

        -- Which-key
        hl.WhichKey = { fg = "#81d4fa" }
        hl.WhichKeyDesc = { fg = "#f1f3fc" }
        hl.WhichKeyGroup = { fg = "#b39ddb" }
        hl.WhichKeySeparator = { fg = "#3d4f6e" }

        -- Git signs — secondary green for success
        hl.GitSignsAdd = { fg = "#abddad" }
        hl.GitSignsChange = { fg = "#81d4fa" }
        hl.GitSignsDelete = { fg = "#ffa8a3" }

        -- blink.cmp — floating glass (surface-container-high)
        hl.BlinkCmpMenu = { bg = "#1b2028" }
        hl.BlinkCmpMenuBorder = { fg = "#232a33" }
        hl.BlinkCmpMenuSelection = { bg = "#24502c" }
        hl.BlinkCmpLabel = { fg = "#f1f3fc" }
        hl.BlinkCmpLabelMatch = { fg = "#81d4fa", bold = true }
        hl.BlinkCmpKind = { fg = "#5a6580" }
        hl.BlinkCmpDoc = { bg = "#1b2028" }
        hl.BlinkCmpDocBorder = { fg = "#232a33" }
        hl.BlinkCmpSignatureHelp = { bg = "#1b2028" }
        hl.BlinkCmpSignatureHelpBorder = { fg = "#232a33" }

        -- Snacks notifier
        hl.SnacksNotifierInfo = { fg = "#81d4fa" }
        hl.SnacksNotifierWarn = { fg = "#ffd54f" }
        hl.SnacksNotifierError = { fg = "#ffa8a3" }

        -- ---- SYNTAX (Neon Nocturne: primary blue logic, lilac meta, green growth) ----

        -- Keywords: tertiary lilac, italic (meta elements)
        hl["@keyword"] = { fg = "#b39ddb", italic = true }
        hl["@keyword.return"] = { fg = "#ffa8a3", italic = true }
        hl["@keyword.function"] = { fg = "#b39ddb", italic = true }
        hl["@keyword.operator"] = { fg = "#81d4fa" }
        hl["@keyword.import"] = { fg = "#b39ddb", italic = true }
        hl["@keyword.conditional"] = { fg = "#b39ddb", italic = true }

        -- Functions: primary light blue (drives the logic)
        hl["@function"] = { fg = "#81d4fa" }
        hl["@function.call"] = { fg = "#81d4fa" }
        hl["@function.method"] = { fg = "#81d4fa" }
        hl["@function.method.call"] = { fg = "#81d4fa" }
        hl["@function.builtin"] = { fg = "#55aacf" }

        -- Variables
        hl["@variable"] = { fg = "#f1f3fc" }
        hl["@variable.parameter"] = { fg = "#ffcc80", italic = true }
        hl["@variable.member"] = { fg = "#81d4fa" }

        -- Types: primary-container
        hl["@type"] = { fg = "#55aacf" }
        hl["@type.builtin"] = { fg = "#55aacf", italic = true }

        -- Constants / numbers: warm amber
        hl["@constant"] = { fg = "#ffcc80" }
        hl["@constant.builtin"] = { fg = "#ffcc80", italic = true }
        hl["@number"] = { fg = "#ffcc80" }
        hl["@boolean"] = { fg = "#ffcc80" }

        -- Strings: secondary green (growth)
        hl["@string"] = { fg = "#abddad" }
        hl["@string.escape"] = { fg = "#55aacf" }
        hl["@string.regex"] = { fg = "#ffd54f" }

        -- Properties / operators: primary blue
        hl["@property"] = { fg = "#81d4fa" }
        hl["@operator"] = { fg = "#81d4fa" }

        -- Comments: blue-tinted muted, italic
        hl["@comment"] = { fg = "#3d4f6e", italic = true }
        hl["@comment.todo"] = { fg = "#ffd54f", bold = true }
        hl["@comment.note"] = { fg = "#81d4fa", bold = true }

        -- JSX / HTML tags
        hl["@tag"] = { fg = "#81d4fa" }
        hl["@tag.builtin"] = { fg = "#55aacf" }
        hl["@tag.attribute"] = { fg = "#b39ddb" }
        hl["@tag.delimiter"] = { fg = "#3d4f6e" }
        hl["@punctuation.bracket"] = { fg = "#8a95aa" }
        hl["@punctuation.delimiter"] = { fg = "#5a6580" }
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
