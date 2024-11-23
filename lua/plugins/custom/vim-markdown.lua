return {
  -- https://github.com/tpope/vim-markdown
  "tpope/vim-markdown",
  ft = { "markdown" },
  config = function()
    vim.g.markdown_fenced_languages = {
      "bash=sh",
      "css",
      "html",
      "javascript",
      "json",
      "python",
      "yaml",
      "nu",
    }
  end,
}
