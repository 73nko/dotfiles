-- Claude Code CLI via Snacks terminal
return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>ac",
      function()
        Snacks.terminal.toggle("claude", {
          win = { position = "right", width = 0.4, border = "rounded" },
        })
      end,
      desc = "Toggle Claude Code",
    },
  },
  init = function()
    vim.o.autoread = true
  end,
}
