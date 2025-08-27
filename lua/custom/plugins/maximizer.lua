local map = vim.keymap.set
return {
  -- https://github.com/0x00-ketsu/maximizer.nvim
  "0x00-ketsu/maximizer.nvim",
  keys = {
    "<leader>z",
  },
  config = function()
    require("maximizer").setup({
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    })
    map("n", "<leader>z", "<cmd>lua require('maximizer').toggle()<CR>", { noremap = true, silent = true })
    -- vim.api.nvim_set_keymap(
    --     "n",
    --     "<leader>z",
    --     '<cmd>lua require("maximizer").toggle()<CR>',
    --     { silent = true, noremap = true }
    -- )
  end,
}
