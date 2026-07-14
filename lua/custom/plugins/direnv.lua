return {
  -- https://github.com/direnv/direnv.vim
  "direnv/direnv.vim",
  init = function()
    -- disable direnv auto loading as it is too slow
    -- Manually execute this command to load direnv: :DirenvExport
    vim.g.direnv_auto = false
  end,
}
