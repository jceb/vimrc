return {
  -- https://github.com/ixru/nvim-markdown.git
  "ixru/nvim-markdown",
  ft = { "markdown" },
  -- config = function()
  -- end,
  init = function()
    vim.g.vim_markdown_conceal = 0 -- disable concealing of text
    vim.g.vim_markdown_frontmatter = 1
    vim.g.markdown_fenced_languages = {
      "bash=sh",
      "css",
      "html",
      "javascript",
      "json",
      "python",
      "yaml",
      "toml",
      "nu",
    }
  end,
}
