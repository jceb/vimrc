map = vim.api.nvim_set_keymap
unmap = vim.api.nvim_del_keymap

return {
  ----------------------
  -- copy / paste
  ----------------------
  {
    -- https://github.com/svermeulen/vim-yoink
    "svermeulen/vim-yoink",
    lazy = true,
    keys = {
      { "p" },
      { "P" },
      { "<M-n>" },
      { "<M-p>" },
    },
    config = function()
      vim.g.yoinkAutoFormatPaste = 0       -- this doesn't work properly, so fix it to <F11> manualy
      vim.g.yoinkMaxItems = 20

      map("n", "<M-n>", "<plug>(YoinkPostPasteSwapBack)", {})
      map("n", "<M-p>", "<plug>(YoinkPostPasteSwapForward)", {})
      map("n", "p", "<plug>(YoinkPaste_p)", {})
      map("n", "P", "<plug>(YoinkPaste_P)", {})
    end,
  },
}
