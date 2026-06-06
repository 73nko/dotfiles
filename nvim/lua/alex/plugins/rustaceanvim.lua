return {
  "mrcjkb/rustaceanvim",
  version = "^9", -- v9.x soporta Neovim 0.12 (v5 era de la era 0.10, APIs deprecadas)
  lazy = false, -- This plugin is already lazy
  config = function()
    vim.g.rustaceanvim = {
      -- Plugin configuration
      -- (test_executor lo gestiona el adapter de neotest registrado en neotest.lua)
      tools = {
      },
      -- LSP configuration
      server = {
        on_attach = function(client, bufnr)
          -- You can set keybindings here if you want specific ones for Rust
          vim.keymap.set("n", "<leader>ca", function()
            vim.cmd.RustLsp("codeAction")
          end, { silent = true, buffer = bufnr, desc = "Rust Code Action" })
          -- Expandir macro bajo el cursor (killer feature de rust-analyzer)
          vim.keymap.set("n", "<leader>cm", function()
            vim.cmd.RustLsp("expandMacro")
          end, { silent = true, buffer = bufnr, desc = "Rust Expand Macro" })
          -- Diagnostico completo renderizado como lo pinta cargo
          vim.keymap.set("n", "<leader>ce", function()
            vim.cmd.RustLsp("renderDiagnostic")
          end, { silent = true, buffer = bufnr, desc = "Rust Render Diagnostic" })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            -- clippy en cada save en vez de solo `cargo check`:
            -- mismos diagnosticos que CI, sin sorpresas en el PR.
            check = { command = "clippy" },
            cargo = { features = "all" },
          },
        },
      },
      -- DAP configuration (codelldb via mason, autodetectado por rustaceanvim)
      dap = {
      },
    }
  end,
}
