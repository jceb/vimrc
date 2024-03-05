map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

return {
  ----------------------
  -- movement
  ----------------------
  -- {
  --     -- https://github.com/ggandor/lightspeed.nvim
  --     "ggandor/lightspeed.nvim",
  --     init = function()
  --         map("n", "<Space>/", "/", { noremap = true })
  --         map("n", "<Space>?", "?", { noremap = true })
  --         map("n", "/", "<Plug>Lightspeed_s", {})
  --         map("n", "?", "<Plug>Lightspeed_S", {})
  --         map("x", "/", "<Plug>Lightspeed_x", {})
  --         map("x", "?", "<Plug>Lightspeed_X", {})
  --     end,
  -- },
  -- {
  --     -- https://github.com/anuvyklack/hydra.nvim
  --     "anuvyklack/hydra.nvim",
  --     config = function()
  --         local Hydra = require("hydra")
  --         -- local dap = require("dap")
  --
  --         -- Hydra({
  --         --     name = "Debug",
  --         --     mode = { "n", "x" },
  --         --     body = "<Space>,",
  --         --     heads = {
  --         --         -- { "b", dap.toggle_breakpoint, { desc = "toggle breakpoint", silent = true } },
  --         --         -- { "c", dap.continue, { desc = "continue", silent = true } },
  --         --         -- { "i", dap.step_into, { desc = "step in", silent = true } },
  --         --         -- { "o", dap.step_out, { desc = "step out", silent = true } },
  --         --         -- { "q", dap.close, { desc = "quit hydra", exit = true } },
  --         --         -- { "r", dap.repl_open, { desc = "repl", silent = true } },
  --         --         -- { "R", dap.run_last, { desc = "run last" }, silent = true },
  --         --         -- { "s", dap.step_over, { desc = "step over", silent = true } },
  --         --         { "b", "<cmd>DapToggleBreakpoint<CR>", { desc = "toggle breakpoint", silent = true } },
  --         --         { "c", "<cmd>DapContinue<CR>", { desc = "continue", silent = true } },
  --         --         { "C", "<cmd>DapRerun<CR>", { desc = "run last" }, silent = true },
  --         --         { "i", "<cmd>DapStepInto<CR>", { desc = "step in", silent = true } },
  --         --         { "o", "<cmd>DapStepOut<CR>", { desc = "step out", silent = true } },
  --         --         { "q", "<cmd>DapStop<CR>", { desc = "quit hydra", exit = true } },
  --         --         { "r", "<cmd>DapToggleRepl<CR>", { desc = "repl", silent = true } },
  --         --         { "s", "<cmd>DapStepOver<CR>", { desc = "step over", silent = true } },
  --         --     },
  --         -- })
  --         Hydra({
  --             name = "Window",
  --             mode = "n",
  --             body = "<Space>w",
  --             heads = {
  --                 { "h", "<C-w>h" },
  --                 { "H", "<C-w>H" },
  --                 { "j", "<C-w>j" },
  --                 { "J", "<C-w>J" },
  --                 { "k", "<C-w>k" },
  --                 { "K", "<C-w>K" },
  --                 { "l", "<C-w>l" },
  --                 { "L", "<C-w>L" },
  --                 { "p", "<C-w>p" },
  --                 { "s", "<C-w>s", { desc = "hsplit" } },
  --                 { ",", "gT", { desc = "prev pab" } },
  --                 { ".", "gt", { desc = "next tab" } },
  --                 { "v", "<C-w>v", { desc = "vsplit" } },
  --             },
  --         })
  --     end,
  -- },
  -- {
  --     -- https://github.com/ggandor/leap.nvim
  --     "ggandor/leap.nvim",
  --     config = function()
  --         local leap = require("leap")
  --         leap.add_default_mappings()
  --         -- for _, _1_ in ipairs({
  --         --     { { "n", "x", "o" }, "s", "<Plug>(leap-forward-to)", "Leap forward to" },
  --         --     { { "n", "x", "o" }, "S", "<Plug>(leap-backward-to)", "Leap backward to" },
  --         --     -- { { "x", "o" }, "x", "<Plug>(leap-forward-till)", "Leap forward till" },
  --         --     -- { { "x", "o" }, "X", "<Plug>(leap-backward-till)", "Leap backward till" },
  --         --     -- { { "n", "x", "o" }, "gs", "<Plug>(leap-from-window)", "Leap from window" },
  --         --     -- { { "n", "x", "o" }, "gs", "<Plug>(leap-cross-window)", "Leap from window" },
  --         -- }) do
  --         --     local _each_2_ = _1_
  --         --     local modes = _each_2_[1]
  --         --     local lhs = _each_2_[2]
  --         --     local rhs = _each_2_[3]
  --         --     local desc = _each_2_[4]
  --         --     for _0, mode in ipairs(modes) do
  --         --         if (vim.fn.mapcheck(lhs, mode) == "") and (vim.fn.hasmapto(rhs, mode) == 0) then
  --         --             vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
  --         --         else
  --         --         end
  --         --     end
  --         -- end
  --         -- for _, _4_ in ipairs({
  --         --     { "n", "s", "<Plug>(leap-forward)" },
  --         --     { "n", "S", "<Plug>(leap-backward)" },
  --         --     -- { "x", "s", "<Plug>(leap-forward)" },
  --         --     -- { "x", "S", "<Plug>(leap-backward)" },
  --         --     -- { "o", "z", "<Plug>(leap-forward)" },
  --         --     -- { "o", "Z", "<Plug>(leap-backward)" },
  --         --     -- { "o", "x", "<Plug>(leap-forward-x)" },
  --         --     -- { "o", "X", "<Plug>(leap-backward-x)" },
  --         --     -- { "n", "gs", "<Plug>(leap-cross-window)" },
  --         --     -- { "x", "gs", "<Plug>(leap-cross-window)" },
  --         --     -- { "o", "gs", "<Plug>(leap-cross-window)" },
  --         -- }) do
  --         --     local _each_5_ = _4_
  --         --     local mode = _each_5_[1]
  --         --     local lhs = _each_5_[2]
  --         --     local rhs = _each_5_[3]
  --         --     if (vim.fn.mapcheck(lhs, mode) == "") and (vim.fn.hasmapto(rhs, mode) == 0) then
  --         --         vim.keymap.set(mode, lhs, rhs, { silent = true })
  --         --     else
  --         --     end
  --         -- end
  --     end,
  -- },
  {
    -- TODO: replace hop
    -- https://github.com/phaazon/hop.nvim
    "phaazon/hop.nvim",
    branch = "v2", -- optional but strongly recommended
    keys = {
      { "s", "<cmd>HopChar1AC<cr>" },
      { "S", "<cmd>HopChar1BC<cr>" },
      { "s", "<cmd>HopChar1AC<cr>", { mode = "o", } },
      { "S", "<cmd>HopChar1BC<cr>", { mode = "o", } },
    },
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      -- require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
      require("hop").setup()
      -- map("n", "<Space>/", "/", { noremap = true })
      -- map("n", "<Space>?", "?", { noremap = true })
      -- map("n", "s", "<cmd>HopChar1AC<cr>", {})
      -- map("n", "S", "<cmd>HopChar1BC<cr>", {})
      -- map("o", "s", "<cmd>HopChar1AC<cr>", {})
      -- map("o", "S", "<cmd>HopChar1BC<cr>", {})
      -- map("n", "/", "<cmd>HopChar2AC<cr>", {})
      -- map("n", "?", "<cmd>HopChar2BC<cr>", {})
      -- map("o", "/", "<cmd>HopChar2AC<cr>", {})
      -- map("o", "?", "<cmd>HopChar2BC<cr>", {})
    end,
  },
  {
    -- https://github.com/Houl/repmo-vim
    "Houl/repmo-vim",
    name = "repmo",
    init = function()
      local opts = { noremap = true, expr = true }
      -- map a motion and its reverse motion:
      map("", "h", 'repmo#SelfKey("h", "l")', opts)
      unmap("s", "h")
      map("", "l", 'repmo#SelfKey("l", "h")', opts)
      unmap("s", "l")
      map("", "<C-E>", 'repmo#SelfKey("<C-E>", "<C-Y>")', opts)
      unmap("s", "<C-E>")
      map("", "<C-Y>", 'repmo#SelfKey("<C-Y>", "<C-E>")', opts)
      unmap("s", "<C-Y>")
      map("", "<C-D>", 'repmo#SelfKey("<C-D>", "<C-U>")', opts)
      unmap("s", "<C-D>")
      map("", "<C-U>", 'repmo#SelfKey("<C-U>", "<C-D>")', opts)
      unmap("s", "<C-U>")
      map("", "<C-F>", 'repmo#SelfKey("<C-F>", "<C-B>")', opts)
      unmap("s", "<C-F>")
      map("", "<C-B>", 'repmo#SelfKey("<C-B>", "<C-F>")', opts)
      unmap("s", "<C-B>")
      map("", "e", 'repmo#SelfKey("e", "ge")', opts)
      unmap("s", "e")
      map("", "ge", 'repmo#SelfKey("ge", "e")', opts)
      unmap("s", "ge")
      map("", "b", 'repmo#SelfKey("b", "w")', opts)
      unmap("s", "b")
      map("", "w", 'repmo#SelfKey("w", "b")', opts)
      unmap("s", "w")
      map("", "B", 'repmo#SelfKey("B", "W")', opts)
      unmap("s", "B")
      map("", "W", 'repmo#SelfKey("W", "B")', opts)
      unmap("s", "W")
      -- repeat the last [count]motion or the last zap-key:
      map("", ";", 'repmo#LastKey(";")', opts)
      unmap("s", ";")
      map("", ",", 'repmo#LastRevKey(",")', opts)
      unmap("s", ",")
      -- add these mappings when repeating with `;' or `,':
      map("", "f", 'repmo#ZapKey("f", 1)', opts)
      unmap("s", "f")
      map("", "F", 'repmo#ZapKey("F", 1)', opts)
      unmap("s", "F")
      map("", "t", 'repmo#ZapKey("t", 1)', opts)
      unmap("s", "t")
      map("", "T", 'repmo#ZapKey("T", 1)', opts)
      unmap("s", "T")
    end,
  },
  {
    -- https://github.com/arp242/jumpy.vim
    "arp242/jumpy.vim",
  },
  {
    -- https://github.com/vim-scripts/lastpos.vim
    "vim-scripts/lastpos.vim",
  },
  -- {
  --   -- https://github.com/vladdoster/remember.nvim
  --   "vladdoster/remember.nvim",
  -- },
  {
    -- https://github.com/jceb/vim-shootingstar
    "jceb/vim-shootingstar",
    keys = { "\\*" }
  },
  {
    -- https://github.com/mg979/vim-visual-multi
    "mg979/vim-visual-multi",
    lazy = true,
    keys = {
      { "<C-j>" },
      { "<C-k>" },
      { "<C-c>" },
      { "<C-n>" },
      { "<C-n>", mode = "v" },
    },
    init = function()
      vim.cmd([[
                                let g:VM_Mono_hl   = 'Substitute'
                                let g:VM_Cursor_hl = 'IncSearch'
                                ]])
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
        ["Next"] = "n",
        ["Previous"] = "N",
        ["Skip"] = "q",
        ["Add Cursor Down"] = "<C-j>",
        ["Add Cursor Up"] = "<C-k>",
        ["Select l"] = "<S-Left>",
        ["Select r"] = "<S-Right>",
        ["Add Cursor at Position"] = [[\\\]],
        ["Select All"] = "<C-c>",
        ["Visual All"] = "<C-c>",
        -- ["Start Regex Search"] = "<C-/>",
        ["Exit"] = "<Esc>",
      }
      -- let g:VM_leader = {'default': '\', 'visual': '\', 'buffer': 'z'}
    end,
  },
  {
    -- https://github.com/vim-scripts/StarRange
    "vim-scripts/StarRange",
    keys = { "*" }
  },
  {
    -- https://github.com/tpope/vim-unimpaired
    "tpope/vim-unimpaired",
    lazy = true,
    keys = {
      { "yoc" },
      { "yod" },
      { "yoh" },
      { "yoi" },
      { "yol" },
      { "yon" },
      { "yor" },
      { "yos" },
      { "you" },
      { "yow" },
      { "yox" },
      { "[a" },
      { "]a" },
      { "[A" },
      { "]A" },
      { "[b" },
      { "]b" },
      { "[B" },
      { "]B" },
      { "[e" },
      { "]e" },
      { "[f" },
      { "]f" },
      { "[l" },
      { "]l" },
      { "[L" },
      { "]L" },
      { "[n" },
      { "]n" },
      { "[q" },
      { "]q" },
      { "[Q" },
      { "]Q" },
      { "[t" },
      { "]t" },
      { "[T" },
      { "]T" },
      { "[u" },
      { "]u" },
      { "[x" },
      { "]x" },
      { "[y" },
      { "]y" },
      { "[Y" },
      { "]Y" },
      { "[<Space>" },
      { "]<Space>" },
    },
    config = function()
      -- disable legacy mappings
      map("n", "co", "<Nop>", {})
      map("n", "=o", "<Nop>", {})

      vim.cmd([[
        function! Base64_encode(str) abort
        return luaeval('require("base64").enc(_A)', a:str)
        endfunction

        function! Base64_decode(str) abort
        return luaeval('require("base64").dec(_A)', a:str)
        endfunction

        call UnimpairedMapTransform('Base64_encode','[Y')
        call UnimpairedMapTransform('Base64_decode',']Y')
      ]])
      -- change configuration settings quickly
      vim.cmd([[
        function! Toggle_op2(op, op2, value)
            return a:value == eval('&'.a:op2) && eval('&'.a:op) ? 'no'.a:op : a:op
        endfunction

        function! Toggle_sequence(op, value)
            return strridx(eval('&'.a:op), a:value) == -1 ? a:op.'+='.a:value : a:op.'-='.a:value
        endfunction

        function! Toggle_value(op, value, default)
            return eval('&'.a:op) == a:default ? a:value : a:default
        endfunction

        " taken from unimpaired plugin
        function! Statusbump() abort
            let &l:readonly = &l:readonly
            return ''
        endfunction

        function! Toggle(op) abort
            call Statusbump()
            return eval('&'.a:op) ? 'no'.a:op : a:op
        endfunction

        function! Option_map(letter, option) abort
            exe 'nnoremap [o'.a:letter ':set '.a:option.'<C-R>=Statusbump()<CR><CR>'
            exe 'nnoremap ]o'.a:letter ':set no'.a:option.'<C-R>=Statusbump()<CR><CR>'
            exe 'nnoremap co'.a:letter ':set <C-R>=Toggle("'.a:option.'")<CR><CR>'
            exe 'nnoremap yo'.a:letter ':set <C-R>=Toggle("'.a:option.'")<CR><CR>'
        endfunction

        call Option_map('t', 'expandtab')
      ]])
      map("n", "yo#", ":setlocal <C-R>=Toggle_sequence('fo', 'n')<CR><CR>", { noremap = true })
      map("n", "yoq", ":setlocal <C-R>=Toggle_sequence('fo', 'tc')<CR><CR>", { noremap = true })
      map("n", "yoD", ":setlocal <C-R>=&scrollbind ? 'noscrollbind' : 'scrollbind'<CR><CR>", { noremap = true })
      map("n", "yog",
        ":setlocal complete-=kspell spelllang=de_de <C-R>=Toggle_op2('spell', 'spelllang', 'de_de')<CR><CR>",
        { noremap = true })
      map("n", "yoe",
        ":setlocal complete+=kspell spelllang=en_us <C-R>=Toggle_op2('spell', 'spelllang', 'en_us')<CR><CR>",
        { noremap = true })
      map("n", "yok", ":setlocal <C-R>=Toggle_sequence('complete',  'kspell')<CR><CR>", { noremap = true })
      map("n", "yoW", ":vertical resize 50<Bar>setlocal winfixwidth<CR>", { noremap = true })
      map("n", "yoH", ":resize 20<Bar>setlocal winfixheight<CR>", { noremap = true })
      map("n", "yofh", ":setlocal <C-R>=&winfixheight ? 'nowinfixheight' : 'winfixheight'<CR><CR>", { noremap = true })
      map("n", "yofw", ":setlocal <C-R>=&winfixwidth ? 'nowinfixwidth' : 'winfixwidth'<CR><CR>", { noremap = true })
      map("n", "yofx",
        ":setlocal <C-R>=&winfixheight ? 'nowinfixheight nowinfixwidth' : 'winfixheight winfixwidth'<CR><CR>",
        { noremap = true })
      vim.cmd([[
        exec ":nnoremap yoI :set inccommand=<C-R>=Toggle_value('inccommand', '', '".&inccommand."')<CR><CR>"
        exec ":nnoremap yoz :set scrolloff=<C-R>=Toggle_value('scrolloff', 999, ".&scrolloff.")<CR><CR>"
        exec ":nnoremap yoZ :set sidescrolloff=<C-R>=Toggle_value('sidescrolloff', 999, ".&sidescrolloff.")<CR><CR>"
      ]])
    end,
  },
  {
    -- https://github.com/tpope/vim-rsi
    "tpope/vim-rsi",
    init = function()
      vim.g.rsi_no_meta = 1
    end,
  },
  {
    -- https://github.com/vim-scripts/diffwindow_movement
    "vim-scripts/diffwindow_movement",
    lazy = true,
    dependencies = {
      -- https://github.com/inkarkat/vim-CountJump
      "inkarkat/vim-CountJump",
      -- https://github.com/inkarkat/vim-ingo-library
      "inkarkat/vim-ingo-library",
    },
    config = function()
      local opts = { noremap = true }
      map(
        "n",
        "]C",
        ':<C-u>call CountJump#JumpFunc("n", "CountJump#Region#JumpToNextRegion", function("diffwindow_movement#IsDiffLine"), 1, 1, 1, 0)<CR>',
        opts
      )
      map(
        "n",
        "[C",
        ':<C-u>call CountJump#JumpFunc("n", "CountJump#Region#JumpToNextRegion", function("diffwindow_movement#IsDiffLine"), 1, -1, 0, 0)<CR>',
        opts
      )
    end,
  },
  {
    -- https://github.com/abecodes/tabout.nvim
    "abecodes/tabout.nvim",
    -- opt=true,
    -- keys = {{'<C-j>', mode = 'i' }},
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- or require if not used so far
    config = function()
      require("tabout").setup({
        tabkey = "",              -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = "",    -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = false,       -- shift content if tab out is not possible
        act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        enable_backwards = true,  -- well ...
        completion = false,       -- if the tabkey is used in a completion pum
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = "`", close = "`" },
          { open = "(", close = ")" },
          { open = "[", close = "]" },
          { open = "{", close = "}" },
          { open = "<", close = ">" },
        },
        ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
        exclude = {}, -- tabout will ignore these filetypes
      })
    end,
  },
  -- {
  --     -- TODO: not yet fully configured
  --     -- https://github.com/ray-x/navigator.lua
  --     "ray-x/navigator.lua",
  --     -- lazy = true,
  --     dependencies = {
  --         {
  --             -- https://github.com/ray-x/guihua.lua
  --             "ray-x/guihua.lua",
  --             build = "cd lua/fzy; make",
  --         },
  --         -- https://github.com/nvim-treesitter/nvim-treesitter-refactor
  --         "nvim-treesitter/nvim-treesitter-refactor",
  --     },
  --     -- keys = { { "gp" } },
  --     config = function()
  --         require("navigator").setup()
  --     end,
  -- },
}
