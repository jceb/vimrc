map = vim.keymap.set
unmap = vim.keymap.set

return {
  ----------------------
  -- git
  ----------------------
  {
    -- https://github.com/tpope/vim-dispatch
    "tpope/vim-dispatch",
    lazy = true,
    cmd = { "Dispatch", "Make", "Focus", "Start" },
  },
  {
    -- Give this a try:
    -- use {"TimUntersberger/neogit"}
    -- https://github.com/tpope/vim-fugitive
    "tpope/vim-fugitive",
    lazy = true,
    cmd = {
      "GBrowse",
      "GMove",
      "GSplit",
      "Gclog",
      "Gdiffsplit",
      "Gedit",
      "Git",
      "Gmove",
      "Gremove",
      "Gsplit",
      "Gwrite",
    },
    keys = {
      "<leader>bh",
      "<leader>g!",
      "<leader>gB",
      "<leader>gC",
      "<leader>gc",
      "<leader>GD",
      "<leader>gD",
      "<leader>gd",
      "<leader>ge",
      "<leader>gh",
      "<leader>gi",
      "<leader>gL",
      "<leader>gl",
      "<leader>gm",
      "<leader>gp",
      "<leader>gs",
      "<leader>gu",
      "<leader>gw",
      "<leader>gx",
    },
    ft = { "fugitive" },
    config = function()
      vim.cmd("autocmd BufReadPost fugitive://* set bufhidden=delete")
      -- vim.cmd([[
      --   function! LightLineFugitive()
      --   if exists('*fugitive#Head')
      --     let l:_ = fugitive#Head()
      --     return strlen(l:_) > 0 ? l:_ . ' ' : ''
      --     endif
      --     return ''
      --     endfunction
      --     ]])
      -- vim.cmd([[
      --     let g:lightline.active.left[1] = [ "bomb", "diff", "scrollbind", "noeol", "readonly", "fugitive", "filename", "modified" ]
      --     let g:lightline.component_function.fugitive = "LightLineFugitive"
      --     call lightline#init()
      --     ]])
      map("n", "<leader>bh", "<cmd>Git log --oneline %<CR>", { noremap = true })
      map("n", "<leader>g!", "<cmd>Git checkout %<CR>", { noremap = true })
      map("n", "<leader>gB", "<cmd>Git blame<CR>", { noremap = true })
      map("n", "<leader>gC", "<cmd>Git commit -s<CR>", { noremap = true })
      map("n", "<leader>gc", "<cmd>Git commit<CR>", { noremap = true })
      map("n", "<leader>GD", "<cmd>Gdiffsplit! HEAD<CR>", { noremap = true })
      map("n", "<leader>gD", "<cmd>Gdiffsplit! HEAD<CR>", { noremap = true })
      map("n", "<leader>gd", "<cmd>Gdiffsplit!<CR>", { noremap = true })
      map("n", "<leader>gE", ":e .git/COMMIT_EDITMSG<CR>", { noremap = true })
      map("n", "<leader>ge", "<cmd>Gedit<CR>", { noremap = true })
      map("n", "<leader>gh", "<cmd>Git log --oneline<CR>", { noremap = true })
      map("n", "<leader>gi", "<cmd>FloatermNew lazygit<CR>", { noremap = true })
      -- map("n", "<leader>gl", "<cmd>0Gclog<CR>", { noremap = true })
      -- map("n", "<leader>gL", "<cmd>Gclog<CR>", { noremap = true })
      map("n", "<leader>gm", ":<C-u>Gmove ", { noremap = true })
      map("n", "<leader>gp", "<cmd>exec 'Dispatch! -dir='.fnameescape(HereDir()).' git push'<CR>", { noremap = true })
      map("n", "<leader>gs", "<cmd>Git<CR>", { noremap = true })
      map("n", "<leader>gu", "<cmd>exec 'Dispatch! -dir='.fnameescape(HereDir()).' git pre'<CR>", { noremap = true })
      map("n", "<leader>gw", "<cmd>Gwrite<CR>", { noremap = true })
      map("n", "<leader>gx", "<cmd>Git commit --no-verify<CR>", { noremap = true })
    end,
  },
}
