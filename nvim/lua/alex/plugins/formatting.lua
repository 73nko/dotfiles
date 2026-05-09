return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        python = { "ruff_format", "ruff_organize_imports" },
        go = { "gofmt" },
        rust = { "rustfmt" },
      },
      -- format_after_save corre en BufWritePost (async por diseno). NO bloquea
      -- la UI: guardas, fichero llega a disco crudo, conform formatea y reescribe.
      -- Doble write por save, irrelevante para hot-reload moderno.
      --
      -- format_on_save (sync, BufWritePre) NO acepta async=true; es restriccion
      -- de la API de conform porque modifica el buffer antes de escribirlo.
      -- Si en algun caso necesitas escritura unica formateada, usa <leader>cf
      -- manual (sync con timeout abajo).
      format_after_save = {
        lsp_format = "fallback",
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>cf", function()
      conform.format({
        lsp_format = "fallback",
        async = false,
        timeout_ms = 2000,
      })
    end, {
      desc = "Format file or range (in visual mode)",
    })
  end,
}
