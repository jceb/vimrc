return {
  -- https://github.com/tpope/vim-surround
  -- Replaced by mini.surround
  "tpope/vim-surround",
  keys = {
    { "ys" },
    { "yss" },
    { "ds" },
    { "cs" },
    { "S", mode = "v" },
  },
  init = function()
    vim.g.surround_no_insert_mappings = 1
  end,
}
