return {
  -- https://github.com/kassio/neoterm
  "kassio/neoterm",
  event = { "TermOpen" },
  cmd = { "Tnew" },
  keys = {
    { "<leader>ptS", "<cmd>split +TnewProjectHere<CR>", { noremap = true } },
    { "<leader>ptT", "<cmd>tabe +TnewProjectHere<CR>", { noremap = true } },
    { "<leader>ptV", "<cmd>vsplit +TnewProjectHere<CR>", { noremap = true } },
    { "<leader>pts", "<cmd>split +TnewProject<CR>", { noremap = true } },
    { "<leader>ptt", "<cmd>tabe +TnewProject<CR>", { noremap = true } },
    { "<leader>ptv", "<cmd>vsplit +TnewProject<CR>", { noremap = true } },
    { "<leader>tS", "<cmd>split +TnewHere<CR>", { noremap = true } },
    { "<leader>TS", "<cmd>split +TnewHere<CR>", { noremap = true } },
    { "<leader>ts", "<cmd>split +Tnew<CR>", { noremap = true } },
    { "<leader>tT", "<cmd>tabe +TnewHere<CR>", { noremap = true } },
    { "<leader>TT", "<cmd>tabe +TnewHere<CR>", { noremap = true } },
    { "<leader>tt", "<cmd>tabe +Tnew<CR>", { noremap = true } },
    { "<leader>TV", "<cmd>vsplit +TnewHere<CR>", { noremap = true } },
    { "<leader>tV", "<cmd>vsplit +TnewHere<CR>", { noremap = true } },
    { "<leader>tv", "<cmd>vsplit +Tnew<CR>", { noremap = true } },
    { "<leader>tr", "<cmd>call neoterm#repl#term(b:neoterm_id)<CR>", { noremap = true } },
    { "<leader>r", "<cmd><Plug>(neoterm-repl-send)!<CR>", { mode = "x" } },
    { "<leader>r", "<Plug>(neoterm-repl-send-line)", {} },
    { "<leader>R", "<Plug>(neoterm-repl-send)", {} },
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
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      -- vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
      -- vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
    end
    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
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
}
