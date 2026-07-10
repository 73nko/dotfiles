return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      image = { enabled = false }, -- disabled: incompatible with Neovim 0.12.0 treesitter API (range nil error)
      bufdelete = { enabled = true },
      dashboard = {
        width = 60,
        pane_gap = 6,
        preset = {
          header = [[
    _           _                  _      
   / \__      _| |_ ___  _ __ ___ (_) ___ 
  / _ \ \ /\ / / __/ _ \| '_ ` _ \| |/ __|
 / ___ \ V  V /| || (_) | | | | | | | (__ 
/_/   \_\_/\_/  \__\___/|_| |_| |_|_|\___|
          ]],
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = "󰙅 ", key = "e", desc = "File Explorer", action = ":lua Snacks.explorer()" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", action = ":SessionRestore" },
            { icon = " ", key = "L", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        formats = {
          key = function(item)
            return { { "[", hl = "SnacksDashboardDesc" }, { item.key, hl = "SnacksDashboardKey" }, { "]", hl = "SnacksDashboardDesc" } }
          end,
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          -- session = false evita el self:action recursivo que crashea cuando
          -- el proyecto tiene sesion guardada (auto-session). Ver is_float()
          -- sobre self.win = nil. Restaurar sesion queda en <leader>Sr.
          { pane = 2, icon = " ", title = "Projects",     section = "projects",     indent = 2, padding = 1, session = false },
          {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            -- Strict check: only show the pane when the cwd is a repo root
            -- (.git/ directly inside). If cwd is a parent folder containing
            -- multiple repos but no .git of its own, the pane does NOT
            -- appear. Enter a specific repo -> it appears.
            enabled = function()
              local cwd = vim.loop.cwd()
              if not cwd then return false end
              local git = cwd .. "/.git"
              return vim.fn.isdirectory(git) == 1 or vim.fn.filereadable(git) == 1
            end,
            -- NO usar "git -C <path>" con un path calculado aqui: esta tabla se
            -- evalua cuando lazy construye el spec (cwd = donde se lanzo nvim),
            -- no cuando se renderiza el dashboard (cwd = tras el :cd del hijack).
            -- Dejamos que git herede el cwd de nvim en tiempo de ejecucion.
            -- `enabled` ya garantiza que ese cwd tiene .git.
            cmd = "git --no-pager diff --stat -B -M -C 2>/dev/null",
            height = 10,
            padding = 1,
            ttl = 5 * 60,
            indent = 2,
          },
          { section = "startup" },
        },
      },
      indent = {
        indent = {
          priority = 1,
          enabled = true, -- enable indent guides
          char = "│",
          only_scope = false, -- only show indent guides of the scope
          only_current = false, -- only show indent guides in the current window
          hl = "SnacksIndent", ---@type string|string[] hl groups for indent guides
        },
        animate = {
          enabled = false,
        },
        scope = {
          enabled = true, -- enable highlighting the current scope
          priority = 200,
          char = "│",
          underline = false, -- underline the start of the scope
          only_current = false, -- only show scope in the current window
          hl = "SnacksIndentScope", --- hl group for scopes
        },
        chunk = {
          enabled = false, -- when enabled, scopes will be rendered as chunks
          only_current = false, -- only show chunk scopes in the current window
          priority = 200,
          hl = "SnacksIndentChunk", ---@type string|string[] hl group for chunk scopes
          char = {
            -- corner_top = "┌",
            -- corner_bottom = "└",
            corner_top = "╭",
            corner_bottom = "╰",
            horizontal = "─",
            vertical = "│",
            arrow = ">",
          },
        },
        -- filter for buffers to enable indent guides
        filter = function(buf)
          return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
        end,
      },
      input = { enabled = true },
      git = { enabled = true },
      gitbrowse = { enabled = true },
      notifier = { enabled = true },
      picker = {
        prompt = " ",
        hidden = true,
        backdrop = 50,
        sources = {},
        layout = {
          cycle = true,
          preset = "mivy_test",
        },
        layouts = {
          mivy = {
            layout = {
              box = "vertical",
              backdrop = 50,
              row = -1,
              width = 0,
              height = 0.5,
              border = "top",
              title = "{title} {live} {flags}",
              {
                box = "horizontal",
                {
                  box = "vertical",
                  { win = "input", height = 2 },
                  { win = "list" },
                },
                { win = "preview", title = "{preview}", width = vim.o.columns <= 125 and 0.7 or 0.55 },
              },
            },
          },
          mivy_test = {
            layout = {
              box = "vertical",
              backdrop = 80,
              row = -1,
              width = 0,
              height = 0.4,
              border = "top",
              title = " {title} {live} {flags}",
              title_pos = "left",
              {
                box = "horizontal",
                { win = "list", border = "rounded" },
                { win = "preview", title = "{preview}", width = 0.6, border = "rounded" },
              },
              { win = "input", height = 2, border = "bottom" },
            },
          },
        },
        matcher = {
          cwd_bonus = true,
          frecency = true,
        },
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "i", "n" } },
              ["<C-c>"] = { "close", mode = { "i", "n" } },
              ["q"] = "close",
            },
          },
          list = {
            keys = {
              ["<Esc>"] = "close",
              ["q"] = "close",
            },
          },
          preview = {
            keys = {
              ["<Esc>"] = "close",
              ["q"] = "close",
            },
          },
        },
        ui_select = true,
      },
      quickfile = { enabled = true },
      rename = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" }, -- priority of signs on the left (high to low)
        tstatus = { enabled = false },
        right = { "fold", "git" }, -- priority of signs on the right (high to low)
        folds = {
          open = false, -- show open fold icons
          git_hl = false, -- use Git Signs hl for fold icons
        },
        git = {
          -- patterns to match Git signs
          patterns = { "GitSign", "MiniDiffSign" },
        },
        refresh = 50, -- refresh at most every 50ms
      },
      toggle = { enabled = true },
      words = { enabled = true },
      zen = { enabled = true },
    },
    keys = {
      -- Dashboard: volver a la pantalla de inicio
      {
        "<leader>H",
        function()
          Snacks.dashboard()
        end,
        desc = "Home (Dashboard)",
      },
      -- Notify (moved from <leader>n* to <leader>N* to avoid collision with swap-next prefix)
      {
        "<leader>Ns",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Show notifications",
      },
      {
        "<leader>Nh",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Hide notification",
      },
      -- Bufdelete
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Buffer delete",
      },
      {
        "<leader>ba",
        function()
          Snacks.bufdelete.all()
        end,
        desc = "Buffer delete all",
      },
      {
        "<leader>bo",
        function()
          Snacks.bufdelete.other()
        end,
        desc = "Buffer delete other",
      },
      {
        "<leader>sb",
        function()
          Snacks.picker.buffers({
            unloaded = true,
            current = true,
            win = {
              input = {
                keys = {
                  ["<c-x>"] = { "bufdelete", mode = { "n", "i" } },
                },
              },
            },
          })
        end,
        desc = "Buffers",
      },
      {
        "<leader><leader>",
        function()
          Snacks.picker.files({
            finder = "files",
            hidden = true,
          })
        end,
        desc = "[F]iles",
      },
      {
        "<leader>st",
        function()
          Snacks.explorer.reveal({ hidden = true })
        end,
        desc = "[T]ree (reveal current)",
      },
      -- File explorer (migrated from nvim-tree on 2026-04-21)
      {
        "<leader>ee",
        function()
          Snacks.explorer()
        end,
        desc = "Toggle file explorer",
      },
      {
        "<leader>ef",
        function()
          Snacks.explorer.reveal({ hidden = true })
        end,
        desc = "Reveal file in explorer",
      },
      -- AI terminals: migrados a sidekick.nvim (2026-06). <leader>ac y
      -- <leader>ao viven ahora en sidekick.lua con persistencia tmux y
      -- auto-reload de ficheros editados por el CLI.
      {
        "<leader>sr",
        function()
          Snacks.picker.recent()
        end,
        desc = "[R]ecent",
      },
      -- Git
      {
        -- kdheepak/lazygit.nvim eliminado (2026-06): Snacks.lazygit da la misma
        -- UX con un plugin menos y hereda el colorscheme automaticamente.
        "<leader>lg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
      {
        "<leader>gb",
        function()
          Snacks.git.blame_line()
        end,
        desc = "[G]it [B]lame",
      },
      {
        "<leader>sG",
        function()
          Snacks.picker.git_files({ finder = "git_files", hidden = true, show_empty = false })
        end,
        desc = "[G]it Files",
      },
      {
        "<leader>gl",
        function()
          Snacks.picker.git_log()
        end,
        desc = "[G]it [L]og",
      },
      {
        "<leader>gs",
        function()
          Snacks.picker.git_status()
        end,
        desc = "[G]it [S]tatus",
      },
      -- Buffer
      {
        "<leader>sl",
        function()
          Snacks.picker.lines({})
        end,
        desc = "Buffer [L]ines",
      },
      {
        "<leader>sB",
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = "Grep Open [B]uffers",
      },
      -- Grep
      {
        "<leader>sg",
        function()
          Snacks.picker.grep()
        end,
        desc = "[G]rep",
      },
      {
        "<leader>sw",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "[W]ord",
        mode = { "n", "x" },
      },
      -- LSP pickers (gd, gr, gi, gt are in lspconfig.lua LspAttach - single source of truth)
      {
        "<leader>sd",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "[D]iagnostics",
      },
      {
        "<leader>ss",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP [S]ymbols",
      },
      -- Neovim
      {
        '<leader>s"',
        function()
          Snacks.picker.registers()
        end,
        desc = "[R]egisters",
      },
      {
        "<leader>sa",
        function()
          Snacks.picker.autocmds()
        end,
        desc = "[A]uto Commands",
      },
      {
        "<leader>sc",
        function()
          Snacks.picker.command_history()
        end,
        desc = "[C]ommand History",
      },
      {
        "<leader>sC",
        function()
          Snacks.picker.commands()
        end,
        desc = "[C]ommands",
      },
      {
        "<leader>sh",
        function()
          Snacks.picker.help()
        end,
        desc = "[H]elp Pages",
      },
      {
        "<leader>sH",
        function()
          Snacks.picker.highlights()
        end,
        desc = "[H]ighlights",
      },
      {
        "<leader>sj",
        function()
          Snacks.picker.jumps()
        end,
        desc = "[J]umps",
      },
      {
        "<leader>sk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "[K]eymaps",
      },
      {
        "<leader>sL",
        function()
          Snacks.picker.loclist()
        end,
        desc = "[L]ocation List",
      },
      {
        "<leader>sM",
        function()
          Snacks.picker.man()
        end,
        desc = "[M]an Pages",
      },
      {
        "<leader>sm",
        function()
          Snacks.picker.marks()
        end,
        desc = "[M]arks",
      },
      {
        "<leader>sq",
        function()
          Snacks.picker.qflist()
        end,
        desc = "[Q]uickfix List",
      },
      {
        "<leader>so",
        function()
          Snacks.picker.colorschemes()
        end,
        desc = "C[o]lorschemes",
      },
      -- Internal
      {
        "<leader>sR",
        function()
          Snacks.picker.resume()
        end,
        desc = "[R]esume",
      },
      {
        "<leader>sp",
        function()
          Snacks.picker.projects()
        end,
        desc = "[P]rojects",
      },
    },
  }
