map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

return {
  {
    -- https://github.com/echasnovski/mini.nvim
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      require("mini.sessions").setup({
        directory = vim.env.HOME .. "/.sessions/",
      })
      vim.api.nvim_create_user_command("MiniSession", function(opts)
        _G.MiniSessions.read(opts.fargs[1], { force = opts.bang })
      end, {
        nargs = 1,
        bang = true,
        complete = function(ArgLead, CmdLine, CursorPos)
          print(ArgLead)
          local res = vim.tbl_filter(function(item)
            return string.find(item, ArgLead, 1, true) ~= nil
          end, vim.tbl_keys(_G.MiniSessions.detected))
          return res
        end,
      })
      vim.api.nvim_create_user_command("MiniSessionNew", function(opts)
        _G.MiniSessions.write(opts.fargs[1], { force = opts.bang })
      end, {
        nargs = 1,
        bang = true,
        complete = function(ArgLead)
          local res = vim.tbl_filter(function(item)
            return string.find(item, ArgLead, 1, true) ~= nil
          end, vim.tbl_keys(_G.MiniSessions.detected))
          return res
        end,
      })
      --
      -- _G.cursorword_blocklist = function()
      --     local curword = vim.fn.expand("<cword>")
      --     local filetype = vim.bo.filetype
      --     -- Add any disabling global or filetype-specific logic here
      --     local blocklist = {}
      --     if filetype == "lua" then
      --         blocklist = { "local", "require" }
      --     elseif filetype == "javascript" then
      --         blocklist = { "import" }
      --     end
      --     vim.b.minicursorword_disable = vim.tbl_contains(blocklist, curword)
      -- end
      -- -- Make sure to add this autocommand *before* calling module's `setup()`.
      -- vim.cmd("au CursorMoved * lua _G.cursorword_blocklist()")
      require("mini.cursorword").setup({ delay = 100 })
      -- Set highlighting color after colorscheme

      require("mini.pairs").setup({})

      -- require("mini.surround").setup({
      --     mappings = {
      --         add = "ys", -- Add surrounding in Normal and Visual modes
      --         delete = "ds", -- Delete surrounding
      --         find = "", -- Find surrounding (to the right)
      --         find_left = "", -- Find surrounding (to the left)
      --         highlight = "", -- Highlight surrounding
      --         replace = "cs", -- Replace surrounding
      --         update_n_lines = "", -- Update `n_lines`
      --
      --         suffix_last = "", -- Suffix to search with "prev" method
      --         suffix_next = "", -- Suffix to search with "next" method
      --     },
      --     search_method = "cover_or_next",
      -- })
      -- -- Remap adding surrounding to Visual mode selection
      -- vim.keymap.del("x", "ys")
      -- vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
      -- -- Make special mapping for "add surrounding for line"
      -- vim.keymap.set("n", "yss", "ys_", { remap = true })

      -- require("mini.jump2d").setup({
      --     mappings = {
      --         start_jumping = "s",
      --     },
      -- })
    end,
  },
}
