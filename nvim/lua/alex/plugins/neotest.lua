return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "fredrikaverpil/neotest-golang", -- neotest-go superado: AST parsing, table tests, monorepos
    "nvim-neotest/neotest-jest", -- repo movido desde haydenmeade
    "marilari88/neotest-vitest",
    "mrcjkb/rustaceanvim", -- trae su propio adapter de neotest
  },
  keys = {
    {
      "<leader>tT",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Run File Tests",
    },
    {
      "<leader>tt",
      function()
        require("neotest").run.run()
      end,
      desc = "Run Nearest Test",
    },
    {
      "<leader>td",
      function()
        require("neotest").run.run({ strategy = "dap" })
      end,
      desc = "Debug Nearest Test",
    },
    {
      "<leader>ts",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Toggle Test Summary",
    },
    {
      "<leader>to",
      function()
        require("neotest").output.open({ enter = true })
      end,
      desc = "Show Test Output",
    },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-golang")({
          runner = "gotestsum", -- ya instalado via Brewfile (go install)
          dap_go_enabled = true, -- <leader>td debug via nvim-dap-go
        }),
        require("rustaceanvim.neotest"),
        require("neotest-jest")({
          -- pnpm o npm segun el lockfile del repo (Brewfile instala pnpm;
          -- "npm test" contra un workspace de pnpm corre el lockfile equivocado)
          jestCommand = function(file)
            local pnpm_lock = vim.fn.findfile("pnpm-lock.yaml", vim.fn.fnamemodify(file, ":p:h") .. ";")
            if pnpm_lock ~= "" then
              return "pnpm test --"
            end
            return "npm test --"
          end,
          -- dynamically find the jest config closest to the test file
          jestConfigFile = function(file)
            for _, name in ipairs({ "jest.config.ts", "jest.config.js", "jest.config.json", "custom.jest.config.ts" }) do
              local found = vim.fn.findfile(name, vim.fn.fnamemodify(file, ":p:h") .. ";")
              if found ~= "" then
                return found
              end
            end
          end,
          env = { CI = true },
          -- run jest from the package root, not global cwd (important for YOUR-ORG monorepo)
          cwd = function(file)
            local pkg = vim.fn.findfile("package.json", vim.fn.fnamemodify(file, ":p:h") .. ";")
            if pkg ~= "" then
              return vim.fn.fnamemodify(pkg, ":p:h")
            end
            return vim.fn.getcwd()
          end,
        }),
        require("neotest-vitest"),
      },
    })
  end,
}
