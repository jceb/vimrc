return {
  -- https://github.com/tpope/vim-eunuch
  "tpope/vim-eunuch",
  cmd = {
    "Remove",
    "Unlink",
    "Move",
    "Rename",
    "Delete",
    "Chmod",
    "SudoEdit",
    "SudoWrite",
    "Mkdir",
  },
  config = function()
    vim.keymap.set("n", "<leader>se", ":<C-u>SudoEdit", { noremap = true })
    vim.keymap.set("n", "<leader>sw", "<cmd>SudoWrite<CR>", { noremap = true })
  end,
}
