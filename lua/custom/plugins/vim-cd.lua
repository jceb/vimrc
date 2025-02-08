return {
  -- https://github.com/jceb/vim-cd
  "jceb/vim-cd",
  init = function()
    vim.g.root_elements = { ".git", ".hg", ".svn" }
  end,
}
