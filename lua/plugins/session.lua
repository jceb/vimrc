map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

return {
  ----------------------
  -- session management
  ----------------------
  -- {
  --     -- https://github.com/tpope/vim-obsession
  --     -- Replaced by mini.sessions
  --     "tpope/vim-obsession",
  --     -- lazy = false,
  --     -- cmd = {"Obsession"}
  -- },
  {
    -- https://github.com/jceb/vim-cd
    "jceb/vim-cd",
  },
  {
    -- https://github.com/jceb/vim-editqf
    "jceb/vim-editqf",
    cmd = { "QFAddNote" },
  },
}
