return {
  -- https://github.com/folke/zen-mode.nvim
  "folke/zen-mode.nvim",
  cmd = { "ZenMode" },
  keys = {
    "<leader>Z",
  },
  config = function()
    require("zen-mode").setup({
      window = {
        width = 130,
      },
      options = {
        foldcolumn = "0",
        signcolumn = "no",
      },
    })
    map("n", "<leader>Z", "<cmd>ZenMode<CR>", { silent = true, noremap = true })
  end,
}
