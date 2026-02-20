return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
"nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-go",
    "haydenmeade/neotest-jest",
    "marilari88/neotest-vitest",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-go"),
        require("neotest-jest")({
          jestCommand = "npm test --",
          -- dynamically find the jest config closest to the test file
          jestConfigFile = function(file)
            for _, name in ipairs({ "jest.config.ts", "jest.config.js", "jest.config.json", "custom.jest.config.ts" }) do
              local found = vim.fn.findfile(name, vim.fn.fnamemodify(file, ":p:h") .. ";")
              if found ~= "" then return found end
            end
          end,
          env = { CI = true },
          -- run jest from the package root, not global cwd (important for YOUR-ORG monorepo)
          cwd = function(file)
            local pkg = vim.fn.findfile("package.json", vim.fn.fnamemodify(file, ":p:h") .. ";")
            if pkg ~= "" then return vim.fn.fnamemodify(pkg, ":p:h") end
            return vim.fn.getcwd()
          end,
        }),
        require("neotest-vitest"),
      },
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>tT", function()
      require("neotest").run.run(vim.fn.expand("%"))
    end, { desc = "Run File Tests" })
    vim.keymap.set("n", "<leader>tt", function()
      require("neotest").run.run()
    end, { desc = "Run Nearest Test" })
    vim.keymap.set("n", "<leader>td", function()
      require("neotest").run.run({ strategy = "dap" })
    end, { desc = "Debug Nearest Test" })
    vim.keymap.set("n", "<leader>ts", function()
      require("neotest").summary.toggle()
    end, { desc = "Toggle Test Summary" })
    vim.keymap.set("n", "<leader>to", function()
      require("neotest").output.open({ enter = true })
    end, { desc = "Show Test Output" })
  end,
}
