map = vim.keymap.set
unmap = vim.keymap.set

return {
  ----------------------
  -- Terminal
  ----------------------
  {
    -- https://github.com/kassio/neoterm
    "kassio/neoterm",
    lazy = false,
    cmd = { "Tnew" },
    keys = {
      { "<leader>ptS", "<cmd>split +TnewProjectHere<CR>",               { noremap = true } },
      { "<leader>ptT", "<cmd>tabe +TnewProjectHere<CR>",                { noremap = true } },
      { "<leader>ptV", "<cmd>vsplit +TnewProjectHere<CR>",              { noremap = true } },
      { "<leader>pts", "<cmd>split +TnewProject<CR>",                   { noremap = true } },
      { "<leader>ptt", "<cmd>tabe +TnewProject<CR>",                    { noremap = true } },
      { "<leader>ptv", "<cmd>vsplit +TnewProject<CR>",                  { noremap = true } },
      { "<leader>tS",  "<cmd>split +TnewHere<CR>",                      { noremap = true } },
      { "<leader>TS",  "<cmd>split +TnewHere<CR>",                      { noremap = true } },
      { "<leader>ts",  "<cmd>split +Tnew<CR>",                          { noremap = true } },
      { "<leader>tT",  "<cmd>tabe +TnewHere<CR>",                       { noremap = true } },
      { "<leader>TT",  "<cmd>tabe +TnewHere<CR>",                       { noremap = true } },
      { "<leader>tt",  "<cmd>tabe +Tnew<CR>",                           { noremap = true } },
      { "<leader>TV",  "<cmd>vsplit +TnewHere<CR>",                     { noremap = true } },
      { "<leader>tV",  "<cmd>vsplit +TnewHere<CR>",                     { noremap = true } },
      { "<leader>tv",  "<cmd>vsplit +Tnew<CR>",                         { noremap = true } },
      { "<leader>tr",  "<cmd>call neoterm#repl#term(b:neoterm_id)<CR>", { noremap = true } },
      { "<leader>r",   "<cmd><Plug>(neoterm-repl-send)!<CR>",           { mode = "x" } },
      { "<leader>r",   "<Plug>(neoterm-repl-send-line)",                {} },
      { "<leader>R",   "<Plug>(neoterm-repl-send)",                     {} },
    },
    init = function()
      vim.g.neoterm_direct_open_repl = 0
      vim.g.neoterm_open_in_all_tabs = 1
      vim.g.neoterm_autoscroll = 1
      vim.g.neoterm_term_per_tab = 1
      -- vim.g.neoterm_shell = "fish"
      vim.g.neoterm_shell = "nu"
      vim.g.neoterm_autoinsert = 1
      vim.g.neoterm_automap_keys = "<F23>"
    end,
    config = function()
      -- taken from https://github.com/folke/lazy.nvim/issues/574
      -- vim.fn["neoterm#new"] = function(...)
      --     vim.fn["neoterm#new"] = nil
      --     require("lazy").load({ plugins = { plugin } })
      --     print("gogog")
      --     return vim.fn["neoterm#new"](...)
      -- end
      vim.cmd([[
        function! TnewHere()
            call neoterm#new({ 'cwd': HereDir() })
        endfunction
        command! -nargs=0 TnewHere :call TnewHere()

        function! TnewProject()
            call neoterm#new({ 'cwd': GetRootDir(getcwd()) })
        endfunction
        command! -nargs=0 TnewProject :call TnewProject()

        function! TnewProjectHere()
            call neoterm#new({ 'cwd': HereDir() })
        endfunction
        command! -nargs=0 TnewProjectHere :call TnewProjectHere()
      ]])
    end,
  },
  {
    -- https://github.com/voldikss/vim-floaterm
    "voldikss/vim-floaterm",
    lazy = true,
    cmd = {
      "FloatermToggle",
      "FloatermNew",
      "FloatermPrev",
      "FloatermNext",
    },
    keys = { { "<M-/>" } },
    init = function()
      vim.g.floaterm_autoclose = 1
      -- vim.g.floaterm_shell = "fish"
      vim.g.floaterm_shell = "nu"
    end,
    config = function()
      vim.cmd([[
        tnoremap <silent> <M-h> <C-\><C-n>:FloatermPrev<CR>
        tnoremap <silent> <M-l> <C-\><C-n>:FloatermNext<CR>
        nnoremap <silent> <M-/> :FloatermToggle<CR>
        tnoremap <silent> <M-/> <C-\><C-n>:FloatermToggle<CR>
        nnoremap <silent> <M-S-t> :exec "FloatermNew --cwd=".fnameescape(expand("%:h"))<CR>
        nnoremap <silent> <M-t> :FloatermNew<CR>
        tnoremap <silent> <M-t> <C-\><C-n>:FloatermNew<CR>
        nnoremap <silent> <M-S-e> :exec "FloatermNew --cwd=".fnameescape(expand("%:h"))." nnn -Q"<CR>
        nnoremap <silent> <M-e> :FloatermNew nnn -Q<CR>
        ]])
      map(
        "n",
        "<leader>bH",
        "<cmd>exec 'FloatermNew --cwd='.fnameescape(substitute(expand('%:h:p'), 'oil://', '', '')).' tig '.fnameescape(substitute(expand('%:p'), 'oil://', '', ''))<CR>",
        { noremap = true }
      )
      map("n", "<leader>bt",
        "<cmd>exec 'FloatermNew --cwd='.fnameescape(substitute(expand('%:h:p'), 'oil://', '', ''))<CR>",
        { noremap = true })
      map("n", "<leader>N",
        "<cmd>exec 'FloatermNew --cwd='.fnameescape(substitute(expand('%:h:p'), 'oil://', '', '')).' nnn -Q'<CR>",
        { noremap = true })
      map("n", "<leader>TF",
        "<cmd>exec 'FloatermNew --cwd='.fnameescape(substitute(expand('%:h:p'), 'oil://', '', ''))<CR>",
        { noremap = true })
      map(
        "n",
        "<leader>bH",
        "<cmd>exec 'FloatermNew --cwd='.fnameescape(substitute(expand('%:h:p'), 'oil://', '', '')).' tig '.fnameescape(substitute(expand('%:p'), 'oil://', '', ''))<CR>",
        { noremap = true }
      )
      map("n", "<leader>bt",
        "<cmd>exec 'FloatermNew --cwd='.fnameescape(substitute(expand('%:h:p'), 'oil://', '', ''))<CR>",
        { noremap = true })
      map("n", "<leader>gI", "<cmd>exec 'FloatermNew --cwd='.fnameescape(GetRootDir()).' lazygit'<CR>",
        { noremap = true })
      map("n", "<leader>gi", "<cmd>FloatermNew lazygit<CR>", { noremap = true })
      map("n", "<leader>n", "<cmd>FloatermNew nnn -Q<CR>", { noremap = true })
      map("n", "<leader>ptF", "<cmd>exec 'FloatermNew --cwd='.fnameescape(GetRootDir())<CR>", { noremap = true })
      map("n", "<leader>ptf", "<cmd>exec 'FloatermNew --cwd=<root>'<CR>", { noremap = true })
      map("n", "<leader>tF",
        "<cmd>exec 'FloatermNew --cwd='.fnameescape(substitute(expand('%:h:p'), 'oil://', '', ''))<CR>",
        { noremap = true })
      map("n", "<leader>tf", "<cmd>FloatermNew<CR>", { noremap = true })
    end,
  },
  -- use {
  --     -- https://github.com/akinsho/nvim-toggleterm.lua
  --     "akinsho/nvim-toggleterm.lua",
  --     lazy = true,
  --     cmd = {"ToggleTerm", "TermExec", "ToggleTermOpenAll", "ToggleTermCloseAll"},
  --     config = function()
  --         require("toggleterm").setup(
  --             {
  --                 -- size can be a number or function which is passed the current terminal
  --                 size = function(term)
  --                     if term.direction == "horizontal" then
  --                         return 15
  --                     elseif term.direction == "vertical" then
  --                         return vim.o.columns * 0.4
  --                     end
  --                 end,
  --                 open_mapping = [[<C-/>]],
  --                 hide_numbers = true, -- hide the number column in toggleterm buffers
  --                 shade_filetypes = {},
  --                 shade_terminals = false,
  --                 -- shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  --                 start_in_insert = true,
  --                 insert_mappings = true, -- whether or not the open mapping applies in insert mode
  --                 persist_size = true,
  --                 direction = "vertical", -- | "horizontal" | "window" | "float",
  --                 close_on_exit = true, -- close the terminal window when the process exits
  --                 -- shell = vim.o.shell, -- change the default shell
  --                 shell = "fish", -- change the default shell
  --                 -- This field is only relevant if direction is set to 'float'
  --                 float_opts = {
  --                     -- The border key is *almost* the same as 'nvim_win_open'
  --                     -- see :h nvim_win_open for details on borders however
  --                     -- the 'curved' border is a custom border type
  --                     -- not natively supported but implemented in this plugin.
  --                     border = "single", -- | "double" | "shadow" | "curved", -- | ... other options supported by win open
  --                     -- width = <value>,
  --                     -- height = <value>,
  --                     winblend = 3,
  --                     highlights = {
  --                         border = "Normal",
  --                         background = "Normal"
  --                     }
  --                 }
  --             }
  --         )
  --     end
  -- }
}
