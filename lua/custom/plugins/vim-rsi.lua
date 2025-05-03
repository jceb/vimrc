return {
  -- https://github.com/tpope/vim-rsi
  "tpope/vim-rsi",
  init = function()
    vim.g.rsi_no_meta = 1
    vim.keymap.set("c", "<M-b>", "<C-Left>", { noremap = true })
    vim.keymap.set("c", "<M-f>", "<C-Right>", { noremap = true })
  end,
}
