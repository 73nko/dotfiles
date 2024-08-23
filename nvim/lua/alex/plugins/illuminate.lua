return {
  "RRethy/vim-illuminate",

  config = function()
    -- Configura vim-illuminate según tus preferencias
    require("illuminate").configure({
      -- Estas son opciones de configuración, puedes ajustarlas a tu gusto
      providers = {
        "lsp",
        "treesitter",
        "regex",
      },
      delay = 100, -- Tiempo de espera antes de resaltar en milisegundos
      filetypes_denylist = {
        "dirvish",
        "fugitive",
        "NvimTree",
        "packer",
        "alpha",
        "dashboard",
        "NeogitStatus",
        "NeogitPopup",
        "qf",
      },
      under_cursor = true, -- Resaltar también la palabra bajo el cursor
    })
  end,
  keys = {
    ["<A-n>"] = {
      function()
        require("illuminate").next_reference({ wrap = true })
      end,
      "  next reference",
    },
    ["<A-p>"] = {
      function()
        require("illuminate").next_reference({ reverse = true, wrap = true })
      end,
      "  previous reference",
    },
  },
}
