return {
  -- https://github.com/xiyaowong/nvim-cursorword
  -- Replaced by mini.cursorword
  "xiyaowong/nvim-cursorword",
  init = function()
    vim.cmd([[
      hi link CursorWord DiffAdd
      augroup MyCursorWord
      autocmd!
      autocmd VimEnter,Colorscheme * hi link CursorWord DiffAdd
      augroup END
      ]])
  end,
}
