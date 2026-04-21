return {
  "supermaven-inc/supermaven-nvim",
  event = "InsertEnter",
  config = function()
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion = "<C-]>",
        accept_word = "<M-l>",
      },
      ignore_filetypes = { "snacks_picker_input", "snacks_dashboard" },
      color = {
        suggestion_color = "#6c7086", -- subtle grey (Catppuccin surface2)
        cterm = 244,
      },
      log_level = "off",
      disable_inline_completion = false,
      disable_keymaps = false,
    })
  end,
}
