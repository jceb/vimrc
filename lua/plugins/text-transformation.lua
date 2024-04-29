map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

return {
  ----------------------
  -- text transformation
  ----------------------
  -- {
  --     -- https://github.com/ziontee113/icon-picker.nvim
  --     "ziontee113/icon-picker.nvim",
  --     dependencies = {
  --         "stevearc/dressing.nvim",
  --     },
  --     config = function()
  --         local opts = { noremap = true, silent = true }
  --         vim.keymap.set("n", "<Space>ci", "<cmd>PickIcons<cr>", opts)
  --         vim.keymap.set("n", "<Space>cs", "<cmd>PickAltFontAndSymbols<cr>", opts)
  --         -- vim.keymap.set("i", "<C-i>", "<cmd>PickIconsInsert<cr>", opts)
  --         -- vim.keymap.set("i", "<C-S-i>", "<cmd>PickAltFontAndSymbolsInsert<cr>", opts)
  --         vim.keymap.set("i", "<A-i>", "<cmd>PickIconsInsert<cr>", opts)
  --         vim.keymap.set("i", "<M-s>", "<cmd>PickAltFontAndSymbolsInsert<cr>", opts)
  --
  --         require("icon-picker")
  --     end,
  -- },
  {
    -- https://github.com/andrewferrier/debugprint.nvim
    "andrewferrier/debugprint.nvim",
    opts = {
      keymaps = {
        normal = {
          plain_below = "g?p",
          plain_above = "g?P",
          variable_below = "g?v",
          variable_above = "g?V",
          variable_below_alwaysprompt = nil,
          variable_above_alwaysprompt = nil,
          textobj_below = "g?o",
          textobj_above = "g?O",
          toggle_comment_debug_prints = nil,
          delete_debug_prints = nil,
        },
        visual = {
          variable_below = "g?v",
          variable_above = "g?V",
        },
      },
      commands = {
        toggle_comment_debug_prints = "ToggleCommentDebugPrints",
        delete_debug_prints = "DeleteDebugPrints",
      },
    }
    -- Remove the following line to use development versions,
    -- not just the formal releases
    -- version = "*"
  },
  {
    -- https://github.com/uga-rosa/ccc.nvim
    "uga-rosa/ccc.nvim",
    lazy = true,
    keys = { { "<Space>cc", "<cmd>CccPick<cr>" }, { "<C-S-c>", "<Plug>(ccc-insert)", mode = "i" } },
    config = function()
      -- local opts = { noremap = false, silent = true }
      -- vim.keymap.set("n", "<Space>cc", "<cmd>CccPick<cr>", opts)
      -- vim.keymap.set("i", "<C-S-c>", "<Plug>(ccc-insert)", opts)

      local ccc = require("ccc")
      -- local mapping = ccc.mapping
      ccc.setup({
        -- Your favorite settings
        highlighter = {
          auto_enable = true,
          filetypes = { "css" },
        },
        mappings = {
          -- Disable only 'q' (|ccc-action-quit|)
          -- q = mapping.none,
        },
      })
      -- vim.cmd([[hi FloatBorder guibg=NONE]])
    end,
  },
  {
    -- https://github.com/tpope/vim-abolish
    "tpope/vim-abolish",
    lazy = true,
    cmd = { "Abolish", "S", "Subvert" },
    keys = { { "cr" } },
  },
  {
    -- https://github.com/numToStr/Comment.nvim
    "numToStr/Comment.nvim",
    lazy = true,
    dependencies = {
      -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    keys = {
      { "gc" },
      { "gc",    mode = "v" },
      { "gb" },
      { "gb",    mode = "v" },
      { "<C-c>", mode = "i" },
    },
    config = function()
      require("Comment").setup({
        -- @param ctx Ctx
        pre_hook = function(ctx)
          -- Only calculate commentstring for tsx filetypes
          if
              vim.bo.filetype == "typescriptreact"
              or vim.bo.filetype == "tyescriptjsx"
              or vim.bo.filetype == "javascriptreact"
              or vim.bo.filetype == "javascriptjsx"
          then
            local U = require("Comment.utils")

            -- Detemine whether to use linewise or blockwise commentstring
            local type = ctx.ctype == U.ctype.line and "__default" or "__multiline"

            -- Determine the location where to calculate commentstring from
            local location = nil
            if ctx.ctype == U.ctype.block then
              location = require("ts_context_commentstring.utils").get_cursor_location()
            elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
              location = require("ts_context_commentstring.utils").get_visual_start_location()
            end

            return require("ts_context_commentstring.internal").calculate_commentstring({
              key = type,
              location = location,
            })
          end
        end,
      })
      vim.cmd([[
        function! InsertCommentstring()
        let [l, r] = split(substitute(substitute(&commentstring,'\S\zs%s',' %s',''),'%s\ze\S','%s ',''),'%s',1)
        let col = col('.')
        let line = line('.')
        let g:ics_pos = [line, col + strlen(l)]
        return l.r
        endfunction
        ]])
      vim.cmd([[
        function! ICSPositionCursor()
        call cursor(g:ics_pos[0], g:ics_pos[1])
        unlet g:ics_pos
        endfunction
        ]])
      map("i", "<C-c>", "<C-r>=InsertCommentstring()<CR><C-o>:call ICSPositionCursor()<CR>", { noremap = true })
    end,
  },
  -- {
  --     -- https://github.com/tpope/vim-commentary
  --     "tpope/vim-commentary",
  --     lazy = true,
  --     keys = {
  --         { "n", "gc" },
  --         { "v", "gc" },
  --         { "n", "gcc" },
  --         { "i", "<C-c>" },
  --     },
  --     config = function()
  --         vim.cmd([[
  --                   function! InsertCommentstring()
  --                       let [l, r] = split(substitute(substitute(&commentstring,'\S\zs%s',' %s',''),'%s\ze\S','%s ',''),'%s',1)
  --                       let col = col('.')
  --                       let line = line('.')
  --                       let g:ics_pos = [line, col + strlen(l)]
  --                       return l.r
  --                   endfunction
  --               ]])
  --         vim.cmd([[
  --                   function! ICSPositionCursor()
  --                       call cursor(g:ics_pos[0], g:ics_pos[1])
  --                       unlet g:ics_pos
  --                   endfunction
  --               ]])

  --         map(
  --             "i",
  --             "<C-c>",
  --             "<C-r>=InsertCommentstring()<CR><C-o>:call ICSPositionCursor()<CR>",
  --             { noremap = true }
  --         )
  --     end,
  -- },
  -- {
  --     -- https://github.com/tomtom/tcomment_vim
  --     "tomtom/tcomment_vim",
  --     name = "tcomment",
  --     lazy = true,
  --     keys = { { "n", "gc" }, { "v", "gc" }, { "n", "gcc" }, { "i", "<C-c>" } },
  --     init = function()
  --         vim.g.tcomment_maps = 0
  --         -- vim.g.tcomment_mapleader1 = ""
  --         -- vim.g.tcomment_mapleader2 = ""
  --     end,
  --     config = function()
  --         vim.cmd([[
  --                    function! InsertCommentstring()
  --                        let [l, r] = split(substitute(substitute(&commentstring,'\S\zs%s',' %s',''),'%s\ze\S','%s ',''),'%s',1)
  --                        let col = col('.')
  --                        let line = line('.')
  --                        let g:ics_pos = [line, col + strlen(l)]
  --                        return l.r
  --                    endfunction
  --                    nmap <silent> gc <Plug>TComment_gc
  --                    xmap <silent> gc <Plug>TComment_gcb
  --                ]])
  --         vim.cmd([[
  --                    function! ICSPositionCursor()
  --                        call cursor(g:ics_pos[0], g:ics_pos[1])
  --                        unlet g:ics_pos
  --                    endfunction
  --                ]])
  --
  --         map(
  --             "i",
  --             "<C-c>",
  --             "<C-r>=InsertCommentstring()<CR><C-o>:call ICSPositionCursor()<CR>",
  --             { noremap = true }
  --         )
  --     end,
  -- },
  {
    -- https://github.com/windwp/nvim-autopairs
    -- Replaced by mini.pairs
    "windwp/nvim-autopairs",
    keys = {
      { "{", mode = "i" },
      { "[", mode = "i" },
      { "(", mode = "i" },
      { "<", mode = "i" },
      { "'", mode = "i" },
      { '"', mode = "i" },
    },
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  {
    -- https://github.com/junegunn/vim-easy-align
    "junegunn/vim-easy-align",
    lazy = true,
    keys = { { "<Plug>(EasyAlign)" }, { "<Plug>(EasyAlign)", mode = "x" } },
    init = function()
      map("x", "g=", "<Plug>(EasyAlign)", {})
      map("n", "g=", "<Plug>(EasyAlign)", {})
      map("n", "g/", "g=ip*|", {})
    end,
    -- config = function() end,
  },
  {
    -- https://github.com/tpope/vim-surround
    -- Replaced by mini.surround
    "tpope/vim-surround",
    lazy = true,
    keys = {
      { "ys" },
      { "yss" },
      { "ds" },
      { "cs" },
      { "S",  mode = "v" },
    },
    init = function()
      vim.g.surround_no_insert_mappings = 1
    end,
  },
  {
    -- https://github.com/tpope/vim-repeat
    "tpope/vim-repeat",
  },
  {
    -- https://github.com/jceb/vim-textobj-uri
    "jceb/vim-textobj-uri",
    dependencies = {
      -- https://github.com/kana/vim-textobj-user
      "kana/vim-textobj-user",
    },
    -- lazy = false,
    -- keys = { { "go" } },
    config = function()
      vim.call("textobj#uri#add_pattern", "", "[bB]ug:\\? #\\?\\([0-9]\\+\\)",
        ":silent !open-cli 'http://forge.univention.org/bugzilla/show_bug.cgi?id=%s' &")
      vim.call(
        "textobj#uri#add_pattern",
        "",
        "[tT]icket:\\? #\\?\\([0-9]\\+\\)",
        ":silent !open-cli 'https://gorm.knut.univention.de/otrs/index.pl?Action=AgentTicketZoom&TicketNumber=%s' &"
      )
      vim.call("textobj#uri#add_pattern", "", "[iI]ssue:\\? #\\?\\([0-9]\\+\\)",
        ":silent !open-cli 'https://univention.plan.io/issues/%s' &")
      vim.call("textobj#uri#add_pattern", "", "[tT][gG]-\\([0-9]\\+\\)",
        ":!open-cli 'https://tree.taiga.io/project/jceb-identinet-development/us/%s' &")
    end,
  },
  {
    -- https://github.com/vim-scripts/VisIncr
    "vim-scripts/VisIncr",
    lazy = true,
    cmd = { "I", "II" },
  },
  {
    -- https://github.com/mjbrownie/swapit
    "mjbrownie/swapit",
    dependencies = {
      {
        -- https://github.com/tpope/vim-speeddating
        "tpope/vim-speeddating",
        name = "speeddating",
        init = function()
          local opts = { noremap = true, silent = true }
          vim.g.speeddating_no_mappings = 1
          map("n", "<Plug>SpeedDatingFallbackUp", "<C-a>", opts)
          map("n", "<Plug>SpeedDatingFallbackDown", "<C-x>", opts)
        end,
      },
    },
    lazy = true,
    keys = {
      "<Plug>SwapItFallbackIncrement",
      "<Plug>SwapItFallbackDecrement",
      "<C-a>",
      "<C-x>",
      "<C-t>",
    },
    -- init = function(plugin)
    --   vim.fn["SwapWord"] = function(...)
    --     vim.fn["SwapWord"] = nil
    --     require("lazy").load({ plugins = { plugin } })
    --     return vim.fn["SwapWord"](...)
    --   end
    -- end,
    config = function()
      local opts = { silent = true }
      map("n", "<Plug>SwapItFallbackIncrement",
        ":<C-u>let sc=v:count1<Bar>call speeddating#increment(sc)<Bar>unlet sc<CR>", opts)
      map("n", "<Plug>SwapItFallbackDecrement",
        ":<C-u>let sc=v:count1<Bar>call speeddating#increment(-sc)<Bar>unlet sc<CR>", opts)
      map(
        "n",
        "<C-a>",
        ':<C-u>let swap_count = v:count<Bar>call SwapWord(expand("<cword>"), swap_count, "forward", "no")<Bar>silent! call repeat#set("\\<Plug>SwapIncrement", swap_count)<Bar>unlet swap_count<CR>',
        opts
      )
      map(
        "n",
        "<C-x>",
        ':<C-u>let swap_count = v:count<Bar>call SwapWord(expand("<cword>"), swap_count, "backward","no")<Bar>silent! call repeat#set("\\<Plug>SwapDecrement", swap_count)<Bar>unlet swap_count<CR>',
        opts
      )
    end,
  },
  -- {
  --     -- https://github.com/monaqa/dial.nvim
  --     "monaqa/dial.nvim",
  --     -- maybe a pluging to replace swapit with
  -- },
  -- {
  --     -- https://github.com/Ron89/thesaurus_query.vim
  --     "Ron89/thesaurus_query.vim",
  --     lazy = true,
  --     ft = {
  --         "mail",
  --         "help",
  --         "debchangelog",
  --         "tex",
  --         "plaintex",
  --         "txt",
  --         "asciidoc",
  --         "markdown",
  --         "org",
  --     },
  --     setup = function()
  --         vim.g.tq_map_keys = 1
  --         vim.g.tq_use_vim_autocomplete = 0
  --         vim.g.tq_language = { "en", "de" }
  --     end,
  -- },
  {
    -- https://github.com/dpelle/vim-LanguageTool
    "dpelle/vim-LanguageTool",
    lazy = true,
    cmd = { "LanguageToolCheck" },
    build = { vim.fn.stdpath("config") .. "/download_LanguageTool.sh" },
    config = function()
      vim.g.languagetool_jar = vim.fn.stdpath("config") .. "/opt/LanguageTool/languagetool-commandline.jar"
    end,
  },
  -- {
  --     -- https://github.com/ThePrimeagen/refactoring.nvim
  --     "ThePrimeagen/refactoring.nvim",
  --     lazy = true,
  --    dependencies = {
  --        -- https://github.com/nvim-lua/popup.nvim
  --        "nvim-lua/popup.nvim",
  --        -- https://github.com/nvim-lua/plenary.nvim
  --        "nvim-lua/plenary.nvim",
  --        -- https://github.com/nvim-treesitter/nvim-treesitter
  --        "nvim-treesitter/nvim-treesitter",
  --     },
  -- },
  {
    -- https://github.com/Wansmer/treesj
    "Wansmer/treesj",
    keys = { "<space>tM", "<space>tJ", "<space>tS" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
      })
      vim.keymap.set("n", "<leader>tM", require("treesj").toggle)
      vim.keymap.set("n", "<leader>tJ", require("treesj").join)
      vim.keymap.set("n", "<leader>tS", require("treesj").split)
    end,
  },
}
