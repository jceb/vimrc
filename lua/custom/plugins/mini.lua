return {
  {
    -- https://github.com/echasnovski/mini.nvim
    "echasnovski/mini.nvim",
    version = false,
    -- cmd = {
    --   "MiniSession",
    --   "MiniSessionNew",
    -- },
    -- keys = {
    --   "gR",
    --   "gr",
    --   "g=",
    --   "g+",
    --   "gS",
    --   "gS",
    -- },
    config = function()
      -- Documentation: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      local surround_line = function(ai_type)
        local vis_mode = "V"
        if ai_type == "a" then
          vis_mode = "v"
        end
        local line = vim.fn.getline(".")
        local lnr = vim.fn.line(".")
        local from = { line = lnr, col = 1 }
        local to = {
          line = lnr,
          -- col = math.max(vim.fn.trim(line, "", 2):len(), 1),
          col = math.max(line:len(), 1),
        }
        return { from = from, to = to, vis_mode = vis_mode }
      end
      require("mini.ai").setup({
        n_lines = 500,
        custom_textobjects = {
          L = surround_line,
        },
      })

      -- Documentation: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-sessions.md
      vim.keymap.set("n", "<leader>SS", ":<C-u>MiniSessionNew ", { noremap = true })
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

      _G.cursorword_blocklist = function()
        local curword = vim.fn.expand("<cword>")
        local filetype = vim.bo.filetype
        -- Add any disabling global or filetype-specific logic here
        local blocklist = {}
        if filetype == "lua" then
          blocklist = { "local", "require" }
        elseif filetype == "javascript" then
          blocklist = { "import" }
        end
        vim.b.minicursorword_disable = vim.tbl_contains(blocklist, curword)
      end
      -- Make sure to add this autocommand *before* calling module's `setup()`.
      vim.cmd("au CursorMoved * lua _G.cursorword_blocklist()")

      -- Documentation: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-cursorword.md
      -- Set highlighting color after colorscheme
      require("mini.cursorword").setup({ delay = 100 })

      -- Documentation: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-pairs.md
      -- require("mini.pairs").setup({})

      -- Documentation: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-align.md
      require("mini.align").setup({
        mappings = {
          -- was:
          -- start = 'ga',
          -- start_with_preview = 'gA',
          start = "g=",
          start_with_preview = "g+",
        },
      })

      -- Documentation: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-operators.md
      require("mini.operators").setup({
        evaluate = {
          -- was:
          -- prefix = 'g=',
          prefix = "<leader>=",
          func = nil,
        },
        sort = {
          -- was:
          -- prefix = 'gs',
          prefix = "gS",
          func = nil,
        },
      })
      vim.keymap.set("n", "gR", "gr$", { remap = true, desc = "Replace current line" })

      -- -- Documentation: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-bracketed.md
      -- require("mini.bracketed").setup({
      --   buffer = { suffix = "", options = {} },
      --   comment = { suffix = "c", options = {} },
      --   conflict = { suffix = "X", options = {} },
      --   diagnostic = { suffix = "", options = {} },
      --   file = { suffix = "", options = {} },
      --   indent = { suffix = "i", options = {} },
      --   jump = { suffix = "", options = {} },
      --   location = { suffix = "", options = {} },
      --   oldfile = { suffix = "", options = {} },
      --   quickfix = { suffix = "", options = {} },
      --   treesitter = { suffix = "", options = {} },
      --   undo = { suffix = "", options = {} },
      --   window = { suffix = "", options = {} },
      --   yank = { suffix = "y", options = {} },
      -- })

      -- Documentation: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md
      local vim_surround_settings = {
        mappings = {
          add = "ys", -- Add surrounding in Normal and Visual modes
          delete = "ds", -- Delete surrounding
          find = "", -- Find surrounding (to the right)
          find_left = "", -- Find surrounding (to the left)
          highlight = "", -- Highlight surrounding
          replace = "cs", -- Replace surrounding
          update_n_lines = "", -- Update `n_lines`
          suffix_last = "", -- Suffix to search with "prev" method
          suffix_next = "", -- Suffix to search with "next" method
        },
        search_method = "cover_or_next",
      }
      require("mini.surround").setup(vim_surround_settings)
      require("mini.surround").setup()
      -- -- Remap adding surrounding to Visual mode selection
      vim.keymap.del("x", "ys")
      vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
      -- -- Make special mapping for "add surrounding for line"
      vim.keymap.set("n", "yss", "ys_", { remap = true, desc = "Surround current line" })
      -- vim.keymap.set("n", "sax", "sa_", { remap = true, desc = "Surround current line" })

      -- Documentation: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-jump2d.md
      -- require("mini.jump2d").setup({
      --   -- mappings = {
      --   --   start_jumping = "s",
      --   -- },
      -- })
    end,
  },
}
