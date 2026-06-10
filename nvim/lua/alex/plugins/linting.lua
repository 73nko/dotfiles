return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      -- JS/TS eliminados: el LSP `eslint` (vim.lsp.enable) ya da diagnosticos
      -- + code actions. Tener eslint_d aqui duplicaba cada warning.
      python = { "ruff" },
      go = { "golangci-lint" },
      sh = { "shellcheck" },
      dockerfile = { "hadolint" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    -- InsertLeave eliminado (2026-06): re-lintar en cada escape de insert era
    -- ruido y procesos extra en ficheros grandes. BufEnter + write bastan.
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
