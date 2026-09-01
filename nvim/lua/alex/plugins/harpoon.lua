return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>ma",
      function()
        require("harpoon"):list():add()
      end,
      desc = "Harpoon add file",
    },
    {
      "<leader>mm",
      function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "Harpoon toggle menu",
    },
    {
      "<leader>mj",
      function()
        require("harpoon"):list():next()
      end,
      desc = "Harpoon next file",
    },
    {
      "<leader>mk",
      function()
        require("harpoon"):list():prev()
      end,
      desc = "Harpoon previous file",
    },
    {
      "<leader>m1",
      function()
        require("harpoon"):list():select(1)
      end,
      desc = "Harpoon go to file 1",
    },
    {
      "<leader>m2",
      function()
        require("harpoon"):list():select(2)
      end,
      desc = "Harpoon go to file 2",
    },
    {
      "<leader>m3",
      function()
        require("harpoon"):list():select(3)
      end,
      desc = "Harpoon go to file 3",
    },
    {
      "<leader>m4",
      function()
        require("harpoon"):list():select(4)
      end,
      desc = "Harpoon go to file 4",
    },
  },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()
  end,
}
