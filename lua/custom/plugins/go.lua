return {
  -- https://github.com/ray-x/go.nvim
  "ray-x/go.nvim",
  dependencies = {
    {
      -- https://github.com/ray-x/guihua.lua
      "ray-x/guihua.lua",
      -- build = { "cd lua/fzy; make" },
    },
  },
  ft = { "go" },
  build = { ":GoUpdateBinaries" },
  config = function()
    -- TODO: integrate debugging: https://github.com/ray-x/go.nvim#debug-with-dlv
    require("go").setup({})
    vim.cmd([[
        " nmap <C-]> gd
        au Filetype go
        \  exec "command! -bang A GoAlt"
        \ | exec "command! -bang AV GoAltV"
        \ | exec "command! -bang AS GoAltS"
        ]])
  end,
}
