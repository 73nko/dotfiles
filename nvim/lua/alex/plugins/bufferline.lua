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
    { "<leader>bc", "<Cmd>bd<CR>", desc = "Close Current Buffer" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
  },
  opts = {
    options = {
      -- mode = "buffers", -- "buffers" is the default
      diagnostics = "nvim_lsp",
      always_show_bufferline = false,
      separator_style = "thin",
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        local s = " "
        for e, n in pairs(diagnostics_dict) do
          local sym = e == "error" and " " or (e == "warning" and " " or "")
          s = s .. n .. sym
        end
        return s
      end,
    },
    highlights = {
      fill = { bg = "#04060b" },
      background = { fg = "#3b4566", bg = "#06080f" },
      buffer_selected = { fg = "#e2e8f0", bg = "#0d1117", bold = true },
      buffer_visible = { fg = "#64748b", bg = "#06080f" },
      close_button = { fg = "#3b4566", bg = "#06080f" },
      close_button_selected = { fg = "#f472b6", bg = "#0d1117" },
      separator = { fg = "#04060b", bg = "#06080f" },
      separator_selected = { fg = "#04060b", bg = "#0d1117" },
      indicator_selected = { fg = "#c4a7ff", bg = "#0d1117" },
      modified = { fg = "#fde68a", bg = "#06080f" },
      modified_selected = { fg = "#fde68a", bg = "#0d1117" },
      tab = { fg = "#3b4566", bg = "#06080f" },
      tab_selected = { fg = "#c4a7ff", bg = "#0d1117", bold = true },
      error_selected = { fg = "#f472b6", bg = "#0d1117", bold = true },
      warning_selected = { fg = "#fde68a", bg = "#0d1117", bold = true },
    },
  },
}
