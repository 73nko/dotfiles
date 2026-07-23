-- sidekick.nvim: Copilot Next Edit Suggestions (NES) + terminal AI CLIs.
-- Reemplaza a neocodeium (2026-06): el ghost text dependia del free tier de
-- Windsurf, en degradacion tras la ruptura OpenAI/Google/Cognition. Segunda
-- vez con el mismo patron (supermaven -> neocodeium); fin de la dependencia.
--
-- Arquitectura del reemplazo:
--   - Ghost text inline: nativo de Neovim 0.12 (vim.lsp.inline_completion),
--     servido por el Copilot LSP (vim.lsp.enable("copilot") en lspconfig.lua).
--   - NES: sidekick aplica/salta ediciones multi-linea sugeridas (Tab).
--   - CLI (claude): sesiones persistentes via tmux (mux), con
--     auto-reload de ficheros editados por el CLI. Sustituye a los toggles
--     de Snacks.terminal que vivian en snacks.lua.
--
-- Primer uso: :LspCopilotSignIn (cuenta GitHub; Copilot Free vale, con cuota).
return {
  "folke/sidekick.nvim",
  event = "VeryLazy",
  opts = {
    -- NES off (2026-07): queremos autocompletar lineas, no que genere codigo.
    -- El ghost text inline (vim.lsp.inline_completion + Copilot LSP) se queda;
    -- las ediciones multi-linea propuestas por NES, fuera.
    nes = { enabled = false },
    cli = {
      mux = {
        backend = "tmux", -- las sesiones CLI sobreviven al cierre de nvim
        enabled = true,
      },
    },
  },
  keys = {
    {
      "<Tab>",
      function()
        -- Si hay NES pendiente: saltar a ella o aplicarla. Si no, Tab normal.
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>"
        end
      end,
      expr = true,
      desc = "Sidekick: saltar/aplicar NES",
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Sidekick: toggle CLI",
    },
    {
      -- Mismo binding que tenia el toggle de Snacks.terminal("claude")
      "<leader>ac",
      function()
        require("sidekick.cli").toggle({ name = "claude", focus = true })
      end,
      desc = "Sidekick: Claude",
    },
    {
      -- opencode eliminado (2026-07): claude-code es el unico CLI. Su hueco
      -- lo ocupa "enviar fichero actual" en normal mode (av solo cubre visual).
      "<leader>af",
      function()
        require("sidekick.cli").send({ msg = "{file}" })
      end,
      desc = "Sidekick: enviar fichero actual",
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt()
      end,
      mode = { "n", "x" },
      desc = "Sidekick: seleccionar prompt",
    },
    {
      "<leader>av",
      function()
        require("sidekick.cli").send({ msg = "{selection}" })
      end,
      mode = { "x" },
      desc = "Sidekick: enviar seleccion",
    },
  },
}
