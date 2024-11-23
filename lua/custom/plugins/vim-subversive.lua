return {
  -- https://github.com/svermeulen/vim-subversive
  "svermeulen/vim-subversive",
  keys = {
    { "gr" },
    { "gR" },
    { "grr" },
    { "grs" },
    { "grs", mode = "x" },
    { "grss" },
  },
  config = function()
    vim.keymap.set("n", "gR", "<plug>(SubversiveSubstituteToEndOfLine)", {})
    vim.keymap.set("n", "gr", "<plug>(SubversiveSubstitute)", {})
    vim.keymap.set("n", "grr", "<plug>(SubversiveSubstituteLine)", {})
    vim.keymap.set("n", "grs", "<plug>(SubversiveSubstituteRange)", {})
    vim.keymap.set("x", "grs", "<plug>(SubversiveSubstituteRange)", {})
    vim.keymap.set("n", "grss", "<plug>(SubversiveSubstituteWordRange)", {})
  end,
}
