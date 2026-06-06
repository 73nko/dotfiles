-- crates.nvim: el package-info.nvim de Cargo.toml.
-- Versiones disponibles inline, features, actualizaciones, docs y code actions.
return {
  "saecki/crates.nvim",
  event = { "BufRead Cargo.toml" },
  tag = "stable",
  config = function()
    local crates = require("crates")

    crates.setup({
      lsp = {
        enabled = true, -- servidor in-process: completions + code actions en Cargo.toml
        actions = true,
        completion = true,
        hover = true,
      },
      completion = {
        crates = {
          enabled = true, -- completion de nombres de crates desde crates.io
        },
      },
    })

    -- Keymaps solo en Cargo.toml (buffer-local via autocmd)
    vim.api.nvim_create_autocmd("BufRead", {
      group = vim.api.nvim_create_augroup("crates_keymaps", { clear = true }),
      pattern = "Cargo.toml",
      callback = function(args)
        local opts = { silent = true, buffer = args.buf }

        opts.desc = "Crates: toggle versiones"
        vim.keymap.set("n", "<leader>Ct", crates.toggle, opts)
        opts.desc = "Crates: actualizar info"
        vim.keymap.set("n", "<leader>Cr", crates.reload, opts)
        opts.desc = "Crates: versiones del crate"
        vim.keymap.set("n", "<leader>Cv", crates.show_versions_popup, opts)
        opts.desc = "Crates: features del crate"
        vim.keymap.set("n", "<leader>Cf", crates.show_features_popup, opts)
        opts.desc = "Crates: update crate (compatible)"
        vim.keymap.set("n", "<leader>Cu", crates.update_crate, opts)
        opts.desc = "Crates: upgrade crate (ultima version)"
        vim.keymap.set("n", "<leader>CU", crates.upgrade_crate, opts)
        opts.desc = "Crates: upgrade TODOS los crates"
        vim.keymap.set("n", "<leader>CA", crates.upgrade_all_crates, opts)
        opts.desc = "Crates: abrir docs.rs"
        vim.keymap.set("n", "<leader>Cd", crates.open_documentation, opts)
        opts.desc = "Crates: abrir crates.io"
        vim.keymap.set("n", "<leader>Cc", crates.open_crates_io, opts)
      end,
    })
  end,
}
