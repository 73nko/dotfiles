return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "leoluz/nvim-dap-go",
    -- nvim-dap-vscode-js eliminado (sin mantenimiento desde 2023):
    -- el adapter pwa-node se define nativo abajo con js-debug-adapter de mason.
    "mfussenegger/nvim-dap-python",
    "theHamsta/nvim-dap-virtual-text",
  },
  keys = {
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Toggle Breakpoint",
    },
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Conditional Breakpoint",
    },
    {
      "<leader>dc",
      function()
        local dap = require("dap")
        if dap.session() then
          dap.continue()
          return
        end
        local ft = vim.bo.filetype
        if ft == "" or dap.configurations[ft] == nil then
          vim.notify(
            ("DAP: no hay configuración para filetype '%s'. Muévete a un buffer de código o usa <leader>dl."):format(
              ft ~= "" and ft or "none"
            ),
            vim.log.levels.WARN,
            { title = "DAP" }
          )
          return
        end
        dap.continue()
      end,
      desc = "Continue (safe)",
    },
    {
      "<leader>di",
      function()
        require("dap").step_into()
      end,
      desc = "Step Into",
    },
    {
      "<leader>do",
      function()
        require("dap").step_over()
      end,
      desc = "Step Over",
    },
    {
      "<leader>dO",
      function()
        require("dap").step_out()
      end,
      desc = "Step Out",
    },
    {
      "<leader>dr",
      function()
        require("dap").repl.open()
      end,
      desc = "Open REPL",
    },
    {
      "<leader>dt",
      function()
        require("dapui").toggle()
      end,
      desc = "Toggle DAP UI",
    },
    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      desc = "Run Last",
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("dapui").setup()
    require("dap-go").setup()
    require("nvim-dap-virtual-text").setup()

    -- Python (YOUR-ORG-brain / LangGraph)
    require("dap-python").setup("python3")

    -- auto open/close dapui
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- Node.js / TypeScript (Lambda, Express, Koa, Next.js)
    -- Adapter nativo: js-debug-adapter (mason) habla DAP directamente.
    -- Mason pone su bin/ en el PATH, no hace falta ruta absoluta.
    for _, adapter in ipairs({ "pwa-node", "pwa-chrome" }) do
      dap.adapters[adapter] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "js-debug-adapter",
          args = { "${port}" },
        },
      }
    end

    for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to process",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
        -- Jest test debugging (YOUR-ORG uses Jest across all services)
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug Jest Tests",
          runtimeExecutable = "node",
          runtimeArgs = {
            "--inspect-brk",
            "${workspaceFolder}/node_modules/.bin/jest",
            "--runInBand",
            "--testPathPattern",
            "${file}",
          },
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
        },
        -- Next.js server debug
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug Next.js server",
          program = "${workspaceFolder}/node_modules/.bin/next",
          args = { "dev" },
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
        },
        -- Next.js / React frontend (launch Chrome against dev server)
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch Chrome against localhost:3000",
          url = "http://localhost:3000",
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
          userDataDir = false,
        },
      }
    end
  end,
}
