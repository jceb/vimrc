return {
  -- https://github.com/rktjmp/highlight-current-n.nvim
  "rktjmp/highlight-current-n.nvim",
  keys = { { "n" }, { "N" } },
  config = function()
    vim.cmd([[
        nmap n <Plug>(highlight-current-n-n)
        nmap N <Plug>(highlight-current-n-N)
        ]])
  end,
}
