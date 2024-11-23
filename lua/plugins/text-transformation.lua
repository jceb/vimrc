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
  --         vim.keymap.set("n", "<leader>ci", "<cmd>PickIcons<cr>", opts)
  --         vim.keymap.set("n", "<leader>cs", "<cmd>PickAltFontAndSymbols<cr>", opts)
  --         -- vim.keymap.set("i", "<C-i>", "<cmd>PickIconsInsert<cr>", opts)
  --         -- vim.keymap.set("i", "<C-S-i>", "<cmd>PickAltFontAndSymbolsInsert<cr>", opts)
  --         vim.keymap.set("i", "<A-i>", "<cmd>PickIconsInsert<cr>", opts)
  --         vim.keymap.set("i", "<M-s>", "<cmd>PickAltFontAndSymbolsInsert<cr>", opts)
  --
  --         require("icon-picker")
  --     end,
  -- },
  {
    -- https://github.com/gera2ld/ai.nvim
    "gera2ld/ai.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>ai", "<cmd>AIImprove<CR>", mode = "x" },
      { "<leader>ai", ":AIImprove ", mode = "n" },
      { "<leader>aa", "<cmd>AIAsk<CR>", mode = "x" },
      { "<leader>aa", ":AIAsk ", mode = "n" },
      { "<leader>ad", "<cmd>AIDefine<CR>", mode = "x" },
      { "<leader>ad", ":AIDefine ", mode = "n" },
      { "<leader>at", "<cmd>AITranslate<CR>", mode = "x" },
      { "<leader>at", ":AITranslate ", mode = "n" },
    },
    opts = {
      ---- AI's answer is displayed in a popup buffer
      ---- Default behaviour is not to give it the focus because it is seen as a kind of tooltip
      ---- But if you prefer it to get the focus, set to true.
      result_popup_gets_focus = true,
      ---- Override default prompts here, see below for more details
      -- prompts = {},
      ---- Default models for each prompt, can be overridden in the prompt definition
      models = {
        -- {
        --   provider = 'gemini',
        --   model = 'gemini-1.5-flash',
        --   result_tpl = '## Gemini\n\n{{output}}',
        -- },
        {
          provider = "gemini",
          -- model = 'gemini-pro',
          model = "gemini-1.5-flash",
          result_tpl = "## Gemini\n\n{{output}}",
        },
        -- {
        --   provider = 'openai',
        --   model = 'gpt-3.5-turbo',
        --   result_tpl = '## GPT-3.5\n\n{{output}}',
        -- },
      },

      --- API keys and relavant config
      gemini = {
        -- api_key = 'YOUR_GEMINI_API_KEY',
        -- model = 'gemini-pro',
        model = "gemini-1.5-flash",
        -- proxy = '',
      },
      -- openai = {
      --   api_key = 'YOUR_OPENAI_API_KEY',
      --   -- base_url = 'https://api.openai.com/v1',
      --   -- model = 'gpt-4',
      --   -- proxy = '',
      -- },
    },
    config = function()
      local ai = require("ai")
      ai.setup({ gemini = { api_key = os.getenv("GEMINI_API_KEY") } })
    end,
    event = "VeryLazy",
  },
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
    },
    -- Remove the following line to use development versions,
    -- not just the formal releases
    -- version = "*"
  },
  {
    -- https://github.com/uga-rosa/ccc.nvim
    "uga-rosa/ccc.nvim",
    keys = { { "<leader>cc", "<cmd>CccPick<cr>" }, { "<C-S-c>", "<Plug>(ccc-insert)", mode = "i" } },
    config = function()
      -- local opts = { noremap = false, silent = true }
      -- vim.keymap.set("n", "<leader>cc", "<cmd>CccPick<cr>", opts)
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
    -- https://github.com/cenk1cenk2/scratch.nvim
    "cenk1cenk2/scratch.nvim",
    config = {
      vim.api.nvim_command([[
      command! -nargs=? Scratch :lua require("scratch").create({ filetype = <q-args> })
      ]]),
    },
  },
  {
    -- https://github.com/tpope/vim-abolish
    "tpope/vim-abolish",
    cmd = { "Abolish", "S", "Subvert" },
    keys = { { "cr" } },
  },
  {
    -- https://github.com/numToStr/Comment.nvim
    "numToStr/Comment.nvim",
    dependencies = {
      -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    keys = {
      { "gcc" },
      { "gc" },
      { "gc", mode = "v" },
      { "gb" },
      { "gb", mode = "v" },
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
  -- {
  --   -- https://github.com/windwp/nvim-autopairs
  --   -- Replaced by mini.pairs
  --   "windwp/nvim-autopairs",
  --   keys = {
  --     { "{", mode = "i" },
  --     { "[", mode = "i" },
  --     { "(", mode = "i" },
  --     { "<", mode = "i" },
  --     { "'", mode = "i" },
  --     { '"', mode = "i" },
  --   },
  --   config = function()
  --     require("nvim-autopairs").setup({})
  --   end,
  -- },
  {
    -- https://github.com/altermo/ultimate-autopair.nvim
    "altermo/ultimate-autopair.nvim",
    event = {
      "InsertEnter",
      -- 'CmdlineEnter'
    },
    -- branch = 'v0.6', --recommended as each new version will have breaking changes
    opts = {
      cmap = false,
      tabout = {
        enable = true,
      },
      internal_pairs = { -- *ultimate-autopair-pairs-default-pairs*
        { "[", "]", fly = true, dosuround = true, newline = true, space = true },
        { "(", ")", fly = true, dosuround = true, newline = true, space = true },
        { "{", "}", fly = true, dosuround = true, newline = true, space = true },
        { '"', '"', suround = true, multiline = false },
        {
          "'",
          "'",
          suround = true,
          cond = function(fn)
            return not fn.in_lisp() or fn.in_string()
          end,
          alpha = true,
          nft = { "tex" },
          multiline = false,
        },
        {
          "`",
          "`",
          cond = function(fn)
            return not fn.in_lisp() or fn.in_string()
          end,
          nft = { "tex" },
          multiline = false,
        },
        { "``", "''", ft = { "tex" } },
        { "```", "```", newline = true, ft = { "markdown" } },
        { "<!--", "-->", ft = { "markdown", "html" }, space = true },
        { '"""', '"""', newline = true, ft = { "python" } },
        { "'''", "'''", newline = true, ft = { "python" } },
        {
          "<",
          ">",
          newline = true,
          dosuround = true,
          ft = { "html", "xml", "xsl", "xslt", "javascriptreact", "typescriptreact" },
        },
      },
    },
  },
  {
    -- https://github.com/junegunn/vim-easy-align
    "junegunn/vim-easy-align",
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
      vim.call("textobj#uri#add_pattern", "", "[bB]ug:\\? #\\?\\([0-9]\\+\\)", ":silent !open-cli 'http://forge.univention.org/bugzilla/show_bug.cgi?id=%s' &")
      vim.call(
        "textobj#uri#add_pattern",
        "",
        "[tT]icket:\\? #\\?\\([0-9]\\+\\)",
        ":silent !open-cli 'https://gorm.knut.univention.de/otrs/index.pl?Action=AgentTicketZoom&TicketNumber=%s' &"
      )
      vim.call("textobj#uri#add_pattern", "", "[iI]ssue:\\? #\\?\\([0-9]\\+\\)", ":silent !open-cli 'https://univention.plan.io/issues/%s' &")
      vim.call("textobj#uri#add_pattern", "", "[tT][gG]-\\([0-9]\\+\\)", ":!open-cli 'https://tree.taiga.io/project/jceb-identinet-development/us/%s' &")
    end,
  },
  {
    -- https://github.com/vim-scripts/VisIncr
    "vim-scripts/VisIncr",
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
      map("n", "<Plug>SwapItFallbackIncrement", ":<C-u>let sc=v:count1<Bar>call speeddating#increment(sc)<Bar>unlet sc<CR>", opts)
      map("n", "<Plug>SwapItFallbackDecrement", ":<C-u>let sc=v:count1<Bar>call speeddating#increment(-sc)<Bar>unlet sc<CR>", opts)
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
    cmd = { "LanguageToolCheck" },
    build = { vim.fn.stdpath("config") .. "/download_LanguageTool.sh" },
    config = function()
      vim.g.languagetool_jar = vim.fn.stdpath("config") .. "/opt/LanguageTool/languagetool-commandline.jar"
    end,
  },
  -- {
  --     -- https://github.com/ThePrimeagen/refactoring.nvim
  --     "ThePrimeagen/refactoring.nvim",
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
    keys = { "<leader>tM", "<leader>tJ", "<leader>tS" },
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
