return { -- Adds git related signs to the gutter, as well as utilities for managing changes
  -- https://github.com/lewis6991/gitsigns.nvim
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
  },
}
