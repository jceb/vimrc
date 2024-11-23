return {
  -- TODO: not yet fully configured
  -- https://github.com/ray-x/navigator.lua
  "ray-x/navigator.lua",
  dependencies = {
    {
      -- https://github.com/ray-x/guihua.lua
      "ray-x/guihua.lua",
      build = "cd lua/fzy; make",
    },
    -- https://github.com/nvim-treesitter/nvim-treesitter-refactor
    "nvim-treesitter/nvim-treesitter-refactor",
  },
  -- keys = { { "gp" } },
  config = function()
    require("navigator").setup()
  end,
}
