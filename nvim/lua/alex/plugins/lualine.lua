-- Lualine - Glacier Signal (guide v2 §05)
-- mode -> branch -> file -> diagnostics -> filetype -> position
-- Flat segments: sin powerline arrows. Mismo color de modo en todos los modos.
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status")
    local c = require("alex.themes.glacier-signal").palette

    -- Segmentos compartidos - no per-mode switching (§05)
    local mode_seg = { bg = c.signal, fg = c.night, gui = "bold" }
    local branch_seg = { bg = c.branch_bg, fg = c.ice }
    local mid_seg = { bg = c.none, fg = c.muted }
    local diag_seg = { bg = c.diag_bg, fg = c.mint }
    local pos_seg = { bg = c.steel, fg = c.night, gui = "bold" }

    local theme = {
      normal = { a = mode_seg, b = branch_seg, c = mid_seg, x = diag_seg, y = mid_seg, z = pos_seg },
      insert = { a = mode_seg, b = branch_seg, c = mid_seg, x = diag_seg, y = mid_seg, z = pos_seg },
      visual = { a = mode_seg, b = branch_seg, c = mid_seg, x = diag_seg, y = mid_seg, z = pos_seg },
      replace = { a = mode_seg, b = branch_seg, c = mid_seg, x = diag_seg, y = mid_seg, z = pos_seg },
      command = { a = mode_seg, b = branch_seg, c = mid_seg, x = diag_seg, y = mid_seg, z = pos_seg },
      terminal = { a = mode_seg, b = branch_seg, c = mid_seg, x = diag_seg, y = mid_seg, z = pos_seg },
      inactive = {
        a = { bg = c.none, fg = c.muted, gui = "bold" },
        b = { bg = c.none, fg = c.muted },
        c = { bg = c.none, fg = c.muted },
        x = { bg = c.none, fg = c.muted },
        y = { bg = c.none, fg = c.muted },
        z = { bg = c.none, fg = c.muted },
      },
    }

    lualine.setup({
      options = {
        theme = theme,
        globalstatus = true,
        -- Flat: sin separadores ni arrows (§05/§10 "powerline arrows are too 2014")
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = { "snacks_dashboard", "dashboard" } },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(m)
              return m
            end,
            padding = { left = 1, right = 1 },
          },
        },
        lualine_b = {
          {
            "branch",
            icon = "",
            padding = { left = 1, right = 1 },
          },
        },
        lualine_c = {
          {
            "filename",
            path = 1,
            symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" },
            padding = { left = 1, right = 1 },
          },
        },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = c.frost, bg = c.none },
          },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
            diagnostics_color = {
              error = { fg = c.mint },
              warn = { fg = c.frost },
              info = { fg = c.azure },
              hint = { fg = c.steel },
            },
            padding = { left = 1, right = 1 },
          },
        },
        lualine_y = {
          { "filetype", icons_enabled = true, padding = { left = 1, right = 1 } },
        },
        lualine_z = {
          {
            "location",
            padding = { left = 1, right = 1 },
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "lazy", "trouble", "quickfix", "man" },
    })
  end,
}
