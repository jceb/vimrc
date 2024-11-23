return {
  -- https://github.com/junegunn/vim-easy-align
  "junegunn/vim-easy-align",
  keys = { { "<Plug>(EasyAlign)" }, { "<Plug>(EasyAlign)", mode = "x" } },
  init = function()
    map("x", "g=", "<Plug>(EasyAlign)", {})
    map("n", "g=", "<Plug>(EasyAlign)", {})
    map("n", "g/", "g=ip*|", {})
  end,
  -- config = function() end,
}
