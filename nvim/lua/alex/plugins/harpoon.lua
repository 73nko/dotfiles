return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    local keymap = vim.keymap.set

    keymap("n", "<leader>ma", function() harpoon:list():add() end, { desc = "Harpoon add file" })
    keymap("n", "<leader>mm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon toggle menu" })

    keymap("n", "<leader>mj", function() harpoon:list():next() end, { desc = "Harpoon next file" })
    keymap("n", "<leader>mk", function() harpoon:list():prev() end, { desc = "Harpoon previous file" })

    for i = 1, 4 do
      keymap("n", string.format("<leader>m%d", i), function()
        harpoon:list():select(i)
      end, { desc = string.format("Harpoon go to file %d", i) })
    end
  end,
}
