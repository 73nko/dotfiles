-- Violet Hour · Glass (custom)
-- Colorscheme puro en lua/alex/themes/violet-hour.lua; no requiere plugin externo.
-- Lazy expone un "fake" plugin dir-local para que priority se respete en el orden de carga.

return {
  {
    -- Dummy spec: Lazy no lo descarga, solo asegura que corramos en priority 1000
    name = "violet-hour",
    dir = vim.fn.stdpath("config"),
    priority = 1000,
    lazy = false,
    config = function()
      require("alex.themes.violet-hour").apply()
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
