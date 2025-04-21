return {
  -- https://github.com/stevearc/aerial.nvim
  "stevearc/aerial.nvim",
  cmd = { "AerialToggle", "AerialNavToggle" },
  keys = {
    { "<leader>v", "<cmd>AerialOpen<CR>" },
    { "<leader>V", "<cmd>AerialToggle<CR>" },
  },
  config = function()
    require("aerial").setup({
      -- one window for all buffers
      attach_mode = "global",
      layout = {
        min_width = 20,
        placement = "edge",
      },
    })
  end,
}
