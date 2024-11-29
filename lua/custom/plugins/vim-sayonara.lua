return {
  -- https://github.com/mhinz/vim-sayonara
  "mhinz/vim-sayonara",
  cmd = { "Sayonara" },
  keys = {
    "<leader>D",
    "<leader>d",
    "<leader>bd",
  },
  config = function()
    vim.keymap.set("n", "<leader>D", "<cmd>Sayonara!<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>d", "<cmd>Sayonara<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>wd", "<cmd>Sayonara<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>bd", "<cmd>Sayonara!<CR>", { noremap = true })
  end,
}
