local map = vim.keymap.set
return {
  -- https://github.com/tpope/vim-characterize
  "tpope/vim-characterize",
  keys = { { "ga" } },
  config = function()
    map("n", "ga", "<Plug>(characterize)", {})
  end,
}
