return {
  -- https://github.com/mjbrownie/swapit
  "mjbrownie/swapit",
  dependencies = {
    {
      -- https://github.com/tpope/vim-speeddating
      "tpope/vim-speeddating",
      name = "speeddating",
      init = function()
        local opts = { noremap = true, silent = true }
        vim.g.speeddating_no_mappings = 1
        vim.keymap.set("n", "<Plug>SpeedDatingFallbackUp", "<C-a>", opts)
        vim.keymap.set("n", "<Plug>SpeedDatingFallbackDown", "<C-x>", opts)
      end,
    },
  },
  keys = {
    "<Plug>SwapItFallbackIncrement",
    "<Plug>SwapItFallbackDecrement",
    "<C-a>",
    "<C-x>",
    "<C-t>",
  },
  -- init = function(plugin)
  --   vim.fn["SwapWord"] = function(...)
  --     vim.fn["SwapWord"] = nil
  --     require("lazy").load({ plugins = { plugin } })
  --     return vim.fn["SwapWord"](...)
  --   end
  -- end,
  config = function()
    local opts = { silent = true }
    vim.keymap.set("n", "<Plug>SwapItFallbackIncrement", ":<C-u>let sc=v:count1<Bar>call speeddating#increment(sc)<Bar>unlet sc<CR>", opts)
    vim.keymap.set("n", "<Plug>SwapItFallbackDecrement", ":<C-u>let sc=v:count1<Bar>call speeddating#increment(-sc)<Bar>unlet sc<CR>", opts)
    vim.keymap.set(
      "n",
      "<C-a>",
      ':<C-u>let swap_count = v:count<Bar>call SwapWord(expand("<cword>"), swap_count, "forward", "no")<Bar>silent! call repeat#set("\\<Plug>SwapIncrement", swap_count)<Bar>unlet swap_count<CR>',
      opts
    )
    vim.keymap.set(
      "n",
      "<C-x>",
      ':<C-u>let swap_count = v:count<Bar>call SwapWord(expand("<cword>"), swap_count, "backward","no")<Bar>silent! call repeat#set("\\<Plug>SwapDecrement", swap_count)<Bar>unlet swap_count<CR>',
      opts
    )
  end,
}
