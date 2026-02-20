return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      ensure_installed = {
        -- JS/TS (core YOUR-ORG stack)
        "ts_ls",
        "eslint",
        "cssls",
        "html",
        "emmet_ls",
        -- Data / API
        "graphql",
        "prismals",
        "jsonls",
        "yamlls",
        -- Shopify
        "theme_check", -- Liquid / Shopify templates
        -- Go (SmoothMQ)
        "gopls",
        -- Rust
        "rust_analyzer",
        -- Python (YOUR-ORG-brain / LangGraph)
        "pyright",
        -- Lua (nvim config)
        "lua_ls",
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        -- Formatters
        "prettier",
        "stylua",
        "ruff",         -- Python formatter + linter (replaces black + isort + pylint)
        -- Linters
        "eslint_d",
        "golangci-lint",
        "shellcheck",   -- shell scripts (deploy scripts, CI hooks)
        "hadolint",     -- Dockerfile (ECS Fargate images)
        -- Debuggers
        "js-debug-adapter",
        "codelldb",     -- Rust
        "delve",        -- Go
      },
    })
  end,
}
