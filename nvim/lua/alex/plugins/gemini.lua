-- Gemini CLI via Snacks terminal (no plugin needed, gemini CLI is in PATH)
return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    -- Gemini terminal toggle
    vim.keymap.set("n", "<leader>ag", function()
      Snacks.terminal.toggle("gemini", {
        win = {
          position = "right",
          width = 0.4,
          border = "rounded",
        },
      })
    end, { desc = "Toggle Gemini CLI" })
  end,
}
