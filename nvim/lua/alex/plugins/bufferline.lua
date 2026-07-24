-- Bufferline - pill tabs, Violet Hour · Glass (guia §05, maqueta "Preview target")
-- Active: ice pill (bg branch_bg, fg ice), inset ring
-- Inactive: silver 58% (muted)
-- Modified dot: orchid
return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  event = "VeryLazy",
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
    -- Snacks.bufdelete preserva el layout de ventanas (:bd pelado lo destruia)
    { "<leader>bc", function() Snacks.bufdelete() end, desc = "Close Current Buffer" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
  },
  opts = function()
    local c = require("alex.themes.violet-hour").palette
    return {
      options = {
        mode = "buffers",
        diagnostics = false, -- la maqueta (§05) no lleva contadores en tabs; viven en statusline/gutter
        always_show_bufferline = false,
        show_close_icon = false,
        show_buffer_close_icons = false,
        separator_style = { "", "" }, -- medias lunas: pill con caps redondos
        indicator = { style = "none" },
        offsets = {
          {
            filetype = "snacks_layout_box",
            text = " Explorer",
            text_align = "left",
            separator = true,
            highlight = "Directory",
          },
        },
        modified_icon = "●",
      },
      highlights = {
        -- Barra completa
        fill       = { fg = c.muted, bg = c.none },
        background = { fg = c.muted, bg = c.none },

        -- Tab inactive / visible / selected
        buffer_selected = { fg = c.ice, bg = c.branch_bg, bold = true, italic = false },
        buffer_visible  = { fg = c.muted, bg = c.none },

        -- Modified dot
        modified          = { fg = c.orchid, bg = c.none },
        modified_selected = { fg = c.orchid, bg = c.branch_bg },
        modified_visible  = { fg = c.orchid, bg = c.none },

        -- Diagnostic indicators on tab (err/warn/info/hint)
        error            = { fg = c.rose_mist,  bg = c.none },
        error_selected   = { fg = c.rose_mist,  bg = c.branch_bg, bold = true },
        warning          = { fg = c.bloom,      bg = c.none },
        warning_selected = { fg = c.bloom,      bg = c.branch_bg, bold = true },
        info             = { fg = c.cyan_mist,  bg = c.none },
        info_selected    = { fg = c.cyan_mist,  bg = c.branch_bg, bold = true },
        hint             = { fg = c.periwinkle, bg = c.none },
        hint_selected    = { fg = c.periwinkle, bg = c.branch_bg, bold = true },

        -- Separators - transparent, pill shape comes from bg only
        separator          = { fg = c.night, bg = c.none },
        separator_selected = { fg = c.branch_bg, bg = c.none },
        separator_visible  = { fg = c.night, bg = c.none },

        -- Indicator / close
        indicator_selected    = { fg = c.ice,    bg = c.branch_bg },
        close_button          = { fg = c.muted,  bg = c.none },
        close_button_selected = { fg = c.orchid, bg = c.branch_bg },
        close_button_visible  = { fg = c.muted,  bg = c.none },

        -- Tabs (group headers / pinned)
        tab                    = { fg = c.muted, bg = c.none },
        tab_selected           = { fg = c.lilac, bg = c.branch_bg, bold = true },
        tab_separator          = { fg = c.none,  bg = c.none },
        tab_separator_selected = { fg = c.none,  bg = c.none },
        duplicate              = { fg = c.muted, bg = c.none, italic = true },
        duplicate_selected     = { fg = c.ice,   bg = c.branch_bg, bold = true, italic = true },

        -- Numbers
        numbers          = { fg = c.muted, bg = c.none },
        numbers_selected = { fg = c.ice,   bg = c.branch_bg, bold = true },

        -- Pick
        pick          = { fg = c.orchid, bg = c.none, bold = true, italic = true },
        pick_selected = { fg = c.orchid, bg = c.branch_bg, bold = true },
        pick_visible  = { fg = c.orchid, bg = c.none, bold = true, italic = true },
      },
    }
  end,
}
