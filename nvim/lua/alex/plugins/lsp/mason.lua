return {
  "mason-org/mason.nvim", -- migrado de williamboman (v2, mayo 2025)
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    if vim.env.DOTFILES_DOCTOR ~= "1" then
      -- mason-lspconfig: only used for ensure_installed now.
      -- Server setup/handlers are gone; vim.lsp.config() + vim.lsp.enable() handle that.
      require("mason-lspconfig").setup({
        automatic_enable = false, -- we use vim.lsp.enable() in lspconfig.lua, not mason-lspconfig's auto-enable
        ensure_installed = {
          -- JS/TS (core YOUR-ORG stack)
          "vtsls",
          "eslint",
          "cssls",
          "html",
          "emmet_language_server",
          -- Data / API
          "graphql",
          "prismals",
          "jsonls",
          "yamlls",
          -- Shopify
          "shopify_theme_ls",
          -- Go (SmoothMQ)
          "gopls",
          -- Rust (rust_analyzer lo arranca rustaceanvim, NO va en vim.lsp.enable)
          "rust_analyzer",
          -- TOML (Cargo.toml con schema, igual que jsonls/yamlls con schemastore)
          "taplo",
          -- Python (YOUR-ORG-brain / LangGraph)
          "pyright",
          -- Lua (nvim config)
          "lua_ls",
        },
        -- No handlers! Server config is now in lspconfig.lua via vim.lsp.config()
      })

      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Formatters
          "prettier",
          "stylua",
          "ruff",
          -- Linters (eslint_d eliminado: el LSP eslint cubre JS/TS)
          "golangci-lint",
          "shellcheck",
          "hadolint",
          -- Debuggers
          "js-debug-adapter",
          "codelldb",
          "delve",
          -- AI: Copilot LSP para sidekick.nvim (NES + inline_completion nativa)
          "copilot-language-server",
        },
      })
    end
  end,
}
