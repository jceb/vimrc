return {
  -- https://github.com/stevearc/aerial.nvim
  "stevearc/aerial.nvim",
  cmd = { "AerialToggle" },
  config = function()
    require("aerial").setup({})
  end,
}
