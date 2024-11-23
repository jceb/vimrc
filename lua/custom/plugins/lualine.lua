return {
  -- https://github.com/hoob3rt/lualine.nvim
  "hoob3rt/lualine.nvim",
  dependencies = {
    -- https://github.com/nvim-tree/nvim-web-devicons
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  config = function()
    require("lualine").setup()
  end,
}
