return {
  -- https://github.com/jceb/jiejie.git
  "jceb/jiejie.nvim",
  -- ft = {
  --   "jiejie",
  -- },
  -- cmd = {
  --   "J",
  --   "Jj",
  --   "Jedit",
  -- },
  -- keys = {
  --   "<leader>yy",
  --   "<leader>ye",
  --   "<leader>yt",
  -- },
  config = function()
    vim.keymap.set("n", "<leader>yy", "<cmd>vertical Jj<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>ye", "<cmd>Jedit<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>yt", "<cmd>Jj tug<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>yr", "<cmd>Jj rm<CR>", { noremap = true })
  end,
}
