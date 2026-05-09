return {
  -- https://github.com/voldikss/vim-floaterm
  "voldikss/vim-floaterm",
  cmd = {
    "FloatermToggle",
    "FloatermNew",
    "FloatermPrev",
    "FloatermNext",
  },
  -- keys = { { "<M-/>" } },
  init = function()
    vim.g.floaterm_autoclose = 1
    -- vim.g.floaterm_shell = "fish"
    vim.g.floaterm_shell = "nu"
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
    vim.keymap.set(
      "n",
      "<leader>bH",
      "<cmd>exec 'FloatermNew --cwd='.fnameescape(substitute(expand('%:h:p'), 'oil://', '', '')).' tig '.fnameescape(substitute(expand('%:p'), 'oil://', '', ''))<CR>",
      { noremap = true }
    )
    vim.keymap.set("n", "<leader>bt", "<cmd>exec 'FloatermNew --cwd='.fnameescape(substitute(expand('%:h:p'), 'oil://', '', ''))<CR>", { noremap = true })
    vim.keymap.set(
      "n",
      "<leader>N",
      "<cmd>exec 'FloatermNew --cwd='.fnameescape(substitute(expand('%:h:p'), 'oil://', '', '')).' nnn -Q'<CR>",
      { noremap = true }
    )
    vim.keymap.set("n", "<leader>TF", "<cmd>exec 'FloatermNew --cwd='.fnameescape(substitute(expand('%:h:p'), 'oil://', '', ''))<CR>", { noremap = true })
    vim.keymap.set(
      "n",
      "<leader>bH",
      "<cmd>exec 'FloatermNew --cwd='.fnameescape(substitute(expand('%:h:p'), 'oil://', '', '')).' tig '.fnameescape(substitute(expand('%:p'), 'oil://', '', ''))<CR>",
      { noremap = true }
    )
    vim.keymap.set("n", "<leader>bt", "<cmd>exec 'FloatermNew --cwd='.fnameescape(substitute(expand('%:h:p'), 'oil://', '', ''))<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>gI", "<cmd>exec 'FloatermNew --cwd='.fnameescape(GetRootDir()).' lazygit'<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>gi", "<cmd>FloatermNew lazygit<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>n", "<cmd>FloatermNew nnn -Q<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>ptF", "<cmd>exec 'FloatermNew --cwd='.fnameescape(GetRootDir())<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>ptf", "<cmd>exec 'FloatermNew --cwd=<root>'<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>tF", "<cmd>exec 'FloatermNew --cwd='.fnameescape(substitute(expand('%:h:p'), 'oil://', '', ''))<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>tf", "<cmd>FloatermNew<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>fy", "<cmd>FloatermNew yazi<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>fn", "<cmd>FloatermNew nnn<CR>", { noremap = true })
  end,
  config = function() end,
}
