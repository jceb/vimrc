return {
  -- https://github.com/dbeniamine/cheat.sh-vim
  "dbeniamine/cheat.sh-vim",
  cmd = { "Cheat" },
  init = function()
    vim.g.CheatSheetDoNotMap = 1
    vim.g.CheatDoNotReplaceKeywordPrg = 1
  end,
}
