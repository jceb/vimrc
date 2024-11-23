return {
  -- https://github.com/vasconcelloslf/vim-interestingwords
  "vasconcelloslf/vim-interestingwords",
  keys = { { "<leader>i", '<cmd>call InterestingWords("n")<CR>' }, { "<leader>i", '<cmd>call InterestingWords("v")<CR>', mode = "v" } },
  init = function()
    vim.g.interestingWordsDefaultMappings = 0
    vim.cmd([[
        command! InterestingWordsClear :call UncolorAllWords()
      ]])
  end,
}
