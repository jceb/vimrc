return {
  -- https://github.com/rcarriga/nvim-dap-ui
  "rcarriga/nvim-dap-ui",
  dependencies = {
    -- https://github.com/mfussenegger/nvim-dap
    "mfussenegger/nvim-dap",
    -- https://github.com/leoluz/nvim-dap-go
    "leoluz/nvim-dap-go",
  },
  config = function()
    -- Adapter installation: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
    -- Adapters are the basis of the debugging experience - it connects
    -- to the debugger
    local dap = require("dap")
    local dapui = require("dapui")
    require("dap-go").setup()
    dap.adapters.rustgdb = {
      type = "executable",
      command = vim.fn.resolve(vim.fn.exepath("rust-gdb")), -- adjust as needed, must be absolute path
      name = "rustgdb",
    }
    dap.adapters.lldb = {
      type = "executable",
      command = vim.fn.resolve(vim.fn.exepath("lldb-vscode")), -- adjust as needed, must be absolute path
      name = "lldb",
    }
    -- dap.adapters.rust = { dap.adapters.rustgdb, dap.adapters.lldb } -- convenience functions for sepecifying custom launch.json configurations
    dap.adapters.rust = dap.adapters.lldb -- convenience functions for sepecifying custom launch.json configurations
    dap.adapters.c = dap.adapters.lldb -- convenience functions for sepecifying custom launch.json configurations
    dap.adapters.cpp = dap.adapters.lldb -- convenience functions for sepecifying custom launch.json configurations
    -- Configurations are user facing, they define the parameters that
    -- are passed to the adapters
    -- For special purposes custom debug configurations can be loaded
    dap.configurations.cpp = {
      {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        args = function()
          local input = vim.trim(vim.fn.input("Arguments (leave empty for no arguments): ", "", "file"))
          if input == "" then
            return {}
          else
            return vim.split(input, " ")
          end
        end,
        -- args = {},
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }
    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp

    -- Installation instructions: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript-firefox
    dap.adapters.firefox = {
      type = "executable",
      command = "node",
      args = { os.getenv("HOME") .. "/Documents/Software/vscode-firefox-debug/dist/adapter.bundle.js" },
    }

    dap.configurations.typescript = {
      name = "Debug with Firefox",
      type = "firefox",
      request = "launch",
      reAttach = true,
      url = "http://localhost:3000",
      webRoot = "${workspaceFolder}",
      firefoxExecutable = os.getenv("HOME") .. "/.local/firefox/firefox",
    }
    dapui.setup()
    -- automatically open the UI upon DAP events
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
    vim.api.nvim_create_user_command("DapuiOpen", 'lua require("dapui").open()', {})
    vim.api.nvim_create_user_command("DapuiClose", 'lua require("dapui").close()', {})
    vim.api.nvim_create_user_command("DapuiToggle", 'lua require("dapui").toggle()', {})
    vim.api.nvim_create_user_command("DapuiEval", 'lua require("dapui").eval()', {})
  end,
}
