return {
  -- https://github.com/mfussenegger/nvim-dap
  "mfussenegger/nvim-dap",
  dependencies = {
    -- https://github.com/rcarriga/nvim-dap-ui
    "rcarriga/nvim-dap-ui",
    -- https://github.com/theHamsta/nvim-dap-virtual-text
    "theHamsta/nvim-dap-virtual-text",
    -- https://github.com/nvim-neotest/nvim-nio
    "nvim-neotest/nvim-nio",
    -- https://github.com/leoluz/nvim-dap-go
    "leoluz/nvim-dap-go",
    -- TODO: try out debugmaster
    -- https://github.com/miroshQa/debugmaster.nvim
    -- "miroshQa/debugmaster.nvim"
  },
  keys = {
    { "n", "<F1>", "<cmd>DapuiOpen<CR>" },
  },
  cmd = {
    "DapuiOpen",
  },
  config = function()
    -- Adapter installation: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
    -- Adapters are the basis of the debugging experience - it connects
    -- to the debugger
    local dap = require("dap")
    local dapui = require("dapui")

    --   -- require("mason-nvim-dap").setup({
    --   --   -- Makes a best effort to setup the various debuggers with
    --   --   -- reasonable debug configurations
    --   --   automatic_setup = true,
    --   --   -- You can provide additional configuration to the handlers,
    --   --   -- see mason-nvim-dap README for more information
    --   --   handlers = {},
    --   --   -- You'll need to check that you have the required things installed
    --   --   -- online, please don't ask me how to install them :)
    --   --   ensure_installed = {
    --   --     -- Update this to ensure that you have the debuggers for the langs you want
    --   --     "delve",
    --   --   },
    --   -- })

    -- completion for dap settings
    require("lazydev").setup({
      library = { "nvim-dap-ui" },
    })

    -- Install golang specific config
    require("dap-go").setup()

    dap.adapters.rustgdb = {
      type = "executable",
      command = vim.fn.resolve(vim.fn.exepath("rust-gdb")), -- adjust as needed, must be absolute path
      args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
      name = "rustgdb",
    }
    dap.adapters.lldb = {
      type = "executable",
      command = vim.fn.resolve(vim.fn.exepath("lldb-dap")), -- adjust as needed, must be absolute path
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
        -- include environment variable
        env = function()
          local variables = {}
          for k, v in pairs(vim.fn.environ()) do
            table.insert(variables, string.format("%s=%s", k, v))
          end
          return variables
        end,
      },
    }
    dap.configurations.c = dap.configurations.cpp
    -- dap.configurations.rust = {
    --   {
    --     name = "Launch",
    --     type = "rustgdb",
    --     request = "launch",
    --     program = function()
    --       return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
    --     end,
    --     args = function()
    --       local input = vim.trim(vim.fn.input("Arguments (leave empty for no arguments): ", "", "file"))
    --       if input == "" then
    --         return {}
    --       else
    --         return vim.split(input, " ")
    --       end
    --     end,
    --     -- args = {},
    --     cwd = "${workspaceFolder}",
    --     stopOnEntry = false,
    --     -- include environment variable
    --     env = function()
    --       local variables = {}
    --       for k, v in pairs(vim.fn.environ()) do
    --         table.insert(variables, string.format("%s=%s", k, v))
    --       end
    --       return variables
    --     end,
    --   },
    -- }
    dap.configurations.rust = {
      (
        vim.tbl_extend("force", vim.tbl_get(dap.configurations.cpp, 1), {
          initCommands = function()
            -- Find out where to look for the pretty printer Python module.
            local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))
            assert(vim.v.shell_error == 0, "failed to get rust sysroot using `rustc --print sysroot`: " .. rustc_sysroot)
            local script_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_lookup.py"
            local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"
            -- The following is a table/list of lldb commands, which have a syntax
            -- similar to shell commands.
            --
            -- To see which command options are supported, you can run these commands
            -- in a shell:
            --
            --   * lldb --batch -o 'help command script import'
            --   * lldb --batch -o 'help command source'
            --
            -- Commands prefixed with `?` are quiet on success (nothing is written to
            -- debugger console if the command succeeds).
            --
            -- Prefixing a command with `!` enables error checking (if a command
            -- prefixed with `!` fails, subsequent commands will not be run).
            --
            -- NOTE: it is possible to put these commands inside the ~/.lldbinit
            -- config file instead, which would enable rust types globally for ALL
            -- lldb sessions (i.e. including those run outside of nvim). However,
            -- that may lead to conflicts when debugging other languages, as the type
            -- formatters are merely regex-matched against type names. Also note that
            -- .lldbinit doesn't support the `!` and `?` prefix shorthands.
            return {
              ([[!command script import '%s']]):format(script_file),
              ([[command source '%s']]):format(commands_file),
            }
          end,
        })
      ),
    }

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
      -- firefoxExecutable = os.getenv("HOME") .. "/.local/firefox/firefox",
      firefoxExecutable = vim.fn.resolve(vim.fn.exepath("firefox")),
    }
    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup({
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎",
          step_over = "⏭",
          step_out = "⏮",
          step_back = "b",
          run_last = "▶▶",
          terminate = "⏹",
          disconnect = "⏏",
        },
      },
    })
    -- automatically open the UI upon DAP events
    dap.listeners.after.event_initialized.dapui_config = dapui.open
    dap.listeners.after.event_launch.dapui_config = dapui.open
    dap.listeners.before.event_terminated.dapui_config = dapui.close
    dap.listeners.before.event_exited.dapui_config = dapui.close
    vim.api.nvim_create_user_command("DapuiOpen", 'lua require("dapui").open()', {})
    vim.api.nvim_create_user_command("DapuiClose", 'lua require("dapui").close()', {})
    vim.api.nvim_create_user_command("DapuiToggle", 'lua require("dapui").toggle()', {})
    vim.api.nvim_create_user_command("DapuiEval", 'lua require("dapui").eval()', {})

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set("n", "<leader>,u", "<Cmd>DapuiToggle<CR>", { noremap = true })
    -- vim.keymap.set("n", "<leader>,L", "<Cmd>DapLoadLaunchJSON<CR><cmd>echo 'Loaded JSON launch configuration.'<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>,r", "<Cmd>DapToggleRepl<CR>", { noremap = true, silent = true })

    vim.keymap.set("n", "<F1>", dap.continue, { desc = "Debug: Start/Continue" })
    vim.keymap.set("n", "<leader>,c", dap.continue, { desc = "Debug: Start/Continue" })
    vim.keymap.set("n", "<F2>", dap.step_into, { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<leader>,i", dap.step_into, { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<F3>", dap.step_over, { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<leader>,o", dap.step_over, { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<F4>", dap.step_out, { desc = "Debug: Step Out" })
    vim.keymap.set("n", "<leader>,O", dap.step_out, { desc = "Debug: Step Out" })
    vim.keymap.set("n", "<F5>", dap.step_back, { desc = "Debug: Step Back" })
    vim.keymap.set("n", "<leader>,B", dap.step_back, { desc = "Debug: Step Back" })
    vim.keymap.set("n", "<F10>", dap.restart, { desc = "Debug: Restart" })
    vim.keymap.set("n", "<leader>,R", dap.restart, { desc = "Debug: Restart" })
    vim.keymap.set("n", "<leader>,L", dap.run_last, { desc = "Debug: Run Last Command" })
    vim.keymap.set("n", "<leader>,q", dap.stop, { desc = "Debug: Stop" })
    vim.keymap.set("n", "<leader>,,", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>,b", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: Set Breakpoint" })
    vim.keymap.set("n", "<leader>,gb", dap.run_to_cursor, { desc = "Debug: Run to cursor" })
    vim.keymap.set("n", "<leader>,?", function()
      dapui.eval(nil, { enter = true })
    end, { desc = "Debug: Eval val under cursor" })
  end,
}
