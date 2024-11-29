return {
  -- https://github.com/vim-scripts/diffwindow_movement
  "vim-scripts/diffwindow_movement",
  dependencies = {
    -- https://github.com/inkarkat/vim-CountJump
    "inkarkat/vim-CountJump",
    -- https://github.com/inkarkat/vim-ingo-library
    "inkarkat/vim-ingo-library",
  },
  config = function()
    local opts = { noremap = true }
    vim.keymap.set(
      "n",
      "]J",
      ':<C-u>call CountJump#JumpFunc("n", "CountJump#Region#JumpToNextRegion", function("diffwindow_movement#IsDiffLine"), 1, 1, 1, 0)<CR>',
      opts
    )
    vim.keymap.set(
      "n",
      "[J",
      ':<C-u>call CountJump#JumpFunc("n", "CountJump#Region#JumpToNextRegion", function("diffwindow_movement#IsDiffLine"), 1, -1, 0, 0)<CR>',
      opts
    )
  end,
}
