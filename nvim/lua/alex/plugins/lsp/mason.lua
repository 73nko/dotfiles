return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
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
        -- Rust
        "rust_analyzer",
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
        -- Linters
        "eslint_d",
        "golangci-lint",
        "shellcheck",
        "hadolint",
        -- Debuggers
        "js-debug-adapter",
        "codelldb",
        "delve",
      },
    })
  end,
}
