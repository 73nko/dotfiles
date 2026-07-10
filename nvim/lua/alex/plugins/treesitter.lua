return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = { "windwp/nvim-ts-autotag" },
  -- NOTE: nvim-treesitter-refactor removed (archived, all features already disabled in favor of snacks.words + LSP rename)
  config = function()
    require("nvim-treesitter").setup()

    -- Install parsers (replaces ensure_installed)
    local ensure_installed = {
      "json",
      "javascript",
      "typescript",
      "tsx",
      "yaml",
      "html",
      "css",
      "prisma",
      "markdown",
      "markdown_inline",
      "graphql",
      "bash",
      "lua",
      "vim",
      "dockerfile",
      "gitignore",
      "query",
      "vimdoc",
      "go",
      "rust",
    }

    local installed = require("nvim-treesitter.config").get_installed()
    local to_install = vim.iter(ensure_installed)
      :filter(function(parser)
        return not vim.tbl_contains(installed, parser)
      end)
      :totable()

    if vim.env.DOTFILES_DOCTOR ~= "1" and #to_install > 0 then
      require("nvim-treesitter").install(to_install)
    end

    -- Enable treesitter highlighting and indentation for all filetypes
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_setup", { clear = true }),
      callback = function()
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    -- Incremental selection (built-in Neovim 0.12)
    vim.keymap.set("n", "<C-space>", function()
      require("nvim-treesitter.incremental_selection").init_selection()
    end, { desc = "Init treesitter selection" })
    vim.keymap.set("v", "<C-space>", function()
      require("nvim-treesitter.incremental_selection").node_incremental()
    end, { desc = "Increment treesitter selection" })
    vim.keymap.set("v", "<bs>", function()
      require("nvim-treesitter.incremental_selection").node_decremental()
    end, { desc = "Decrement treesitter selection" })
  end,
}
