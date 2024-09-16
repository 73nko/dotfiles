return {
  {
    "codota/tabnine-nvim",
    build = "./dl_binaries.sh",
    config = function()
      local tabnine = require("tabnine")
      tabnine.setup({
        disable_auto_comment = true,
        accept_keymap = "<Tab>",
        dismiss_keymap = "<C-]>",
        debounce_ms = 800,
        suggestion_color = {
          gui = "#808080",
          cterm = 244,
        },
        exclude_filetypes = { "TelescopePrompt", "NvimTree" },
        log_file_path = nil, -- absolute path to Tabnine log file
        ignore_certificate_errors = false,
      })
    end,
  },
  -- {
  --   "github/copilot.vim",
  --   config = function()
  --     vim.keymap.set("i", "<C-J>", 'copilot#Accept("")', {
  --       expr = true,
  --       replace_keycodes = false,
  --     })
  --     vim.keymap.set("i", "<C-L>", "<Plug>(copilot-accept-word)")
  --     vim.keymap.set("i", "<M-q>", "<ESC>:Copilot panel<CR>")
  --     vim.keymap.set("n", "<M-q>", ":Copilot panel<CR>")
  --
  --     vim.g.copilot_no_tab_map = true
  --     vim.g.copilot_hide_during_completion = false
  --   end,
  -- },
}
