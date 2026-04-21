-- Lualine - Sunset · Pool Splash powerline layout (§04 del guide)
-- mode -> branch -> file -> diagnostics -> filetype -> position
-- Todos los modos comparten el mismo estilo magenta/dusk (sin per-mode color).
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status")
    local c = require("alex.themes.sunset-pool").palette

    -- Segmentos compartidos - no per-mode switching
    local mode_seg   = { bg = c.magenta,     fg = c.dusk,     gui = "bold" }
    local branch_seg = { bg = c.branch_bg,   fg = c.turquoise_hi }
    local mid_seg    = { bg = c.none,        fg = c.muted }
    local diag_seg   = { bg = c.diag_bg,     fg = c.tangerine }
    local pos_seg    = { bg = c.turquoise,   fg = c.dusk,     gui = "bold" }

    local theme = {
      normal   = { a = mode_seg, b = branch_seg, c = mid_seg, x = diag_seg, y = mid_seg, z = pos_seg },
      insert   = { a = mode_seg, b = branch_seg, c = mid_seg, x = diag_seg, y = mid_seg, z = pos_seg },
      visual   = { a = mode_seg, b = branch_seg, c = mid_seg, x = diag_seg, y = mid_seg, z = pos_seg },
      replace  = { a = mode_seg, b = branch_seg, c = mid_seg, x = diag_seg, y = mid_seg, z = pos_seg },
      command  = { a = mode_seg, b = branch_seg, c = mid_seg, x = diag_seg, y = mid_seg, z = pos_seg },
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
        component_separators = "",
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = { "snacks_dashboard", "dashboard" } },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(m) return m end, -- Lualine ya lo pone UPPERCASE
            separator = { right = "" },
            padding = { left = 1, right = 1 },
          },
        },
        lualine_b = {
          {
            "branch",
            icon = "",
            separator = { right = "" },
            padding = { left = 1, right = 1 },
          },
        },
        lualine_c = {
          {
            "filename",
            path = 1,
            symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" },
            padding = { left = 1, right = 1 },
          },
        },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = c.gold, bg = c.none },
          },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
            diagnostics_color = {
              error = { fg = c.magenta },
              warn  = { fg = c.tangerine },
              info  = { fg = c.aqua },
              hint  = { fg = c.turquoise_hi },
            },
            separator = { left = "", right = "" },
            padding = { left = 1, right = 1 },
          },
        },
        lualine_y = {
          { "filetype", icons_enabled = true, padding = { left = 1, right = 1 } },
        },
        lualine_z = {
          {
            "location",
            separator = { left = "" },
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
