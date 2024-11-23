return {
  -- https://github.com/NTBBloodbath/rest.nvim
  "NTBBloodbath/rest.nvim",
  dependencies = {
    -- https://github.com/nvim-lua/plenary.nvim
    "nvim-lua/plenary.nvim",
    {
      -- https://github.com/vhyrro/luarocks.nvim
      "vhyrro/luarocks.nvim",
      priority = 1000,
      config = true,
      opts = {
        rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
      },
    },
  },
  -- FIXMED: opt doesn't seem to work
  ft = { "http" },
  config = function()
    require("rest-nvim").setup()
    vim.cmd([[
        au FileType http nmap <buffer> <silent> <C-j> <Plug>RestNvim
        au FileType http nmap <buffer> <silent> <C-q> <Plug>RestNvimPreview
        ]])
  end,
}
