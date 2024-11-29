return {
  -- https://github.com/kevinhwang91/nvim-ufo
  "kevinhwang91/nvim-ufo",
  dependencies = {
    -- https://github.com/kevinhwang91/promise-async
    "kevinhwang91/promise-async",
  },
  keys = {
    "zR",
    "zM",
  },
  init = function()
    vim.o.foldcolumn = "1" -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
  config = function()
    -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
    vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    -- Seems to do nothing:
    -- vim.cmd([[
    --   hi default link UfoCursorFoldedLine Folded
    --   hi default link UfoFoldedFg Folded
    --   hi default link UfoFoldedBg Folded
    --   hi default link UfoFoldedEllipsis Folded
    -- ]])
    require("ufo").setup({
      open_fold_hl_timeout = 0,
      preview = {
        win_config = {
          winhighlight = "Normal:Folded",
          winblend = 0,
        },
      },
    })
  end,
}
