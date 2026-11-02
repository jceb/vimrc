return {
  -- https://github.com/ray-x/go.nvim
  "ray-x/go.nvim",
  dependencies = {
    {
      -- https://github.com/ray-x/guihua.lua
      "ray-x/guihua.lua",
      -- build = { "cd lua/fzy; make" },
      -- https://github.com/neovim/nvim-lspconfig
      "neovim/nvim-lspconfig",
    },
  },
  ft = { "go", "gomod" },
  -- build = { ":GoUpdateBinaries" },
  build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  event = { "CmdlineEnter" },
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
