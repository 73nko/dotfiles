return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    -- Recommended for `ask()` and `select()`.
    -- Required for `snacks` provider.
    ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true

    local keymap = vim.keymap -- for conciseness

    -- AI Keymaps (using <leader>a prefix)

    -- Ask/Chat (@this context)
    keymap.set({ "n", "x" }, "<leader>aa", function()
      require("opencode").ask("@this: ", { submit = true })
    end, { desc = "AI: Ask (@this)" })

    -- Select/Execute Action
    keymap.set({ "n", "x" }, "<leader>as", function()
      require("opencode").select()
    end, { desc = "AI: Select Action" })

    -- Add to Context
    keymap.set({ "n", "x" }, "<leader>ac", function()
      require("opencode").prompt("@this")
    end, { desc = "AI: Add to Context" })

    -- Toggle AI Window
    keymap.set({ "n", "t" }, "<leader>at", function()
      require("opencode").toggle()
    end, { desc = "AI: Toggle Window" })

    -- Scroll AI Window
    keymap.set("n", "<leader>au", function()
      require("opencode").command("session.half.page.up")
    end, { desc = "AI: Scroll Up" })

    keymap.set("n", "<leader>ad", function()
      require("opencode").command("session.half.page.down")
    end, { desc = "AI: Scroll Down" })
  end,
}
