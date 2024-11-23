return {
  -- https://github.com/andymass/vim-matchup
  "andymass/vim-matchup",
  event = "VimEnter",
  setup = function()
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
  end,
}
