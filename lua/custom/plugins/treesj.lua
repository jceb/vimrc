return {
  -- https://github.com/Wansmer/treesj
  "Wansmer/treesj",
  keys = { "<leader>tM", "<leader>tJ", "<leader>tS" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("treesj").setup({
      use_default_keymaps = false,
    })
    vim.keymap.set("n", "<leader>tM", require("treesj").toggle)
    vim.keymap.set("n", "<leader>tJ", require("treesj").join)
    vim.keymap.set("n", "<leader>tS", require("treesj").split)
  end,
}
