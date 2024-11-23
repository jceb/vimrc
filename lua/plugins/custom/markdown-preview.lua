return {
  -- https://github.com/iamcco/markdown-preview.nvim
  "iamcco/markdown-preview.nvim",
  build = { "cd app; yarn install" },
  ft = { "markdown" },
  config = function()
    vim.cmd("doau BufEnter")
  end,
}
