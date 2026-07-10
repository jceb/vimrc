return {
  -- https://github.com/direnv/direnv.vim
  "direnv/direnv.vim",
  init = function()
    -- disable direnv as it is too slow - just keep the syntax highlighting
    vim.g.loaded_direnv = true
  end,
}
