map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

return {
  ----------------------
  -- visuals
  ----------------------
  {
    -- https://github.com/jceb/blinds.nvim
    "jceb/blinds.nvim",
    config = function()
      vim.g.blinds_guibg = "#cdcdcd"
    end,
  },
  -- {
  --   -- https://github.com/xiyaowong/nvim-cursorword
  --   -- Replaced by mini.cursorword
  --   "xiyaowong/nvim-cursorword",
  --   init = function()
  --     vim.cmd([[
  --     hi link CursorWord DiffAdd
  --     augroup MyCursorWord
  --     autocmd!
  --     autocmd VimEnter,Colorscheme * hi link CursorWord DiffAdd
  --     augroup END
  --     ]])
  --   end,
  -- },
  {
    -- https://github.com/rktjmp/highlight-current-n.nvim
    "rktjmp/highlight-current-n.nvim",
    lazy = true,
    keys = { { "n" }, { "N" } },
    config = function()
      vim.cmd([[
        nmap n <Plug>(highlight-current-n-n)
        nmap N <Plug>(highlight-current-n-N)
        ]])
    end,
  },
  -- {
  --     -- https://github.com/lukas-reineke/indent-blankline.nvim
  --     "lukas-reineke/indent-blankline.nvim",
  -- },
  {
    -- https://github.com/vasconcelloslf/vim-interestingwords
    "vasconcelloslf/vim-interestingwords",
    lazy = true,
    keys = { { "<Space>i", '<cmd>call InterestingWords("n")<CR>' }, { "<Space>i", '<cmd>call InterestingWords("v")<CR>', mode = "v" } },
    init = function()
      vim.g.interestingWordsDefaultMappings = 0
      vim.cmd([[
        command! InterestingWordsClear :call UncolorAllWords()
      ]])
    end,
  },
  -- {
  --   -- https://github.com/jceb/Lite-Tab-Page
  --   "jceb/Lite-Tab-Page",
  -- },
  {
    -- https://github.com/andymass/vim-matchup
    "andymass/vim-matchup",
    event = "VimEnter",
  },
  {
    -- https://github.com/NvChad/nvim-colorizer.lua
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  -- {
  --   -- https://github.com/itchyny/lightline.vim
  --   "itchyny/lightline.vim",
  --   -- lazy = true,
  --   name = "lightline",
  --   init = function()
  --     vim.cmd([[
  --         function! LightLineFilename(n)
  --         let buflist = tabpagebuflist(a:n)
  --         let winnr = tabpagewinnr(a:n)
  --         let _ = expand('#'.buflist[winnr - 1].':p')
  --         let stripped_ = substitute(_, '^'.fnamemodify(getcwd(tabpagewinnr(a:n), a:n), ':h').'/', '', '')
  --         return _ !=# '' ? (stripped_ !=# '' ? stripped_ : _) :  '[No Name]'
  --         endfunction
  --         ]])
  --     vim.g.lightline = {
  --       colorscheme = "PaperColor_light",
  --       component = {
  --         bomb = '%{&bomb?"💣":""}',
  --         diff = '%{&diff?"◑":""}',
  --         lineinfo = " %3l:%-2v",
  --         modified = '%{&modified?"±":""}',
  --         noeol = '%{&endofline?"":"!↵"}',
  --         readonly = '%{&readonly?"":""}',
  --         scrollbind = '%{&scrollbind?"∞":""}',
  --       },
  --       component_visible_condition = {
  --         bomb = "&bomb==1",
  --         diff = "&diff==1",
  --         modified = "&modified==1",
  --         noeol = "&endofline==0",
  --         scrollbind = "&scrollbind==1",
  --       },
  --       -- FIXME somehow lightline doesn't accept an empty list
  --       -- here
  --       component_function = {
  --         test = "fake",
  --       },
  --       tab_component_function = {
  --         tabfilename = "LightLineFilename",
  --       },
  --       separator = { left = "", right = "" },
  --       subseparator = { left = "", right = "" },
  --       tab = {
  --         active = { "tabnum", "tabfilename", "modified" },
  --         inactive = { "tabnum", "tabfilename", "modified" },
  --       },
  --       active = {
  --         left = {
  --           { "winnr", "mode", "paste" },
  --           {
  --             "bomb",
  --             "diff",
  --             "scrollbind",
  --             "noeol",
  --             "readonly",
  --             "filename",
  --             "modified",
  --           },
  --         },
  --         right = {
  --           { "lineinfo" },
  --           { "percent" },
  --           { "fileformat", "fileencoding", "filetype" },
  --         },
  --       },
  --       inactive = {
  --         left = {
  --           {
  --             "winnr",
  --             "diff",
  --             "scrollbind",
  --             "filename",
  --             "modified",
  --           },
  --         },
  --         right = { { "lineinfo" }, { "percent" } },
  --       },
  --     }
  --   end,
  -- },

  {
    -- https://github.com/rebelot/heirline.nvim
    "rebelot/heirline.nvim",
    dependencies = {
      -- https://github.com/nvim-tree/nvim-web-devicons
      "nvim-tree/nvim-web-devicons",
      -- https://github.com/SmiteshP/nvim-navic
      -- moved to lspconfig
      -- "SmiteshP/nvim-navic",
    },
    config = function()
      require('heirline').setup(require('plugins.statusline.config').config)
      vim.cmd([[
      nnoremap <unique> <A-1> 1gt
      nnoremap <unique> <A-2> 2gt
      nnoremap <unique> <A-3> 3gt
      nnoremap <unique> <A-4> 4gt
      nnoremap <unique> <A-5> 5gt
      nnoremap <unique> <A-6> 6gt
      nnoremap <unique> <A-7> 7gt
      nnoremap <unique> <A-8> 8gt
      nnoremap <unique> <A-9> 9gt
      nnoremap <unique> <A-0> 10gt

      nnoremap <unique> <A-h> gT
      nnoremap <unique> <A-l> gt
      nnoremap <silent> <A-H> :call LiteTabMove(-2)<CR>
      nnoremap <silent> <A-L> :call LiteTabMove(1)<CR>

      function! LiteTabMove(idx)
          let index = tabpagenr() + a:idx
          if (index < 0)
              return
          endif
          silent execute 'tabmove ' . index
      endfunction
      ]])
    end
  },
  -- {
  --   -- https://github.com/hoob3rt/lualine.nvim
  --   "hoob3rt/lualine.nvim",
  --   dependencies = {
  --     -- https://github.com/nvim-tree/nvim-web-devicons
  --     "nvim-tree/nvim-web-devicons",
  --     lazy = true
  --   },
  --   config = function()
  --     require('lualine').setup()
  --   end
  -- },
  {
    -- https://github.com/NLKNguyen/papercolor-theme
    "NLKNguyen/papercolor-theme",
    name = "papercolor",
    lazy = true,
    init = function()
      vim.g.PaperColor_Theme_Options = {
        theme = {
          default = {
            light = {
              transparent_background = 1,
              override = {
                color04 = { "#87afd7", "110" },
                color16 = { "#87afd7", "110" },
                statusline_active_fg = { "#444444", "238" },
                statusline_active_bg = { "#eeeeee", "255" },
                visual_bg = { "#005f87", "110" },
                folded_fg = { "#005f87", "31" },
                difftext_fg = { "#87afd7", "110" },
                tabline_inactive_bg = { "#87afd7", "110" },
                buftabline_inactive_bg = { "#87afd7", "110" },
              },
            },
          },
        },
      }
    end,
  },
  {
    -- https://github.com/catppuccin/nvim
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
  },
  {
    -- https://github.com/folke/tokyonight.nvim
    "folke/tokyonight.nvim",
    name = "tokyonight",
    lazy = true,
  },
  {
    -- Alternative: to nord-vim?
    -- https://github.com/shaunsingh/nord.nvim
    "shaunsingh/nord.nvim",
    name = "nord",
    lazy = true,
  },
  -- {
  --     -- https://github.com/arcticicestudio/nord-vim
  --     "arcticicestudio/nord-vim",
  --     name = "nord",
  --     lazy = true,
  -- },
  -- -- Use specific branch, dependency and run lua file after load
  -- use {
  --     -- https://github.com/glepnir/galaxyline.nvim
  --   "glepnir/galaxyline.nvim", branch = 'main', config = function() require'statusline' end,
  --  dependencies = {
  --      -- https://github.com/nvim-tree/nvim-web-devicons
  --      "nvim-tree/nvim-web-devicons"}
  -- }

  -- use {
  --     -- https://github.com/romgrk/barbar.nvim
  --    "romgrk/barbar.nvim",
  --    dependencies = {
  --        -- https://github.com/nvim-tree/nvim-web-devicons
  --        "nvim-tree/nvim-web-devicons"},
  -- config = function()
  --   -- check out https://github.com/akinsho/nvim-bufferline.lua if not satisfied
  --   -- with barbar
  --   vim.g.bufferline = {
  --     icon_pinned = '車',
  --     exclude_ft = { 'dirvish' }
  --   }
  --
  --     local opts = { noremap = true, silent = true }
  --
  --       -- Tab movement
  --       map('n', '<M-h>', 'gT', opts)
  --       map('n', '<M-S-h>', '<cmd>tabmove -<CR>', opts)
  --       map('n', '<M-l>', 'gt', opts)
  --       map('n', '<M-S-l>', '<cmd>tabmove +<CR>', opts)
  --       map('n', '<M-C-1>', '1gt', opts)
  --       map('n', '<M-C-2>', '2gt', opts)
  --       map('n', '<M-C-3>', '3gt', opts)
  --       map('n', '<M-C-4>', '4gt', opts)
  --       map('n', '<M-C-5>', '5gt', opts)
  --       map('n', '<M-C-6>', '6gt', opts)
  --       map('n', '<M-C-7>', '7gt', opts)
  --       map('n', '<M-C-8>', '8gt', opts)
  --       map('n', '<M-C-9>', '9gt', opts)
  --
  --       -- Move to previous/next
  --       map('n', '<A-,>', ':BufferPrevious<CR>', opts)
  --       map('n', '<A-.>', ':BufferNext<CR>', opts)
  --       -- Re-order to previous/next
  --       map('n', '<A-<>', ':BufferMovePrevious<CR>', opts)
  --       map('n', '<A->>', ' :BufferMoveNext<CR>', opts)
  --       -- Goto buffer in position...
  --       map('n', '<A-1>', ':BufferGoto 1<CR>', opts)
  --       map('n', '<A-2>', ':BufferGoto 2<CR>', opts)
  --       map('n', '<A-3>', ':BufferGoto 3<CR>', opts)
  --       map('n', '<A-4>', ':BufferGoto 4<CR>', opts)
  --       map('n', '<A-5>', ':BufferGoto 5<CR>', opts)
  --       map('n', '<A-6>', ':BufferGoto 6<CR>', opts)
  --       map('n', '<A-7>', ':BufferGoto 7<CR>', opts)
  --       map('n', '<A-8>', ':BufferGoto 8<CR>', opts)
  --       map('n', '<A-9>', ':BufferGoto 9<CR>', opts)
  --       map('n', '<A-0>', ':BufferLast<CR>', opts)
  --       -- Pin/unpin buffer
  --       map('n', '<A-b>', ':BufferPin<CR>', opts)
  --       -- Close buffer
  --       map('n', '<A-c>', ':BufferClose<CR>', opts)
  --       -- Wipeout buffer
  --       --                 :BufferWipeout<CR>
  --       -- Close commands
  --       --                 :BufferCloseAllButCurrent<CR>
  --       --                 :BufferCloseBuffersLeft<CR>
  --       --                 :BufferCloseBuffersRight<CR>
  --       -- Magic buffer-picking mode
  --       map('n', '<C-s>', ':BufferPick<CR>', opts)
  --   end
  -- }
  -- {
  --   -- https://github.com/folke/todo-comments.nvim
  --   "folke/todo-comments.nvim",
  --   dependencies = {
  --     -- -- https://github.com/nvim-lua/plenary.nvim
  --     -- 'nvim-lua/plenary.nvim',
  --     -- https://github.com/nvim-lua/popup.nvim
  --     "nvim-lua/popup.nvim",
  --   },
  --   -- lazy = true,
  --   -- cmd = {
  --   --   'TodoTelescope',
  --   --   'TodoQuickFix',
  --   --   'TodoLocList',
  --   --   'TodoTrouble',
  --   -- },
  --   opts = { signs = false },
  -- },

  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  -- { -- Adds git related signs to the gutter, as well as utilities for managing changes
  --   -- https://github.com/lewis6991/gitsigns.nvim
  --   "lewis6991/gitsigns.nvim",
  --   opts = {
  --     signs = {
  --       add = { text = "+" },
  --       change = { text = "~" },
  --       delete = { text = "_" },
  --       topdelete = { text = "‾" },
  --       changedelete = { text = "~" },
  --     },
  --   },
  -- },

  -- {                     -- Useful plugin to show you pending keybinds.
  --   "folke/which-key.nvim",
  --   event = "VimEnter", -- Sets the loading event to 'VimEnter'
  --   config = function() -- This is the function that runs, AFTER loading
  --     require("which-key").setup()
  --
  --     -- Document existing key chains
  --     require("which-key").register({
  --       ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
  --       ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
  --       ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
  --       ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
  --       ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
  --     })
  --   end,
  -- },
}
