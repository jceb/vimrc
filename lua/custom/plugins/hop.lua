return {
  -- https://github.com/phaazon/hop.nvim
  "phaazon/hop.nvim",
  branch = "v2", -- optional but strongly recommended
  keys = {
    { "s", "<cmd>HopChar1AC<cr>" },
    { "S", "<cmd>HopChar1BC<cr>" },
    { "s", "<cmd>HopChar1AC<cr>", { mode = "o" } },
    { "S", "<cmd>HopChar1BC<cr>", { mode = "o" } },
  },
  config = function()
    -- you can configure Hop the way you like here; see :h hop-config
    -- require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
    require("hop").setup()
    -- map("n", "<leader>/", "/", { noremap = true })
    -- map("n", "<leader>?", "?", { noremap = true })
    -- map("n", "s", "<cmd>HopChar1AC<cr>", {})
    -- map("n", "S", "<cmd>HopChar1BC<cr>", {})
    -- map("o", "s", "<cmd>HopChar1AC<cr>", {})
    -- map("o", "S", "<cmd>HopChar1BC<cr>", {})
    -- map("n", "/", "<cmd>HopChar2AC<cr>", {})
    -- map("n", "?", "<cmd>HopChar2BC<cr>", {})
    -- map("o", "/", "<cmd>HopChar2AC<cr>", {})
    -- map("o", "?", "<cmd>HopChar2BC<cr>", {})
  end,
}
