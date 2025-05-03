return {
  -- https://github.com/tzachar/highlight-undo.nvim
  "tzachar/highlight-undo.nvim",
  opts = {
    duration = 200,
    undo = {
      hlgroup = "MatchParen",
      mode = "n",
      lhs = "u",
      map = "undo",
      opts = {},
    },
    redo = {
      hlgroup = "MatchParen",
      mode = "n",
      lhs = "<C-r>",
      map = "redo",
      opts = {},
    },
    highlight_for_count = true,
  },
}
