return {
  -- https://github.com/tpope/vim-characterize
  "tpope/vim-characterize",
  keys = { { "ga" } },
  config = function()
    map("n", "ga", "<Plug>(characterize)", {})
  end,
}
