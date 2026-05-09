return {
  -- https://github.com/junegunn/vim-easy-align
  "junegunn/vim-easy-align",
  keys = { { "<Plug>(EasyAlign)" }, { "<Plug>(EasyAlign)", mode = "x" } },
  init = function()
    vim.keymap.set("x", "g=", "<Plug>(EasyAlign)", {})
    vim.keymap.set("n", "g=", "<Plug>(EasyAlign)", {})
    vim.keymap.set("n", "g/", "g=ip*|", {})
  end,
  -- config = function() end,
}
