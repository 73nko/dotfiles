return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "saghen/blink.cmp",
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "b0o/schemastore.nvim" },
    {
      "antosha417/nvim-lsp-file-operations",
      config = true,
    },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")

    -- blink.cmp provides capabilities (replaces cmp-nvim-lsp)
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    local keymap = vim.keymap

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        -- Navigation (single source of truth - removed duplicates from snacks.lua)
        opts.desc = "Show LSP references"
        keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", function() Snacks.picker.lsp_implementations() end, opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", function() Snacks.picker.lsp_type_definitions() end, opts)

        -- Actions
        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        -- Diagnostics (moved line diag from <leader>d to <leader>cd to avoid collision with debug prefix)
        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>cD", function() Snacks.picker.diagnostics({ buf = 0 }) end, opts)

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)

        -- Diagnostic navigation (use vim.diagnostic.jump instead of deprecated goto_prev/goto_next)
        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, opts)

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, opts)

        opts.desc = "Go to previous error"
        keymap.set("n", "[e", function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end, opts)

        opts.desc = "Go to next error"
        keymap.set("n", "]e", function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end, opts)

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        -- Signature help (replaces lsp_signature.nvim plugin)
        opts.desc = "Signature help"
        keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

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

    -- Diagnostic signs (modern API)
    local signs = {
      Error = " ",
      Warn = " ",
      Hint = "󰠠 ",
      Info = " ",
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

    mason_lspconfig.setup({
      -- default handler for installed servers
      function(server_name)
        if server_name == "rust_analyzer" then
            return -- Skip rust_analyzer (handled by rustaceanvim)
        end
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
      end,
      ["graphql"] = function()
        -- configure graphql language server
        lspconfig["graphql"].setup({
          capabilities = capabilities,
          filetypes = { "graphql", "gql", "typescriptreact", "javascriptreact" },
        })
      end,
      ["emmet_language_server"] = function()
        -- emmet-language-server (replaces archived emmet_ls)
        lspconfig["emmet_language_server"].setup({
          capabilities = capabilities,
          filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
        })
      end,
      ["lua_ls"] = function()
        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              -- make the language server recognize "vim" global
              diagnostics = {
                globals = { "vim" },
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        })
      end,
      ["gopls"] = function()
        lspconfig["gopls"].setup({
          capabilities = capabilities,
          settings = {
            gopls = {
              completeUnimported = true,
              usePlaceholders = true,
              analyses = {
                unusedparams = true,
              },
            },
          },
        })
      end,
      ["vtsls"] = function()
        -- vtsls (replaces ts_ls - faster, better monorepo support)
        lspconfig["vtsls"].setup({
          capabilities = capabilities,
          settings = {
            vtsls = {
              autoUseWorkspaceTsdk = true,
            },
            typescript = {
              preferences = {
                importModuleSpecifier = "non-relative",
              },
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
      end,
      ["cssls"] = function()
        lspconfig["cssls"].setup({
          capabilities = capabilities,
          settings = {
            css = { validate = true },
            scss = { validate = true },
          },
          init_options = {
            provideFormatter = false, -- let prettier handle formatting
          },
        })
      end,
      ["jsonls"] = function()
        lspconfig["jsonls"].setup({
          capabilities = capabilities,
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        })
      end,
      ["yamlls"] = function()
        lspconfig["yamlls"].setup({
          capabilities = capabilities,
          settings = {
            yaml = {
              schemaStore = { enable = false, url = "" },
              schemas = require("schemastore").yaml.schemas(),
              validate = true,
              completion = true,
            },
          },
        })
      end,
      ["theme_check"] = function()
        lspconfig["theme_check"].setup({
          capabilities = capabilities,
        })
      end,
    })
  end,
}
