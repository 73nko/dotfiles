return {
  "RRethy/vim-illuminate",
  config = function()
    require("illuminate").configure({
      providers = { "lsp", "treesitter", "regex" },
      delay = 100,
      filetypes_denylist = {
        "dirvish", "fugitive", "NvimTree", "alpha", "dashboard", "qf",
      },
      under_cursor = true,
    })

    -- keymaps must live in config, not in `keys` table (illuminate uses non-standard format)
    vim.keymap.set("n", "<A-n>", function()
      require("illuminate").next_reference({ wrap = true })
    end, { desc = "Illuminate next reference" })

    vim.keymap.set("n", "<A-p>", function()
      require("illuminate").next_reference({ reverse = true, wrap = true })
    end, { desc = "Illuminate previous reference" })
  end,
}
