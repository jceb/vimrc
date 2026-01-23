return {
  -- https://github.com/NicolasGB/jj.nvim
  "nicolasgb/jj.nvim",
  config = function()
    require("jj").setup({
      -- Setup snacks as a picker
      -- picker = {
      --   -- Here you can pass the options as you would for snacks.
      --   -- It will be used when using the picker
      --   snacks = {},
      -- },

      -- Customize syntax highlighting colors for the describe buffer
      highlights = {
        added = { fg = "#3fb950", ctermfg = "Green" }, -- Added files
        modified = { fg = "#56d4dd", ctermfg = "Cyan" }, -- Modified files
        deleted = { fg = "#f85149", ctermfg = "Red" }, -- Deleted files
        renamed = { fg = "#d29922", ctermfg = "Yellow" }, -- Renamed files
      },

      -- Configure terminal behavior
      -- terminal = {
      --   -- Cursor render delay in milliseconds (default: 10)
      --   -- If cursor column is being reset to 0 when refreshing commands, try increasing this value
      --   -- This delay allows the terminal emulator to complete rendering before restoring cursor position
      --   cursor_render_delay = 10,
      -- },

      -- Configure cmd module (describe editor, keymaps)
      cmd = {
        -- Configure describe editor
        describe = {
          editor = {
            -- Choose the editor mode for describe command
            -- "buffer" - Opens a Git-style commit message buffer with syntax highlighting (default)
            -- "input" - Uses a simple vim.ui.input prompt
            type = "buffer",
            -- Customize keymaps for the describe editor buffer
            keymaps = {
              close = { "<Esc>", "<C-c>", "q" }, -- Keys to close editor without saving
            },
          },
        },

        -- Configure keymaps for command buffers
        keymaps = {
          -- Log buffer keymaps (set to nil to disable)
          log = {
            checkout = "<CR>", -- Edit revision under cursor
            checkout_immutable = "<S-CR>", -- Edit revision (ignore immutability)
            -- describe = "d", -- Describe revision under cursor
            describe = "de", -- Describe revision under cursor
            -- diff = "<S-d>", -- Diff revision under cursor
            diff = "=", -- Diff revision under cursor
            edit = "e", -- Edit revision under cursor
            new = "n", -- Create new change branching off
            new_after = "<C-n>", -- Create new change after revision
            new_after_immutable = "<S-n>", -- Create new change after (ignore immutability)
            undo = "<S-u>", -- Undo last operation
            redo = "<S-r>", -- Redo last undone operation
          },
          -- Status buffer keymaps (set to nil to disable)
          status = {
            open_file = "<CR>", -- Open file under cursor
            restore_file = "<S-x>", -- Restore file under cursor
          },
          -- Close keymaps (shared across all buffers)
          close = { "q", "<Esc>" },
        },
      },
    })

    local cmd = require("jj.cmd")
    -- Core commands
    -- vim.keymap.set("n", "<leader>jd", jj.describe, { desc = "JJ describe" })
    --   vim.keymap.set("n", "<leader>jl", jj.log, { desc = "JJ log" })
    vim.keymap.set("n", "<leader>jl", function()
      vim.cmd("J log")
    end, { desc = "JJ log" })
    vim.keymap.set("n", "<leader>js", function()
      vim.cmd("J status")
    end, { desc = "JJ status" })
    vim.keymap.set("n", "<leader>je", cmd.edit, { desc = "JJ edit" })
    vim.keymap.set("n", "<leader>jn", cmd.new, { desc = "JJ new" })
    vim.keymap.set("n", "<leader>js", cmd.status, { desc = "JJ status" })
    vim.keymap.set("n", "<leader>sq", cmd.squash, { desc = "JJ squash" })
    vim.keymap.set("n", "<leader>sp", cmd.squash, { desc = "JJ split" })
    vim.keymap.set("n", "<leader>ju", cmd.undo, { desc = "JJ undo" })
    vim.keymap.set("n", "<leader>jy", cmd.redo, { desc = "JJ redo" })
    vim.keymap.set("n", "<leader>jr", cmd.rebase, { desc = "JJ rebase" })
    vim.keymap.set("n", "<leader>jb", cmd.bookmark_create, { desc = "JJ bookmark create" })
    vim.keymap.set("n", "<leader>jB", cmd.bookmark_delete, { desc = "JJ bookmark delete" })
    vim.keymap.set("n", "<leader>jd", cmd.diff, { desc = "JJ diff" })
    vim.keymap.set("n", "<leader>jD", function()
      cmd.diff({ current = true })
    end, { desc = "JJ diff current" })

    vim.keymap.set("n", "<leader>sj", cmd.squash, { desc = "JJ squash" })
    -- Uplift the bookmark
    vim.keymap.set("n", "<leader>jt", function()
      cmd.j("tug")
    end, { desc = "JJ tug" })
    -- Push and pull
    vim.keymap.set("n", "<leader>jp", function()
      cmd.j("pull")
    end, { desc = "JJ pull" })
    vim.keymap.set("n", "<leader>jP", function()
      cmd.j("push")
    end, { desc = "JJ push" })

    -- vim.keymap.set("n", "<leader>gj", function()
    --   require("jj.picker").status()
    -- end, { desc = "JJ Picker status" })
    -- vim.keymap.set("n", "<leader>jgh", function()
    --   require("jj.picker").file_history()
    -- end, { desc = "JJ Picker history" })

    -- Diffs
    local diff = require("jj.diff")
    vim.keymap.set("n", "<leader>jf", function()
      diff.open_vdiff()
    end, { desc = "JJ diff current buffer" })
  end,
}
