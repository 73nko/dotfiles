return {
  "neovim/nvim-lspconfig",
  lazy = false, -- must load early so lsp/<server>.lua definitions are in runtimepath for vim.lsp.config()
  dependencies = {
    "saghen/blink.cmp",
    { "williamboman/mason.nvim" },
    { "b0o/schemastore.nvim" },
    {
      "antosha417/nvim-lsp-file-operations",
      config = true,
    },
  },
  -- NOTE: mason-lspconfig removed as a dependency here.
  -- The new pattern uses vim.lsp.config() + vim.lsp.enable() directly.
  -- nvim-lspconfig just provides server definitions in lsp/ runtimepath.
  config = function()
    -- blink.cmp capabilities (sent to all servers via wildcard config)
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    -----------------------------------------------------------------
    -- 1. Global config for ALL servers
    -----------------------------------------------------------------
    vim.lsp.config("*", {
      capabilities = capabilities,
      root_markers = { ".git" },
    })

    -----------------------------------------------------------------
    -- 2. Per-server overrides (replaces lspconfig[server].setup({}))
    -----------------------------------------------------------------
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          completion = { callSnippet = "Replace" },
        },
      },
    })

    vim.lsp.config("vtsls", {
      settings = {
        vtsls = { autoUseWorkspaceTsdk = true },
        typescript = {
          preferences = { importModuleSpecifier = "non-relative" },
          inlayHints = {
            parameterNames = { enabled = "all" },
            parameterTypes = { enabled = true },
            variableTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
          },
        },
      },
    })

    vim.lsp.config("gopls", {
      settings = {
        gopls = {
          completeUnimported = true,
          usePlaceholders = true,
          analyses = { unusedparams = true },
        },
      },
    })

    vim.lsp.config("graphql", {
      filetypes = { "graphql", "gql", "typescriptreact", "javascriptreact" },
    })

    vim.lsp.config("emmet_language_server", {
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    })

    vim.lsp.config("cssls", {
      settings = {
        css = { validate = true },
        scss = { validate = true },
      },
      init_options = { provideFormatter = false },
    })

    vim.lsp.config("jsonls", {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    })

    vim.lsp.config("yamlls", {
      settings = {
        yaml = {
          schemaStore = { enable = false, url = "" },
          schemas = require("schemastore").yaml.schemas(),
          validate = true,
          completion = true,
        },
      },
    })

    -- rust_analyzer is handled by rustaceanvim, so NOT listed in enable()

    -----------------------------------------------------------------
    -- 3. Enable all servers (auto-attaches to matching filetypes)
    -----------------------------------------------------------------
    vim.lsp.enable({
      "lua_ls",
      "vtsls",
      "eslint",
      "cssls",
      "html",
      "emmet_language_server",
      "graphql",
      "prismals",
      "jsonls",
      "yamlls",
      "shopify_theme_ls",
      "gopls",
      "pyright",
    })

    -----------------------------------------------------------------
    -- 4. Keymaps (LspAttach) - only custom ones, defaults handled by Neovim 0.12
    -----------------------------------------------------------------
    -- Built-in defaults (DO NOT remap, they just work):
    --   K          -> hover
    --   grn        -> rename
    --   gra        -> code action
    --   grr        -> references
    --   gri        -> implementation
    --   grt        -> type definition
    --   gO         -> document symbols
    --   <C-s> (i)  -> signature help

    local keymap = vim.keymap

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        -- Override defaults with Snacks picker for better UI
        opts.desc = "Show LSP references (Snacks)"
        keymap.set("n", "grr", function() Snacks.picker.lsp_references() end, opts)

        opts.desc = "Show LSP definitions (Snacks)"
        keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP implementations (Snacks)"
        keymap.set("n", "gri", function() Snacks.picker.lsp_implementations() end, opts)

        opts.desc = "Show LSP type definitions (Snacks)"
        keymap.set("n", "grt", function() Snacks.picker.lsp_type_definitions() end, opts)

        -- Keep custom leader keymaps for muscle memory
        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        -- Diagnostics
        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>cD", function() Snacks.picker.diagnostics({ buf = 0 }) end, opts)

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, opts)

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, opts)

        opts.desc = "Go to previous error"
        keymap.set("n", "[e", function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end, opts)

        opts.desc = "Go to next error"
        keymap.set("n", "]e", function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end, opts)

        -- Restart LSP (now uses built-in :lsp command)
        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", "<cmd>lsp restart<CR>", opts)

        -- Split definitions
        opts.desc = "Open definition in horizontal split"
        keymap.set("n", "<leader>shd", function()
          vim.cmd("split")
          Snacks.picker.lsp_definitions()
        end, opts)

        opts.desc = "Open definition in vertical split"
        keymap.set("n", "<leader>svd", function()
          vim.cmd("vsplit")
          Snacks.picker.lsp_definitions()
        end, opts)
      end,
    })

    -----------------------------------------------------------------
    -- 5. Diagnostic config
    -----------------------------------------------------------------
    local signs = {
      Error = " ",
      Warn = " ",
      Hint = "󰠠 ",
      Info = " ",
    }
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = signs.Error,
          [vim.diagnostic.severity.WARN] = signs.Warn,
          [vim.diagnostic.severity.HINT] = signs.Hint,
          [vim.diagnostic.severity.INFO] = signs.Info,
        },
      },
    })
  end,
}
