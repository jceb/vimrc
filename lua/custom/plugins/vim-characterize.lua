return {
  -- https://github.com/tpope/vim-characterize
  "tpope/vim-characterize",
  keys = { { "ga" } },
  config = function()
    vim.keymap.set("n", "ga", "<Plug>(characterize)", {})
  end,
}
