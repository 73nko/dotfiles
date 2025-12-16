return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("harpoon").setup({
      menu = {
        width = math.floor(vim.o.columns * 0.3),
      },
    })

    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")
    local keymap = vim.keymap.set

    keymap("n", "<leader>ma", mark.add_file, { desc = "Harpoon add file" })
    keymap("n", "<leader>mm", ui.toggle_quick_menu, { desc = "Harpoon toggle menu" })

    keymap("n", "<leader>mj", ui.nav_next, { desc = "Harpoon next file" })
    keymap("n", "<leader>mk", ui.nav_prev, { desc = "Harpoon previous file" })

    for i = 1, 4 do
      local index = i
      keymap("n", string.format("<leader>m%d", index), function()
        ui.nav_file(index)
      end, { desc = string.format("Harpoon go to file %d", index) })
    end
  end,
}
