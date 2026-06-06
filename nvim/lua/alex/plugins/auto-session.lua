return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      auto_restore = false,
      suppressed_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
    })

    local keymap = vim.keymap

    -- Movidos de <leader>w* a <leader>S* (2026-06): <leader>wr/<leader>ws hacian
    -- de <leader>w un prefijo, y el save (el keymap mas usado del setup) pagaba
    -- 300ms de timeoutlen en CADA guardado. Ahora <leader>w es instantaneo.
    keymap.set("n", "<leader>Sr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
    keymap.set("n", "<leader>Ss", "<cmd>SessionSave<CR>", { desc = "Save session for cwd" })
  end,
}
