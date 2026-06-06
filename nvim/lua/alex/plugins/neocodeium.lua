-- NeoCodeium: ghost text inline con el tier gratuito de Windsurf (ex-Codeium).
-- Reemplaza a supermaven-nvim (plugin zombie tras la compra por Cursor).
-- Primer uso: :NeoCodeium auth (abre browser, cuenta gratuita, pega el token).
return {
  "monkoose/neocodeium",
  event = "InsertEnter",
  config = function()
    local neocodeium = require("neocodeium")

    neocodeium.setup({
      silent = true,
      filetypes = {
        -- mismos ignores que tenia supermaven
        snacks_picker_input = false,
        snacks_dashboard = false,
        ["dap-repl"] = false,
      },
    })

    -- Tab acepta la sugerencia via la cadena de blink (ver nvim-cmp.lua):
    -- blink visible -> accept blink; si no, neocodeium visible -> accept ghost text.
    -- Alt-w ("word"), no Alt-l: AeroSpace captura alt-l (focus right) a nivel
    -- macOS, el <M-l> heredado de supermaven nunca llego a funcionar.
    vim.keymap.set("i", "<M-w>", function()
      neocodeium.accept_word()
    end, { desc = "NeoCodeium: aceptar palabra" })
    vim.keymap.set("i", "<C-]>", function()
      neocodeium.clear()
    end, { desc = "NeoCodeium: limpiar sugerencia" })
    vim.keymap.set("i", "<M-]>", function()
      neocodeium.cycle_or_complete()
    end, { desc = "NeoCodeium: siguiente sugerencia" })
  end,
}
