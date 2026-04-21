return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    {
      "<leader>sF",
      function()
        require("grug-far").open()
      end,
      desc = "Find and Replace (grug-far)",
      mode = { "n", "v" },
    },
  },
  opts = { headerMaxWidth = 80 },
}
