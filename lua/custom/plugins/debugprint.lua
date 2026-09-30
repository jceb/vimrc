return {
  -- https://github.com/andrewferrier/debugprint.nvim
  "andrewferrier/debugprint.nvim",

  dependencies = {
    "nvim-mini/mini.nvim", -- Optional: Needed for line highlighting (full mini.nvim plugin)
    -- "nvim-mini/mini.hipatterns",   -- Optional: Needed for line highlighting ('fine-grained' hipatterns plugin)
    "nvim-telescope/telescope.nvim", -- Optional: If you want to use the `:Debugprint search` command with telescope.nvim
  },
  -- opts = {
  --   keymaps = {
  --     normal = {
  --       plain_below = "g?p",
  --       plain_above = "g?P",
  --       variable_below = "g?v",
  --       variable_above = "g?V",
  --       variable_below_alwaysprompt = nil,
  --       variable_above_alwaysprompt = nil,
  --       textobj_below = "g?o",
  --       textobj_above = "g?O",
  --       toggle_comment_debug_prints = nil,
  --       delete_debug_prints = nil,
  --     },
  --     visual = {
  --       variable_below = "g?v",
  --       variable_above = "g?V",
  --     },
  --   },
  --   commands = {
  --     toggle_comment_debug_prints = "ToggleCommentDebugPrints",
  --     delete_debug_prints = "DeleteDebugPrints",
  --   },
  --   },
  lazy = false, -- Required to make line highlighting work before debugprint is first used
  version = "*", -- Remove if you DON'T want to use the stable version
}
