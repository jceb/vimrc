return {
  -- https://github.com/wsdjeg/hop.nvim
  "wsdjeg/hop.nvim",
  version = "*",
  opts = {
    keys = "etovxqpdygfblzhckisuran",
  },
  keys = {
    -- Restore original behavior of certain z.. mappings
    { "s", "<cmd>HopChar1<cr>" },
    { "s", "<cmd>HopChar1<cr>", { mode = "o" } },
    -- { "s", "<cmd>HopChar1AC<cr>" },
    -- { "S", "<cmd>HopChar1BC<cr>" },
    -- { "s", "<cmd>HopChar1AC<cr>", { mode = "o" } },
    -- { "S", "<cmd>HopChar1BC<cr>", { mode = "o" } },
  },
}
