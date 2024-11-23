return {
  -- https://github.com/szw/vim-maximizer
  "szw/vim-maximizer",
  cmd = { "MaximizerToggle" },
  config = function()
    vim.g.maximizer_restore_on_winleave = 1
  end,
}
