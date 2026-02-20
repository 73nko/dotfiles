-- Claude Code CLI via Snacks terminal
return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    vim.o.autoread = true

    vim.keymap.set("n", "<leader>ac", function()
      Snacks.terminal.toggle("claude", {
        win = {
          position = "right",
          width = 0.4,
          border = "rounded",
        },
      })
    end, { desc = "Toggle Claude Code" })
  end,
}
