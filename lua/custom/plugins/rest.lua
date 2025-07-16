return {
  -- https://github.com/NTBBloodbath/rest.nvim
  "NTBBloodbath/rest.nvim",
  dependencies = {
    -- https://github.com/nvim-neotest/nvim-nio
    "nvim-neotest/nvim-nio",
    -- -- https://github.com/nvim-lua/plenary.nvim
    -- "nvim-lua/plenary.nvim",
    -- {
    --   -- https://github.com/vhyrro/luarocks.nvim
    --   "vhyrro/luarocks.nvim",
    --   priority = 1000,
    --   config = true,
    --   opts = {
    --     rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
    --   },
    -- },
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "http")
    end,
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
