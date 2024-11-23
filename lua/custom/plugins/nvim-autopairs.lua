return {
  -- https://github.com/windwp/nvim-autopairs
  -- Replaced by mini.pairs
  "windwp/nvim-autopairs",
  keys = {
    { "{", mode = "i" },
    { "[", mode = "i" },
    { "(", mode = "i" },
    { "<", mode = "i" },
    { "'", mode = "i" },
    { '"', mode = "i" },
  },
  config = function()
    require("nvim-autopairs").setup({})
  end,
}
