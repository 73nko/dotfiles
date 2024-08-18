return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = { "windwp/nvim-ts-autotag", "nvim-treesitter/playground", "nvim-treesitter/nvim-treesitter-refactor" },
  config = function()
    -- Importar el plugin nvim-treesitter
    local treesitter = require("nvim-treesitter.configs")

    -- Configuración de nvim-treesitter
    treesitter.setup({
      -- Habilitar resaltado de sintaxis
      highlight = {
        enable = true,
      },
      -- Habilitar indentación basada en el árbol sintáctico
      indent = {
        enable = true,
      },
      -- Habilitar autotagging (con el plugin nvim-ts-autotag)
      autotag = {
        enable = true,
      },
      -- Asegurar que estos parsers de lenguaje estén instalados
      ensure_installed = {
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
      },
      -- Selección incremental
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      sync_install = false,
      -- Configuración del playground
      playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Tiempo de espera para resaltar nodos en el playground
        persist_queries = false, -- Si las consultas persisten entre sesiones de vim
      },
      -- Text objects basados en la sintaxis
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
      },
      -- Refactor (renombrado inteligente y más)
      refactor = {
        highlight_definitions = {
          enable = true,
        },
        highlight_current_scope = {
          enable = false,
        },
        smart_rename = {
          enable = true,
          keymaps = {
            smart_rename = "grr",
          },
        },
      },
    })
  end,
}
